# Loop 21: Refactor RenderText._wrapText()

## Problem
`RenderText._wrapText()` in `lib/src/widgets/basic/text.dart` is 44 lines with nesting depth 7. AGENTS.md coding standards require functions ≤ 30 lines and nesting ≤ 3 levels.

## Plan
Extract `_wrapParagraph()` for soft-wrap logic of a single paragraph.

## Scope
- `lib/src/widgets/basic/text.dart` — RenderText class only
