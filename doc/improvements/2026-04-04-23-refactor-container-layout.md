# Loop 23: Refactor RenderContainer.performLayout()

## Problem
`RenderContainer.performLayout()` in `lib/src/widgets/basic/container.dart` is 40 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_layoutChild()` for child layout and container dimension resolution.

## Scope
- `lib/src/widgets/basic/container.dart` — RenderContainer class only
