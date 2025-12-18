# RISC-V Assembly Output
    .data
.str0:
    .string "X: %d\n"

    .text
    .globl main

main:
    li t1, 100
    la t2, .str0
    mv a0, t2
    mv a1, t1
    call printf
    li t1, 0
    mv a0, t1
    # Exit
    li a7, 93
    li a0, 0
    ecall
