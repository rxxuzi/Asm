#!/bin/bash

# コマンドラインオプションの解析
while getopts ":c:r:b:a:" opt; do
  case $opt in
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

      # アセンブリファイルをコンパイル
      ./nasm/nasm.exe -f win32 asm/$BASENAME.asm -o $OBJ_DIR/$BASENAME.obj
      if [ $? -ne 0 ]; then
          echo "$(date) - Error compiling $BASENAME.asm" >> $LOG_DIR/error-$DATE.log
          exit 1
      fi

      # Cファイルをコンパイル（ただしリンクはしない）
      gcc -c asm/$BASENAME.c -o $OBJ_DIR/$BASENAME.o
      if [ $? -ne 0 ]; then
          echo "$(date) - Error compiling $BASENAME.c" >> $LOG_DIR/error-$DATE.log
          exit 1
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
      rm -f asm/$BASENAME.asm asm/$BASENAME.c asm-out/$BASENAME.o asm-out/$BASENAME.obj run/$BASENAME.exe
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 -c [project name] to compile or $0 -r [project name] to remove or $0 -b [project name] to build or $0 -a [project name] to assemble"
    exit 1
fi



