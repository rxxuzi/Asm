#!/bin/bash

# 引数のチェック
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [base file name]"
    exit 1
fi

BASENAME=$1

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

# オブジェクトファイルをリンクして実行ファイルを作成
gcc $OBJ_DIR/$BASENAME.o $OBJ_DIR/$BASENAME.obj -o $EXE_DIR/$BASENAME.exe
if [ $? -ne 0 ]; then
    echo "$(date) - Error linking $BASENAME" >> $LOG_DIR/error-$DATE.log
    exit 1
fi


