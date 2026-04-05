# Refactor RenderMenuBar.paint() (93 lines → helpers)

## Problem

`RenderMenuBar.paint()` in `lib/src/widgets/basic/menu_bar.dart:202-294` is 93 lines (3x the 30-line limit) with 4 levels of nesting. It handles both the horizontal menu bar painting and the dropdown menu painting in a single method.

## Design

Extract 5 helper methods:

| Method | Responsibility | Target Lines |
|--------|---------------|-------------|
| `_paintMenuBarItems(int x, int y)` | Paint horizontal bar labels | ~15 |
| `_calculateDropdownX(int baseX)` | Compute dropdown X offset | ~5 |
| `_calculateMaxDropdownWidth(MenuBarItem item)` | Compute max column width | ~8 |
| `_paintDropdownRow(int x, int y, MenuItem item, bool isSelected, int maxWidth)` | Paint one dropdown row | ~15 |
| `_paintDropdownMenu(int baseX, int y)` | Orchestrate dropdown painting | ~15 |

`paint()` becomes ~10 lines: compute x/y, call `_paintMenuBarItems`, conditionally call `_paintDropdownMenu`.

## Scope

- `lib/src/widgets/basic/menu_bar.dart` only
- No test changes needed (no existing tests)
- No Flutter reference needed (terminal-specific rendering)

## Terminal Adaptations

N/A — purely internal refactoring of existing terminal-specific code.

## Risk

Low — behavior unchanged, only structure modified.

## Result

Extracted 5 helper methods from `paint()` (93 lines → 6 methods of 7-16 lines each):

- `paint()`: 7 lines (orchestration)
- `_paintMenuBarItems()`: 12 lines
- `_calculateDropdownX()`: 5 lines
- `_calculateMaxDropdownWidth()`: 9 lines
- `_paintDropdownMenu()`: 11 lines
- `_paintDropdownRow()`: 16 lines

Max nesting reduced from 4 to 2. All 1122 tests pass.
