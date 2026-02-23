---
title: AST
---

The AST is defined in `ast.zig` and represents the parsed structure of a translation unit.

## What belongs in the AST

- Expression structure (binary ops, unary ops, calls, literals, identifiers)
- Statement structure (if/while/for/return/block)
- Declarations (vars, funcs, types)
- Type syntax (pointers/arrays/functions/etc.)

## What should NOT belong in the AST

- target-specific details (RV32 registers, stack layout)
- fully-lowered control flow (that’s IR’s job)
- ad-hoc semantic flags if they can live in a separate analysis table

## Recommended invariants

Document invariants here as you discover them. Examples:
- “Every `break`/`continue` must appear inside a loop”
- “Every identifier node must resolve to exactly one symbol post-sema”
- “Every function body ends with an explicit return in IR”
