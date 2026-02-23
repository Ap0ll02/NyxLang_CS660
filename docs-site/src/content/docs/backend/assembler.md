---
title: Assembler / Code Emission
---

`assembler.zig` is responsible for turning lowered instructions into textual assembly output.

## Responsibilities

- Format instructions correctly
- Manage labels and symbol names
- Emit directives (`.text`, `.data`, `.globl`, etc.) if needed
- Output in a form your toolchain/runner accepts

## Recommended developer features

- `--emit-ir` to print 3AC
- `--emit-asm` to print assembly
- comments in emitted asm showing originating IR instruction
