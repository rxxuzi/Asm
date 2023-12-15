global _main
extern _printf

section .data
    num1 dd 10               ; 数値1（32ビット整数）
    num2 dd 3                ; 数値2（32ビット整数）
    format db "Result: %d", 0Ah, 0  ; printf用のフォーマット文字列（整数と改行）

section .bss
    result resd 1            ; 結果を格納する変数（32ビット整数）

section .text
_main:
    ; 加算
    mov eax, [num1]          ; EAXレジスタにnum1の値をロード
    add eax, [num2]          ; EAXレジスタにnum2の値を加算
    mov [result], eax        ; 結果をresult変数に保存
    push eax                 ; printfに結果を渡すためにスタックにプッシュ
    push format              ; フォーマット文字列をスタックにプッシュ
    call _printf             ; printfを呼び出して結果を表示
    add esp, 8               ; スタックポインタを調整（引数の分だけ増やす）

    ; 減算
    mov eax, [num1]          ; EAXレジスタにnum1の値をロード
    sub eax, [num2]          ; EAXレジスタからnum2の値を減算
    mov [result], eax        ; 結果をresult変数に保存
    push eax                 ; printfに結果を渡すためにスタックにプッシュ
    push format              ; フォーマット文字列をスタックにプッシュ
    call _printf             ; printfを呼び出して結果を表示
    add esp, 8               ; スタックポインタを調整

    ; 乗算
    mov eax, [num1]          ; EAXレジスタにnum1の値をロード
    imul eax, [num2]         ; EAXレジスタにnum2の値を乗算
    mov [result], eax        ; 結果をresult変数に保存
    push eax                 ; printfに結果を渡すためにスタックにプッシュ
    push format              ; フォーマット文字列をスタックにプッシュ
    call _printf             ; printfを呼び出して結果を表示
    add esp, 8               ; スタックポインタを調整

    ; 除算
    mov eax, [num1]          ; EAXレジスタにnum1の値をロード
    cdq                      ; EDX:EAXに拡張（符号拡張）
    idiv dword [num2]        ; EAXにnum1をnum2で除算した商を格納
    mov [result], eax        ; 結果をresult変数に保存
    push eax                 ; printfに結果を渡すためにスタックにプッシュ
    push format              ; フォーマット文字列をスタックにプッシュ
    call _printf             ; printfを呼び出して結果を表示
    add esp, 8               ; スタックポインタを調整

    ; プログラムの終了
    ret
