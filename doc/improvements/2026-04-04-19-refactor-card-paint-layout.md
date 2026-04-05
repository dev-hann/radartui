# Loop 19: Refactor RenderCard paint() and performLayout()

## Problem
`RenderCard.paint()` in `lib/src/widgets/basic/card.dart` is 68 lines and `RenderCard.performLayout()` is 56 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
- Extract `paint()` into helpers: `_paintBorder()`, `_paintTitleBar()`, `_paintContent()`
- Extract `performLayout()` into helpers: `_layoutWithoutTitle()`, `_layoutWithTitle()`

## Scope
- `lib/src/widgets/basic/card.dart` — RenderCard class only
