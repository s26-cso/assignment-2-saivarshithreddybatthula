.section .data
filename: .string "input.txt"     # file
yes: .string "Yes\n"              # yes
no: .string "No\n"                # no
.section .text
.global main
.extern open
.extern read
.extern lseek
.extern close
.extern printf
main:
addi sp, sp, -48                  # sp = sp - 48
sd x1, 40(sp)                     # save x1
sd x20, 32(sp)                    # save x20
sd x21, 24(sp)                    # save x21
# open file
la x10, filename                  # x10 = filename
addi x11, x0, 0                   # x11 = O_RDONLY
call open                         # open
addi x20, x10, 0                  # x20 = fd
# get size
addi x10, x20, 0                  # x10 = fd
addi x11, x0, 0                   # x11 = offset 0
addi x12, x0, 2                   # x12 = SEEK_END
call lseek                        # lseek to end
addi x21, x10, 0                  # x21 = size
addi x6, x21, -1                  # x6 = right = size-1
# check newline at end
addi x10, x20, 0                  # x10 = fd
addi x11, x6, 0                   # x11 = offset
addi x12, x0, 0                   # x12 = SEEK_SET
call lseek                        # seek to last char
addi x10, x20, 0                  # x10 = fd
addi x11, sp, 0                   # x11 = buffer
addi x12, x0, 1                   # x12 = 1
call read                         # read 1 byte
lbu x9, 0(sp)                     # x9 = last char
addi x28, x0, 10                  # x28 = '\n'
bne x9, x28, set_right            # if not newline skip
addi x6, x6, -1                   # right--
set_right:
addi x5, x0, 0                    # x5 = left = 0
loop:
bge x5, x6, is_pal                # if left >= right done
# read left char
addi x10, x20, 0                  # x10 = fd
addi x11, x5, 0                   # x11 = left offset
addi x12, x0, 0                   # x12 = SEEK_SET
call lseek                        # seek to left
addi x10, x20, 0                  # x10 = fd
addi x11, sp, 0                   # x11 = buffer
addi x12, x0, 1                   # x12 = 1
call read                         # read left char
lbu x7, 0(sp)                     # x7 = left char
# read right char
addi x10, x20, 0                  # x10 = fd
addi x11, x6, 0                   # x11 = right offset
addi x12, x0, 0                   # x12 = SEEK_SET
call lseek                        # seek to right
addi x10, x20, 0                  # x10 = fd
addi x11, sp, 0                   # x11 = buffer
addi x12, x0, 1                   # x12 = 1
call read                         # read right char
lbu x8, 0(sp)                     # x8 = right char
bne x7, x8, not_pal               # if not equal not palindrome
addi x5, x5, 1                    # left++
addi x6, x6, -1                   # right--
beq x0, x0, loop                  # goto loop
is_pal:
la x10, yes                       # x10 = yes
call printf                       # print yes
beq x0, x0, done                  # goto done
not_pal:
la x10, no                        # x10 = no
call printf                       # print no
done:
addi x10, x20, 0                  # x10 = fd
call close                        # close file
ld x21, 24(sp)                    # load x21
ld x20, 32(sp)                    # load x20
ld x1, 40(sp)                     # load x1
addi sp, sp, 48                   # sp = sp + 48
ret                               # return
