global _push
section .text

_push:
    ; 引数をレジスタにロード
    mov eax, [esp + 4] ; array のアドレス
    mov ecx, [esp + 8] ; size

    xor edx, edx ; インデックスを 0 に初期化

.loop:
    ; インデックスの値を2倍して配列の指定されたインデックスに格納
    mov ebx, edx
    shl ebx, 1 ; ebx = edx * 2
    mov [eax + edx * 4], ebx

    inc edx ; インデックスをインクリメント

    ; インデックスが size に達するまでループ
    dec ecx
    jnz .loop

    ret

