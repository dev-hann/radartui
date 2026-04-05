# Loop 9: Refactor RenderStack.performLayout()

## Problem
`RenderStack.performLayout()` in `lib/src/widgets/basic/stack.dart` (lines 33-137) is 104 lines with nesting depth 5. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract helper methods:

1. `_layoutChildWithConstraints()` — pick correct constraints for a child based on StackParentData width/height (lines 40-71)
2. `_computeStackDimensions()` — calculate overall stack width/height from children (lines 73-85)
3. `_positionChildren()` — second pass to set offsets (lines 87-136)
4. `_computeHorizontalPosition()` — compute left value for one child
5. `_computeVerticalPosition()` — compute top value for one child

Result: `performLayout()` reduced to ~20 lines.

## Scope
- `lib/src/widgets/basic/stack.dart` — RenderStack class only
