section .text
global _fibonacci

_fibonacci:
    push ebp
    mov ebp, esp
    mov ecx, [ebp + 8]  ; 引数nを取得

    cmp ecx, 1
    jle .init_condition  ; n <= 1 の場合、初期条件を処理

    mov eax, 0  ; fib(n-2)
    mov ebx, 1  ; fib(n-1)
    mov edx, 1  ; fib(n)の初期値

.loop:
    mov eax, ebx  ; 前のfib(n-1)をfib(n-2)に更新
    mov ebx, edx  ; 新しいfib(n)をfib(n-1)に更新
    add edx, eax  ; fib(n) = fib(n-1) + fib(n-2)

    dec ecx
    cmp ecx, 1
    jne .loop  ; n > 1 の間、ループを継続

    jmp .done

.init_condition:
    mov eax, ecx  ; 初期条件 (n = 0 または n = 1) の場合、nをそのまま返す

.done:
    pop ebp
    ret

