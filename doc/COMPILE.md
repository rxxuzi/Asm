# COMPILE 

`compile.sh` はアセンブリファイルを簡単にコンパイルし、実行可能ファイルを生成するためのスクリプトです。以下のように使用します：

```bash
./compile.sh [アセンブリファイル名.asm]
```

### オプション

- `-run` : コンパイル後に実行可能ファイルを直接実行します。

```bash
./compile.sh [アセンブリファイル名.asm] -run
```

- `-del` : コンパイル時に生成されたオブジェクトファイル（`.o`ファイル）を削除します。

```bash
./compile.sh [アセンブリファイル名.asm] -del
```