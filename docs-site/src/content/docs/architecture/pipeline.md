---
title: Compilation Pipeline
---

This page tracks how a translation unit moves through NyxLang.

## 1) Lexing (Flex) — `c11.l`
Input: source text  
Output: stream of tokens used by the parser.

Lexer responsibilities typically include:
- identifiers/keywords
- numeric literals
- operators/punctuators
- comments/whitespace handling

## 2) Parsing (Bison) — `c11.y`
Input: token stream  
Output: AST.

Parser responsibilities:
- enforce grammar
- precedence/associativity
- build correct AST node kinds

## 3) AST — `ast.zig`
Input: parse result  
Output: in-memory structured program representation.

AST responsibilities:
- represent syntax (expressions, statements, decls, types)
- preserve source positions if supported
- avoid semantic assumptions

## 4) Semantic Analysis — `semanticAnalyzer.zig`
Input: AST  
Output: validated program + metadata (resolved symbols, types), or errors.

Common checks:
- "identifier not declared"
- redefinition in same scope
- type compatibility (assignments, calls, returns)
- correct usage of lvalues/rvalues
- function declarations/definitions consistency

## 5) IR generation (3AC) — `3ac.zig`
Input: semantically valid AST  
Output: linear IR (three-address instructions + labels).

IR goals:
- make control-flow explicit
- make temporaries explicit
- preserve enough information for efficient RV32 lowering

## 6) Backend — RV32 — `assembler.zig`
Input: 3AC  
Output: RISC-V RV32 assembly.

Backend responsibilities:
- calling convention + stack frames
- register allocation strategy (even if simple)
- instruction selection + lowering
- prologue/epilogue emission
