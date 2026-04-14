.text
.globl main

main:
    sub     rsp, 16             # allocate 2 bytes on stack for left_c, right_c

    # Open "input.txt"
    mov     rax, 2
    lea     rdi, [rip + fname]
    mov     rsi, 0
    syscall
    mov     r8, rax             # r8 = fd

    # Get file size
    mov     rax, 8
    mov     rdi, r8
    mov     rsi, 0
    mov     rdx, 2              # SEEK_END
    syscall
    mov     r9, rax             # r9 = size

    # Seek back to start
    mov     rax, 8
    mov     rdi, r8
    mov     rsi, 0
    mov     rdx, 0
    syscall

    mov     r10, 0              # left = 0
    mov     r11, r9
    dec     r11                 # right = size - 1

loop:
    cmp     r10, r11
    jge     yes

    # Read left char into rsp
    mov     rax, 8
    mov     rdi, r8
    mov     rsi, r10
    mov     rdx, 0
    syscall
    mov     rax, 0
    mov     rdi, r8
    mov     rsi, rsp
    mov     rdx, 1
    syscall

    # Read right char into rsp+1
    mov     rax, 8
    mov     rdi, r8
    mov     rsi, r11
    mov     rdx, 0
    syscall
    mov     rax, 0
    mov     rdi, r8
    lea     rsi, [rsp+1]
    mov     rdx, 1
    syscall

    # Compare
    mov     al, [rsp]
    mov     bl, [rsp+1]
    cmp     al, bl
    jne     no

    inc     r10
    dec     r11
    jmp     loop

yes:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rip + yes_str]
    mov     rdx, 4
    syscall
    jmp     exit

no:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rip + no_str]
    mov     rdx, 3
    syscall

exit:
    mov     rax, 60
    xor     rdi, rdi
    syscall

fname:    .asciz "input.txt"
yes_str:  .ascii "Yes\n"
no_str:   .ascii "No\n"