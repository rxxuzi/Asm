global _main
extern _printf

section .data
    num1 dd 15                   ; 数値1（32ビット整数）
    num2 dd 20                   ; 数値2（32ビット整数）
    format db "Max: %d", 0Ah, 0  ; printf用のフォーマット文字列（整数と改行）

section .bss
    max_value resd 1             ; 最大値を格納する変数（32ビット整数）

section .text
_main:
    ; num1とnum2を比較して、大きい方をmax_valueに保存
    mov eax, [num1]              ; EAXレジスタにnum1の値をロード
    mov ebx, [num2]              ; EBXレジスタにnum2の値をロード
    cmp eax, ebx                 ; EAXとEBXを比較
    jg .num1_is_greater          ; num1が大きい場合、.num1_is_greaterにジャンプ
    mov [max_value], ebx         ; そうでなければ、num2（EBX）をmax_valueに保存
    jmp .done                    ; 処理の終了へジャンプ

.num1_is_greater:
    mov [max_value], eax         ; num1（EAX）をmax_valueに保存

.done:
    ; 結果の表示
    push dword [max_value]       ; printfに結果を渡すためにスタックにプッシュ
    push format                  ; フォーマット文字列をスタックにプッシュ
    call _printf                 ; printfを呼び出して結果を表示
    add esp, 8                   ; スタックポインタを調整

    ; プログラムの終了
    ret
