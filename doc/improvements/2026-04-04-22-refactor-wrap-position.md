# Loop 22: Refactor RenderWrap._positionChildren()

## Problem
`RenderWrap._positionChildren()` in `lib/src/widgets/basic/wrap.dart` is 40 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract cross-axis position calculation and child offset computation into helpers.

## Scope
- `lib/src/widgets/basic/wrap.dart` — RenderWrap class only
