global _sum
section .text

_sum:
    ; 関数の引数 (n) を eax レジスタに格納
    mov eax, [esp + 4]
    ; 合計を格納するための変数を 0 に初期化
    xor edx, edx

    ; n が 0 以下の場合は、結果は 0
    test eax, eax
    jle .done

.loop:
    ; edx (合計) に eax (現在の数) を加算
    add edx, eax
    ; eax (現在の数) を 1 減算
    dec eax
    ; eax が 0 になるまでループ
    jnz .loop

.done:
    ; 最終的な合計を eax に格納して返す
    mov eax, edx
    ret
