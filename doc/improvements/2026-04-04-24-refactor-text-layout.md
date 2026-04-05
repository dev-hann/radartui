# Loop 24: Refactor RenderText.performLayout()

## Problem
`RenderText.performLayout()` in `lib/src/widgets/basic/text.dart` is 36 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_applyOverflow()` for maxLines/ellipsis logic and `_maxLineWidth()` for width calculation.

## Scope
- `lib/src/widgets/basic/text.dart` — RenderText class only
