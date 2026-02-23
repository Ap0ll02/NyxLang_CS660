---
title: Lexer
---

NyxLang uses a Flex-style lexer (`c11.l`) to tokenize C11 input.

## Responsibilities

- Convert source text into token kinds expected by `c11.y`
- Disambiguate keywords vs identifiers
- Parse integer/float literals (as needed by your supported subset)
- Track location info (line/column) if your grammar uses it

## Tips for contributors

When adding a new token:
1. Add the token definition in `c11.y` (Bison token list)
2. Ensure the lexer returns the correct token kind from `c11.l`
3. Add tests / sample programs exercising the token
4. Ensure the AST node that consumes it exists (or is added)

## Common pitfalls

- Keyword/identifier conflicts
- Preprocessor behavior: if not implemented, clarify what subset is assumed
- Integer literal suffixes in C11 (u, l, ll, etc.) — decide what’s supported
