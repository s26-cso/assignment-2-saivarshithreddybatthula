.text

.globl make_node
make_node:
    push    rbx
    mov     ebx, edi        # save val

    mov     edi, 24         # malloc(24)
    call    malloc

    mov     [rax], ebx      # node->val = val
    mov     qword [rax+8],  0   # node->left = NULL
    mov     qword [rax+16], 0   # node->right = NULL

    pop     rbx
    ret


.globl insert
insert:
    push    rbx
    push    r12
    push    r13

    mov     rbx, rdi        # rbx = root
    mov     r12d, esi       # r12d = val

    test    rbx, rbx
    jnz     not_null

    mov     edi, r12d
    call    make_node
    jmp     insert_done

not_null:
    cmp     r12d, [rbx]     # compare val with root->val
    je      insert_done_root
    jl      go_left

    mov     rdi, [rbx+16]   # right child
    mov     esi, r12d
    call    insert
    mov     [rbx+16], rax
    mov     rax, rbx
    jmp     insert_done

go_left:
    mov     rdi, [rbx+8]    # left child
    mov     esi, r12d
    call    insert
    mov     [rbx+8], rax
    mov     rax, rbx
    jmp     insert_done

insert_done_root:
    mov     rax, rbx

insert_done:
    pop     r13
    pop     r12
    pop     rbx
    ret


.globl get
get:
    test    rdi, rdi
    jz      get_ret         # NULL => return NULL

    cmp     esi, [rdi]      # compare val with node->val
    je      get_ret         # found

    jl      get_left

    mov     rdi, [rdi+16]   # go right
    jmp     get

get_left:
    mov     rdi, [rdi+8]    # go left
    jmp     get

get_ret:
    mov     rax, rdi
    ret


.globl getAtMost
getAtMost:
    push    rbx
    push    r12
    push    r13

    mov     r12d, edi       # r12d = val
    mov     rbx, rsi        # rbx  = root
    mov     r13d, -1        # best = -1

loop:
    test    rbx, rbx
    jz      done

    cmp     [rbx], r12d     # node->val vs val
    jg      go_left2        # node->val > val => go left

    mov     r13d, [rbx]     # best = node->val
    mov     rbx, [rbx+16]   # go right
    jmp     loop

go_left2:
    mov     rbx, [rbx+8]    # go left
    jmp     loop

done:
    mov     eax, r13d
    pop     r13
    pop     r12
    pop     rbx
    ret