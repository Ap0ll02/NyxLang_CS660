#!/usr/bin/env fish
flex src/lexer.l
bison -d src/parser.y
zig build run

