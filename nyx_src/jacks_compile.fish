#!/usr/bin/fish

set filename $argv[1]

zig build run -- $filename -a

riscv64-linux-gnu-gcc -march=rv32g a.s -o a.out
qemu-riscv32 a.out
