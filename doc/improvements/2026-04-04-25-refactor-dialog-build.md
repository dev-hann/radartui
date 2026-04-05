# Loop 25: Refactor Dialog.build()

## Problem
`Dialog.build()` in `lib/src/widgets/basic/dialog.dart` is 37 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_buildActionRow()` for action button layout construction.

## Scope
- `lib/src/widgets/basic/dialog.dart` — Dialog class only
