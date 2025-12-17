int main() {
    int x = 5;
    return x;
}

// main:
//     addi sp, sp, -16
//     sw   s1, 12(sp)      # save callee-saved if you use it
//     addi s1, sp, 0

//     li   t1, 5
//     sw   t1, 0(s1)
//     lw   a0, 0(s1)       # return value in a0

//     lw   s1, 12(sp)      # restore
//     addi sp, sp, 16
//     ret

// or even better:

// main:
//     li a0, 5
//     ret