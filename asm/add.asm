global _add_numbers ; グローバルシンボルとして関数を公開
section .text

_add_numbers:
    mov eax, [esp + 4] ; 第一引数をeaxにロード
    add eax, [esp + 8] ; 第二引数を加算
    ret ; 結果を返す
