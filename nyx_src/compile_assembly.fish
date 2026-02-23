#!/usr/bin/fish
fish clean.fish
set filename $argv[1]

zig build run -- $filename -a

zig cc -target riscv32-linux-musl -static -O0 a.s -o a.out

qemu-riscv32 ./a.out
