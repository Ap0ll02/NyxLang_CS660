# RISC-V Assembly Output
    .data
.str0:
    .string "Error: Factorial of a negative number doesn't exist.\n"
.str1:
    .string "Factorial of %d = %llu\n"

    .text
    .globl main

factorial:
    li t2, 0
    beq t2, x0, L0
    la t2, .str0
    mv a0, t2
    call printf
    li t2, 0
    mv a0, t2
L0:
L1:
    li t2, 1
    li t3, 1
L2:
    beq t0, x0, L3
    add t1, t3, t0
    add t1, t3, t1
L3:
    mv a0, t2
main:
    li t1, 5
    la t2, .str1
    mv a0, t2
    mv a1, t1
    mv a2, t1
    call factorial
    mv a0, t1
    call printf
    li t1, 0
    mv a0, t1
    # Exit
    li a7, 93
    li a0, 0
    ecall
