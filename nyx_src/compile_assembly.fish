fish clean.fish

zig build run -- src/richie2.c -a

zig cc -target riscv64-linux-musl -static -O0 a.s -o a.out

qemu-riscv64 ./a.out