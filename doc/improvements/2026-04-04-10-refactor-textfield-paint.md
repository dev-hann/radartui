# Loop 10: Refactor RenderTextField.paint() and _drawBorder()

## Problem
`RenderTextField.paint()` (81 lines) and `_drawBorder()` (55 lines) in `lib/src/widgets/basic/textfield.dart` exceed the 30-line limit from AGENTS.md.

## Plan
1. Break `paint()` into: `_paintBackground()`, `_paintText()`, `_paintCursor()`
2. Break `_drawBorder()` into: `_drawHorizontalEdge()`, `_drawVerticalEdge()`

## Result
_TBD_

## Scope
- `lib/src/widgets/basic/textfield.dart` — RenderTextField class only
