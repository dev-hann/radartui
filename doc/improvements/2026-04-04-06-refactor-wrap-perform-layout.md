# Refactor RenderWrap.performLayout() (211 lines, depth 7 → helpers under 30 lines)

## Problem
`RenderWrap.performLayout()` in `lib/src/widgets/basic/wrap.dart` is 211 lines (7x the 30-line limit) with nesting depth 7. It also contains a duplicated child-positioning block (~25 lines copied verbatim in two code paths).

## Improvement
Extract helper methods:
- `_layoutChildrenIntoRuns()` - iterate children, build runs list
- `_computeRunExtents()` - compute main/cross extents per run
- `_computeOverallDimensions()` - total size calculation
- `_mainAxisOffsetForAlignment()` - per-alignment switch
- `_positionChildInRun()` - shared positioning logic (eliminates duplication)
- `_positionAllChildren()` - orchestrate positioning

## Impact
- `lib/src/widgets/basic/wrap.dart` (primary)
- 211 lines → ~30 line `performLayout()` + 6 helpers each under 30 lines
- Nesting depth 7 → max 3
- ~25 lines of duplicated code eliminated
