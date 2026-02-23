---
title: Three Address Code (3AC)
---

NyxLang lowers AST into an intermediate representation defined in `3ac.zig`.

## Why 3AC?

3AC makes complex AST expressions explicit and linear:
- temporaries store intermediate values
- control flow is explicit via labels/branches
- easier backend lowering than a tree AST

## Typical instruction shapes

Even if the exact representation differs, most 3AC IRs include:

- `t = op a b`  (binary)
- `t = op a`    (unary)
- `t = load addr`
- `store value -> addr`
- `goto L`
- `if cond goto L`
- `L:` labels
- `call f(args...)`
- `return value`

## Control flow lowering

- `if/else` becomes conditional branches + join label
- loops become header/body/exit labels with back-edges

## Conventions

Document the conventions your backend expects, e.g.:
- is `x = y` a move?
- are booleans 0/1?
- how are comparisons represented?
