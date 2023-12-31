# Asm 

このリポジトリは、Windowsで動作するアセンブリ言語のプロジェクトです。
MinGWとNASMを使用して、アセンブリ言語のコードをコンパイルし、リンクして実行可能ファイルを生成します。

このプロジェクトは、アセンブリ言語の基礎から応用までの様々なサンプルコードを含んでいます。

## 前提条件

このプロジェクトを使用するには、以下のソフトウェアがインストールされている必要があります：

- [MinGW](http://www.mingw.org) - Minimalist GNU for Windows、GCCコンパイラを含むWindows用の開発ツール

## スクリプトについて

+ `asm.sh`については[ASM.sh](doc/ASM.md) を参照してください
+ `compile.sh`については[compile.sh](doc/COMPILE.md) を参照してください

## プロジェクトの構造

- `asm` : アセンブリ言語とC言語のソースファイルが含まれています
- `run` : asmでコンパイルされた実行可能ファイルが格納されています。
- `src` : アセンブリ言語のソースファイルが含まれます。
- `out` : コンパイル後の実行可能ファイルが格納されます。
- `log` : スクリプトの実行ログが格納されます。

## ライセンス

このプロジェクトは [MITライセンス](LICENSE) の下で公開されています。プロジェクト内でのコード、ドキュメント、その他の資材は、特に記載がない限り、このライセンスの下で自由に使用、変更、配布することができます。

### NASMの配布について

このプロジェクトには、[Netwide Assembler (NASM)](https://www.nasm.us) が含まれています。NASMは独自の [BSDライセンス](nasm/LICENSE) の下で配布されており、このライセンスに従い、NASMをプロジェクト内で使用しています。NASMに関する著作権およびライセンスの詳細は、その公式ウェブサイトおよび配布資料を参照してください。
