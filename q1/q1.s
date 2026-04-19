.globl make_node
make_node:
    addi sp, sp, -16
    sd t0, 8(sp)             # save t0
    sd a0, 0(sp)             # save val on stack
    addi a0, zero, 24        # a0 = 24
    call malloc
    ld t1, 0(sp)             # load val
    sw t1, 0(a0)             # store val
    sd zero, 8(a0)           # left = 0
    sd zero, 16(a0)          # right = 0
    ld t0, 8(sp)             # restore t0
    addi sp, sp, 16
    ret


.globl insert
insert:
    # a0 = root
    # a1 = val

    bne a0, zero, check

    addi sp, sp, -16
    sd t0, 8(sp)
    addi a0, a1, 0
    call make_node
    ld t0, 8(sp)
    addi sp, sp, 16
    ret

check:
    lw t2, 0(a0)             # root->val

    beq a1, t2, equal
    blt a1, t2, left

right:
    addi sp, sp, -24
    sd t0, 16(sp)
    sd a0, 8(sp)

    ld a0, 16(a0)            # go right
    call insert

    ld t3, 8(sp)
    sd a0, 16(t3)            # update right
    addi a0, t3, 0

    ld t0, 16(sp)
    addi sp, sp, 24
    ret

left:
    addi sp, sp, -24
    sd t0, 16(sp)
    sd a0, 8(sp)

    ld a0, 8(a0)             # go left
    call insert

    ld t3, 8(sp)
    sd a0, 8(t3)             # update left
    addi a0, t3, 0

    ld t0, 16(sp)
    addi sp, sp, 24
    ret

equal:
    ret


.globl get
get:
    # a0 = root
    # a1 = val

    beq a0, zero, not_found

    lw t2, 0(a0)

    beq a1, t2, found
    blt a1, t2, go_left

go_right:
    addi sp, sp, -16
    sd t0, 8(sp)

    ld a0, 16(a0)
    call get

    ld t0, 8(sp)
    addi sp, sp, 16
    ret

go_left:
    addi sp, sp, -16
    sd t0, 8(sp)

    ld a0, 8(a0)
    call get

    ld t0, 8(sp)
    addi sp, sp, 16
    ret

found:
    ret

not_found:
    addi a0, zero, 0
    ret


.globl getAtMost
getAtMost:
    # a0 = val
    # a1 = root

    addi t2, zero, -1         # t2 = -1

loop:
    beq a1, zero, end

    lw t3, 0(a1)

    ble t3, a0, new_ans

    ld a1, 8(a1)              # go left
    beq zero, zero, loop

new_ans:
    addi t2, t3, 0
    ld a1, 16(a1)             # go right
    beq zero, zero, loop

end:
    addi a0, t2, 0
    ret
