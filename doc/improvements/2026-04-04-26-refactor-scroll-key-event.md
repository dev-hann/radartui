# Loop 26: Refactor _ScrollViewState.onKeyEvent()

## Problem
`_ScrollViewState.onKeyEvent()` in `lib/src/widgets/basic/single_child_scroll_view.dart` is 36 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_computeScrollDelta()` for key-to-delta mapping.

## Scope
- `lib/src/widgets/basic/single_child_scroll_view.dart` — _ScrollViewState class only
