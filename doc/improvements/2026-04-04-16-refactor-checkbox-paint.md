# Loop 16: Refactor RenderCheckbox.paint()

## Problem
`RenderCheckbox.paint()` in `lib/src/widgets/basic/checkbox.dart` is 42 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_paintBackground()`, `_paintBorder()`, `_paintIndicator()` following the same pattern as RenderRadio.

## Scope
- `lib/src/widgets/basic/checkbox.dart` — RenderCheckbox class only
