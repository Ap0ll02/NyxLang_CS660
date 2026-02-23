---
title: RISC-V RV32 Backend
---

NyxLang targets **RISC-V 32-bit** (RV32), emitting assembly through `assembler.zig`.

## Backend responsibilities

- Emit function prologues/epilogues
- Implement calling convention and stack frames
- Lower 3AC instructions to RV32 sequences
- Place globals in appropriate sections (if supported)

## Calling convention

Document what you implement (even if simplified). Example checklist:
- how arguments are passed
- where return values go
- which registers are caller/callee-saved
- stack alignment rules you enforce

## Stack frames

Typical frame tasks:
- reserve space for locals/spills
- store return address/frame pointer (if used)
- address locals via `sp` or `fp`

## Debugging tips

- Start with tiny programs and compare assembly to expected behavior
- Add a mode to print IR before codegen
- Add a mode to print emitted instructions with comments mapping to IR
