---
title: Scope and Name Resolution
---

Scopes are implemented in `scope.zig` and are used during semantic analysis.

## Scope model

NyxLang uses lexical scoping:
- A scope has a parent (except global scope)
- Declarations bind names in the current scope
- Resolution walks upward until found

Scopes are commonly pushed at:
- function entry
- compound statements / blocks
- control-flow statements that introduce a block

## Symbol resolution rules (C-ish)

Typical C11 rules you may implement:
- variables/functions in the same scope cannot be redefined
- inner scopes can shadow outer declarations
- function prototypes and definitions must agree

## How to debug scope issues

- Print scope stack when entering/leaving blocks
- Print symbol insertions and lookups
- Build a small repro with nested blocks and shadowing

## Related modules

- `variables.zig` often holds symbol metadata needed for later phases
- `builtin.zig` may populate global scope with known declarations
