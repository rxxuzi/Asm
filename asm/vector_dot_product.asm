global _vector_dot_product
section .text

_vector_dot_product:
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]  ; ベクトルaのアドレス
    mov ebx, [ebp+12] ; ベクトルbのアドレス

    mov ecx, [eax]    ; a.x
    imul ecx, [ebx]   ; a.x * b.x
    mov edx, ecx      ; 結果をedxに保存

    mov ecx, [eax+4]  ; a.y
    imul ecx, [ebx+4] ; a.y * b.y
    add edx, ecx      ; 加算

    mov ecx, [eax+8]  ; a.z
    imul ecx, [ebx+8] ; a.z * b.z
    add edx, ecx      ; 加算

    mov eax, edx      ; 結果をeaxに設定
    pop ebp
    ret
