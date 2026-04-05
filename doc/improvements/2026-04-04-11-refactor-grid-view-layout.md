# Loop 11: Refactor RenderGridView.performLayout()

## Problem
`RenderGridView.performLayout()` in `lib/src/widgets/basic/grid_view.dart` (lines 184-232) is 49 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract helper methods:
1. `_computeGridDimensions()` — calculate column count and child sizes
2. `_positionChildren()` — set offsets for each child in grid

## Scope
- `lib/src/widgets/basic/grid_view.dart` — RenderGridView class only
