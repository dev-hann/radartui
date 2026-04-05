# Loop 8: Refactor RenderContainer.paint()

## Problem
`RenderContainer.paint()` in `lib/src/widgets/basic/container.dart` (lines 129-251) is 122 lines with nesting depth 4. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract helper methods:

1. `_paintBackground()` — fill background color
2. `_paintBorder()` — orchestrate all 4 border edges
3. `_paintHorizontalBorder()` — draw top or bottom border edge (parameterized)
4. `_paintVerticalBorder()` — draw left or right border edge (parameterized)

Result: `paint()` reduced to ~15 lines orchestrating the helpers.

## Result
- `paint()`: 122 lines → ~20 lines
- 4 helper methods, each ≤ 30 lines
- dart analyze: 0 issues, dart test: 1077/1077

## Scope
- `lib/src/widgets/basic/container.dart` — RenderContainer class only
