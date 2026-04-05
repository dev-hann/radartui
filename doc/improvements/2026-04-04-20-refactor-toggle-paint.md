# Loop 20: Refactor RenderToggle.paint()

## Problem
`RenderToggle.paint()` in `lib/src/widgets/basic/toggle.dart` is 47 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_paintBackground()`, `_paintBorder()`, `_paintIndicator()`, `_paintLabel()` helpers from paint().

## Scope
- `lib/src/widgets/basic/toggle.dart` — RenderToggle class only
