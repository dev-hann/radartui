# Loop 7: Refactor RenderFlex.performLayout()

## Problem
`RenderFlex.performLayout()` in `lib/src/widgets/basic/flex.dart` (lines 56-219) is 163 lines with nesting depth 5. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract helper methods following the pattern used in Loop 6 (RenderWrap):

1. `_computeTotalFlex()` — sum flex values
2. `_measureNonFlexChildren()` — layout non-flex children, return measurement
3. `_measureFlexChildren()` — layout flex children, allocate space
4. `_computeSize()` — determine overall size with MainAxisSize
5. `_computeMainAxisAlignment()` — calculate leading/between space (returns record)
6. `_positionChildren()` — set offsets for each child
7. `_crossAxisPosition()` — compute single child's cross-axis position

Added `_FlexMeasurement` helper class to carry mainExtent + crossExtent between methods.

## Result
- `performLayout()`: 163 lines → ~30 lines
- 7 helper methods, each ≤ 30 lines
- dart analyze: 0 issues, dart test: 1077/1077

## Scope
- `lib/src/widgets/basic/flex.dart` — RenderFlex class + _FlexMeasurement
