---
title: Semantic Analysis
---

Semantic analysis primarily lives in:
- `semanticAnalyzer.zig`
- `scope.zig`
- `variables.zig`
- `builtin.zig`

## Responsibilities

- Ensure all identifiers resolve
- Ensure types are valid and compatible
- Validate function calls (arity, parameter types)
- Validate control-flow usage (return type matches function, etc.)
- Assign storage information needed by lowering (locals, params, globals)

## Suggested outputs from semantic analysis

Even if your implementation differs, it helps to think of semantic analysis as producing:

- a symbol table mapping identifiers → symbols
- a type table mapping expressions → types
- per-function metadata (locals, stack frame size, parameter layout)

## Typical semantic error cases

- use of undeclared identifier
- invalid lvalue (assigning to rvalue)
- incompatible binary operation types
- calling a non-function
- returning wrong type
