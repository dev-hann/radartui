# Loop 14: Refactor RenderButton._drawBorder()

## Problem
`RenderButton._drawBorder()` in `lib/src/widgets/basic/button.dart` is 46 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_drawHorizontalEdge()` and `_drawVerticalEdges()` helpers from the border drawing logic.

## Scope
- `lib/src/widgets/basic/button.dart` — RenderButton class only
