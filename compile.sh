#!/bin/bash

# 引数から.asmファイル名を取得
asm_file=$1

# 第二引数を取得（オプション）
option=$2

# ファイル名から拡張子を除去してベース名を取得
base_name=$(basename $asm_file .asm)

# 出力ディレクトリを設定
output_dir="./out"

# ログディレクトリを設定
log_dir="./log"

# オブジェクトディレクトリ
obj_dir="$output_dir/obj"

if [ ! -d $obj_dir ]; then
    mkdir $obj_dir
    echo "Created object directory: $obj_dir" >> "script.log"
fi

if [ ! -d $log_dir ]; then
    mkdir $log_dir
    echo "Created log directory: $log_dir" >> "script.log"
fi

# 出力ディレクトリが存在しない場合は作成
if [ ! -d $output_dir ]; then
    mkdir $output_dir
fi

echo "Compiling $asm_file"

# NASMでアセンブリファイルをコンパイルし、出力ディレクトリに配置
./nasm/nasm.exe -f win32 $asm_file -o $obj_dir/$base_name.o

if [ $? -ne 0 ]; then
    echo "Error during compilation" >> "$log_dir/error.log"
    exit 1
fi

echo "Linking $base_name.o"

# MinGW ldでリンクし、出力ディレクトリに配置
gcc -o $output_dir/$base_name.exe $obj_dir/$base_name.o -lkernel32

if [ $? -ne 0 ]; then
    echo "Error during linking" >> "$log_dir/error.log"
    exit 1
fi

echo "Compilation and linking completed: $output_dir/$base_name.exe"

# -runオプションが指定された場合、生成された実行可能ファイルを実行
if [ "$option" = "-run" ]; then
    echo "Running $output_dir/$base_name.exe"
    $output_dir/$base_name.exe
fi

# -delオプションが指定された場合、オブジェクトファイルを削除
if [ "$option" = "-del" ]; then
    echo "Deleting object file: $obj_dir/$base_name.o"
    rm $obj_dir/$base_name.o
fi
