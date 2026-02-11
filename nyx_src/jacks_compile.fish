#!/usr/bin/fish

set filename $argv[1]

zig build run -- $filename -a

riscv32-unknown-elf-gcc a.s

qemu-riscv32 a.out
