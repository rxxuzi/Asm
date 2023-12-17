#!/bin/bash

VERSION="1.5"

# デフォルト設定
PROJECT_DIR="asm"
OBJ_DIR="asm-out"
EXE_DIR="run"
LOG_DIR="log"

show_usage() {
    echo "Usage:"
    echo "  -a [project name] -m [32|64]: Generate only .o and .obj files for the specified project."
    echo "  -b [project name] -m [32|64]: Build the project, then delete intermediate files."
    echo "  -c [project name] -m [32|64]: Compile the project and create an executable file."
    echo "  -h: Display this help message."
    echo "  -r [project name]: Remove .obj, .o, and .exe files for the specified project."
    echo "  -v: Display version information of this script."
    echo "  -x [project name]: Delete all files associated with the specified project."
}

# デフォルトアーキテクチャをwin32に設定
ARCH="win32"

# コンパイルログを保存する関数
log_compile() {
    LOG_DIR="log"
    DATE=$(date +%Y-%m-%d)
    TIME=$(date +%H:%M:%S)
    LOG_FILE="$LOG_DIR/asm-$DATE.log"

    if [ ! -d "$LOG_DIR" ]; then
        mkdir "$LOG_DIR"
    fi

    echo "[$TIME] Project: $1, Architecture: $ARCH, Option: $2" >> $LOG_FILE
}

# エラーログを保存する関数
log_error() {
    LOG_DIR="log"
    DATE=$(date +%Y-%m-%d)
    TIME=$(date +%H:%M:%S)
    ERROR_LOG_FILE="$LOG_DIR/error-$DATE.log"

    if [ ! -d "$LOG_DIR" ]; then
        mkdir "$LOG_DIR"
    fi

    # アーキテクチャ ($3) とオプション ($4) が指定されていない場合は空文字列を使う
    ARCHITECTURE=${3:-}
    OPTION=${4:-}

    echo "[$TIME] Project: $1, Architecture: $ARCHITECTURE, Option: $OPTION, Error: $2" >> $ERROR_LOG_FILE
}


# ユーザーの入力を待ち、'q'が押された場合には引数で指定されたコードで終了する関数
confirm_exit() {
    read -p "Press any key to continue or 'q' to quit: " key
    if [[ $key = "q" ]]; then
        exit $1
    fi
}

# コマンドラインオプションの解析
while getopts ":c:r:b:a:x:hvm:" opt; do
  case $opt in
    m)
      # アーキテクチャの指定（32または64）
      if [ "$OPTARG" == "64" ]; then
        ARCH="win64"
      elif [ "$OPTARG" == "32" ]; then
        ARCH="win32"
      else
        log_error "NULL" "Invalid architecture: -$OPTARG. Use 32 or 64."
        confirm_exit 1
      fi
      ;;
    c | b | a)
      BASENAME=$OPTARG

      # ファイル存在チェック
      if [ ! -f "$PROJECT_DIR/$BASENAME.asm" ] || [ ! -f "$PROJECT_DIR/$BASENAME.c" ]; then
          echo "Error: Source files not found."
          log_error $BASENAME "Source files not found."
          confirm_exit 1
      fi

      # 出力ディレクトリの確認と作成
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
          ./nasm/nasm.exe -f win64 $PROJECT_DIR/$BASENAME.asm -o $OBJ_DIR/$BASENAME.obj
          gcc -c -m64 $PROJECT_DIR/$BASENAME.c -o $OBJ_DIR/$BASENAME.o
      else
          # Win32用のコンパイルオプション
          ./nasm/nasm.exe -f win32 $PROJECT_DIR/$BASENAME.asm -o $OBJ_DIR/$BASENAME.obj
          gcc -c -m32 $PROJECT_DIR/$BASENAME.c -o $OBJ_DIR/$BASENAME.o
      fi

      # オブジェクトファイルをリンクして実行ファイルを作成（-c または -b の場合）
      if [ "$opt" == "c" ] || [ "$opt" == "b" ]; then
        gcc $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj -o $EXE_DIR/$BASENAME.exe
        if [ $? -ne 0 ]; then
          log_error $BASENAME " linking $BASENAME" $ARCH $opt
          confirm_exit 1
        fi
      fi

      # -b の場合、中間ファイルを削除
      if [ "$opt" == "b" ]; then
        rm -f $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj
      fi

      log_compile $BASENAME $opt

      confirm_exit 0
      ;;
    r)
      BASENAME=$OPTARG
      rm -f $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj $EXE_DIR/$BASENAME.exe
      ;;
    x)
      BASENAME=$OPTARG
      rm -f $PROJECT_DIR/$BASENAME.asm $PROJECT_DIR/$BASENAME.c $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj $EXE_DIR/$BASENAME.exe
      ;;
    h)
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
