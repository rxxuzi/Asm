#!/bin/bash

VERSION="1.1.0"

show_usage() {
    echo "Usage:"
    echo "  -a [project name] -m [32|64]: Generate only .o and .obj files"
    echo "  -b [project name] -m [32|64]: Build the project and delete intermediate files"
    echo "  -c [project name] -m [32|64]: Compile the project and generate executable file"
    echo "  -q: Display this script usage"
    echo "  -r [project name]: Delete .obj, .o, and .exe files"
    echo "  -v: Display version information"
    echo "  -x [project name]: Delete all files of the project"
}

# デフォルトアーキテクチャをwin32に設定
ARCH="win32"

# コマンドラインオプションの解析
while getopts ":c:r:b:a:x:qvm:" opt; do
  case $opt in
    m)
      # アーキテクチャの指定（32または64）
      if [ "$OPTARG" == "64" ]; then
        ARCH="win64"
      elif [ "$OPTARG" == "32" ]; then
        ARCH="win32"
      else
        echo "Invalid architecture: -$OPTARG. Use 32 or 64."
        exit 1
      fi
      ;;
    c | b | a)
      BASENAME=$OPTARG

      # ファイル存在チェック
      if [ ! -f "asm/$BASENAME.asm" ] || [ ! -f "asm/$BASENAME.c" ]; then
          echo "Error: Source files not found."
          exit 1
      fi

      # 出力ディレクトリの確認と作成
      OBJ_DIR="asm-out"
      EXE_DIR="run"
      LOG_DIR="log"
      DATE=$(date +%Y-%m-%d)

      if [ ! -d "$OBJ_DIR" ]; then
          mkdir "$OBJ_DIR"
      fi
      if [ ! -d "$EXE_DIR" ]; then
          mkdir "$EXE_DIR"
      fi
      if [ ! -d "$LOG_DIR" ]; then
          mkdir "$LOG_DIR"
      fi

      # アーキテクチャに基づいてアセンブリファイルとCファイルをコンパイル
      if [ "$ARCH" == "win64" ]; then
          # Win64用のコンパイルオプション
          ./nasm/nasm.exe -f win64 asm/$BASENAME.asm -o $OBJ_DIR/$BASENAME.obj
          gcc -c asm/$BASENAME.c -o $OBJ_DIR/$BASENAME.o
      else
          # Win32用のコンパイルオプション
          ./nasm/nasm.exe -f win32 asm/$BASENAME.asm -o $OBJ_DIR/$BASENAME.obj
          gcc -c asm/$BASENAME.c -o $OBJ_DIR/$BASENAME.o
      fi


      # オブジェクトファイルをリンクして実行ファイルを作成（-c または -b の場合）
      if [ "$opt" == "c" ] || [ "$opt" == "b" ]; then
        gcc $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj -o $EXE_DIR/$BASENAME.exe
        if [ $? -ne 0 ]; then
            echo "$(date) - Error linking $BASENAME" >> $LOG_DIR/error-$DATE.log
            exit 1
        fi
      fi


      # -b の場合、中間ファイルを削除
      if [ "$opt" == "b" ]; then
        rm -f $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj
      fi
      ;;
    r)
      BASENAME=$OPTARG
      rm -f asm-out/$BASENAME.o asm-out/$BASENAME.obj run/$BASENAME.exe
      ;;
    x)
      BASENAME=$OPTARG
      rm -f asm/$BASENAME.asm asm/$BASENAME.c asm-out/$BASENAME.o asm-out/$BASENAME.obj run/$BASENAME.exe
      ;;
    q)
      show_usage
      ;;
    v)
      echo "asm : version: $VERSION"
      echo "nasm : version: $(./nasm/nasm.exe --version)"
      echo "gcc : version: $(gcc --version)"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_usage
      ;;
  esac
done

if [ "$#" -eq 0 ]; then
    show_usage
    exit 1
fi
