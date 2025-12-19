# RISC-V Assembly Output
    .data
.str0:
    .string "%d\n"

    .text
    .globl simple_test
    .globl main

simple_test:
    addi t1, sp, 0
    li t2, 5
    sw t2, 0(t1)
    lw t1, 0(t1)
    mv t0, t1
    ret
main:
    la t1, .str0
    mv a0, t1
    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    call simple_test
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    addi sp, sp, 28
    mv t1, t0
    mv a0, t1
    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    call printf
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    addi sp, sp, 28
    # flush stdout
    li a0, 0
    call fflush
    # Exit
    li a7, 93
    li a0, 0
    ecall
