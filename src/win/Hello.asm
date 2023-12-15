global _main
extern _GetStdHandle@4, _WriteConsoleA@20, _ExitProcess@4

section .data
    message db 'Hello World !', 0Ah, 0  ; 出力するメッセージと改行、ヌル終端
    msg_len  equ $ - message            ; メッセージの長さ

section .text
_main:
    ; 標準出力ハンドルの取得
    push dword -11         ; STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov ebx, eax           ; 標準出力ハンドルをebxに保存

    ; メッセージの出力
    push dword 0           ; lpNumberOfBytesWritten（出力されたバイト数を受け取る変数のアドレス）
    push dword msg_len     ; nNumberOfBytesToWrite（書き込むバイト数）
    push dword message     ; lpBuffer（書き込むデータのアドレス）
    push dword ebx         ; hConsoleOutput（コンソール出力ハンドル）
    call _WriteConsoleA@20

    ; プログラムの終了
    push dword 0           ; Exit Code
    call _ExitProcess@4
