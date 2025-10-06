#!/usr/bin/env fish
cd src
flex lexer.l
bison -d parser.y
cd ..
zig build run

