# Loop 12: Refactor MultiChildRenderObjectElement.update()

## Problem
`MultiChildRenderObjectElement.update()` in `lib/src/widgets/framework.dart` (lines 474-520) is 47 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract helper methods:
1. `_findAndUpdateOldChild()` — find matching old child or return null
2. `_unmountOldChildren()` — unmount remaining old children

## Scope
- `lib/src/widgets/framework.dart` — MultiChildRenderObjectElement class only
