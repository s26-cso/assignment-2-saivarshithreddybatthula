

global main
extern printf, atoi

section .data
    fmt db "%d ", 0
    nl db 10, 0

section .bss
    arr resq 100        ; input array
    res resq 100        ; result array
    stk resq 100        ; stack (stores indices)

section .text

main:
    push rbp
    mov rbp, rsp

    mov rbx, rdi        ; argc
    mov r12, rsi        ; argv

    dec rbx             ; n = argc - 1
    cmp rbx, 0
    jle end

; convert input strings to integers → arr[]
    xor rcx, rcx
read:
    cmp rcx, rbx
    jge solve

    mov rdi, [r12 + rcx*8 + 8]
    call atoi
    mov [arr + rcx*8], rax

    inc rcx
    jmp read

; compute next greater element indices using stack
solve:
    mov r13, -1         ; stack top = -1
    mov rcx, rbx
    dec rcx             ; i = n-1

outer:
    cmp rcx, -1
    jl print

inner:
    cmp r13, -1
    je no_greater

    mov rax, [stk + r13*8]     ; top index
    mov rdx, [arr + rax*8]     ; arr[top]
    mov r8,  [arr + rcx*8]     ; arr[i]

    cmp rdx, r8
    jg found

    dec r13                    ; pop
    jmp inner

no_greater:
    mov qword [res + rcx*8], -1
    jmp push

found:
    mov [res + rcx*8], rax

push:
    inc r13
    mov [stk + r13*8], rcx     ; push current index

    dec rcx
    jmp outer

; print result array
print:
    xor rcx, rcx

loop_print:
    cmp rcx, rbx
    jge end

    mov rsi, [res + rcx*8]
    lea rdi, [rel fmt]
    xor rax, rax
    call printf

    inc rcx
    jmp loop_print

end:
    lea rdi, [rel nl]
    xor rax, rax
    call printf

    mov rsp, rbp
    pop rbp
    ret