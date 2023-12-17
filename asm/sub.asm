global _sub_numbers ; グローバルシンボルとして関数を公開
section .text

_sub_numbers:
    mov eax, [esp + 4] ; 第一引数をeaxにロード
    sub eax, [esp + 8] ; 第二引数を減算
    ret ; 結果を返す