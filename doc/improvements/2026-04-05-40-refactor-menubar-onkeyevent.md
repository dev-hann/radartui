# Refactor _MenuBarState.onKeyEvent() (60 lines → helpers)

## Problem

`_MenuBarState.onKeyEvent()` in `lib/src/widgets/basic/menu_bar.dart:51-110` is 60 lines (2x the 30-line limit) with 4 levels of nesting. It handles both closed-state and open-state keyboard navigation in a single method.

## Design

Extract 2 helper methods:

| Method | Responsibility | Target Lines |
|--------|---------------|-------------|
| `_handleClosedKeyEvent(KeyEvent event)` | Handle keys when menu is closed | ~20 |
| `_handleOpenKeyEvent(KeyEvent event)` | Handle keys when menu is open | ~36 |

`onKeyEvent()` becomes ~5 lines: dispatch based on `_openMenuIndex`.

## Scope

- `lib/src/widgets/basic/menu_bar.dart` only
- No test changes needed (no existing tests)
- No Flutter reference needed (terminal-specific behavior)

## Risk

Low — behavior unchanged, only structure modified.

## Result

Extracted 4 helper methods from `onKeyEvent()` (60 lines → 5 methods):

- `onKeyEvent()`: 7 lines (dispatch)
- `_handleClosedKeyEvent()`: 16 lines
- `_handleOpenKeyEvent()`: 28 lines
- `_activateSelectedItem()`: 7 lines (shared enter logic)
- `_closeMenu()`: 5 lines (shared close logic)

Also extracted `_closeMenu()` to eliminate duplicated close pattern in both enter and escape handlers. Max nesting reduced from 4 to 3. All 1122 tests pass.
