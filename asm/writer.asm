section .data
    writeError db "ファイル書き込みエラー", 0

section .bss
    fileHandle resb 4
    writtenBytes resb 4

section .text
extern _CreateFileA, _WriteFile, _CloseHandle, _ExitProcess, _GetStdHandle, _WriteConsoleA

global _write

_write:
    ; 引数をスタックから取得
    pop ebx             ; return address
    pop ecx             ; 第一引数（ファイル名）
    pop edx             ; 第二引数（文字列）

    ; ファイルをオープン（作成）
    push 0              ; lpSecurityAttributes
    push 2              ; dwCreationDisposition (CREATE_ALWAYS)
    push 0              ; dwShareMode (0 = exclusive access)
    push 0              ; lpFlagsAndAttributes
    push 2              ; dwAccess (GENERIC_WRITE)
    push ecx            ; lpFileName
    call _CreateFileA
    mov [fileHandle], eax
    cmp eax, -1
    je .error           ; ファイルオープンに失敗した場合、エラー処理へ

    ; ファイルに書き込み
    push 0                  ; lpOverlapped
    push writtenBytes       ; lpNumberOfBytesWritten
    push edx                ; lpBuffer
;    mov eax, [edx-4]        ; Load the length into eax
    mov eax, dword [edx-4]  ; Load the dword value into eax
    push eax                ; dwNumberOfBytesToWrite
    push [fileHandle]       ; hFile
    call _WriteFile
    cmp eax, 0
    je .error               ; 書き込みに失敗した場合、エラー処理へ

    ; ファイルを閉じる
    push [fileHandle]
    call _CloseHandle

    jmp .end

.error:
    ; エラーメッセージを出力
    push 0                  ; lpReserved
    push writeError         ; lpBuffer
    mov eax, [writeError+4] ; Load the length into eax
    push eax                ; nNumberOfBytesToWrite
    push dword -11          ; nStdHandle (STD_ERROR_HANDLE)
    call _GetStdHandle
    push eax                ; hConsoleOutput
    call _WriteConsoleA

    push 1              ; 終了コード
    call _ExitProcess

.end:
    push ebx            ; return addressをスタックに戻す
    ret
