---
title: Parser
---

The C11 parser is defined in `c11.y` (Bison-style).

## Responsibilities

- Enforce C grammar rules (or your supported subset)
- Construct AST nodes as reductions happen
- Encode precedence/associativity to reduce ambiguity
- Provide readable syntax errors

## Extending the grammar

When you add a new syntax feature:
1. Extend grammar rules in `c11.y`
2. Construct a corresponding AST node (in `ast.zig`)
3. Ensure semantic analysis validates it
4. Add IR lowering rules in `3ac.zig`
5. Add RV32 lowering or emission in `assembler.zig`

## Error handling strategy

Prefer emitting:
- a short message
- the location
- what was expected / what was seen
