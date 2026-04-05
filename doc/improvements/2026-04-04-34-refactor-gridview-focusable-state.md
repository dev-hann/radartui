# 2026-04-04-34: Refactor _GridViewState to use FocusableState mixin

## Problem

`_GridViewState` manually manages FocusNode lifecycle (register/unregister/dispose, listener setup/teardown, `_hasFocus` tracking) despite the `FocusableState` mixin already providing this exact functionality.

Duplicate code:
- `FocusManager.instance.registerNode(_focusNode)` / `unregisterNode`
- `_focusNode.addListener(_onFocusChanged)` / `removeListener`
- `_focusNode.dispose()`
- `bool _hasFocus` field + `_onFocusChanged()` method

## Solution

Replace manual FocusNode management with `FocusableState<GridView<T>>` mixin, matching the pattern already used by `_ButtonState`, `_CheckboxState`, and `_RadioState`.

## Scope

- `lib/src/widgets/basic/grid_view.dart` — `_GridViewState` class only

## Design

1. Add `with FocusableState<GridView<T>>` to `_GridViewState`
2. Remove: `_focusNode` field, `_hasFocus` field, manual `initState`/`dispose` focus code, `_onFocusChanged`
3. Rename `_handleKeyEvent` → `onKeyEvent` (mixin override)
4. Replace `_hasFocus` references → `hasFocus` (mixin getter)
5. Keep `selectedIndex` initialization in `initState` via `super.initState()` call

## Tests

No new tests needed — existing GridView tests should pass unchanged (behavior is identical).

## Result

- Removed 28 lines, added 10 lines (-18 net)
- Removed: `_focusNode` field, `_hasFocus` field, manual `dispose()`, `_onFocusChanged()`, manual FocusManager registration
- Added: `with FocusableState<GridView<T>>`, `onKeyEvent` override
- `dart analyze`: 0 issues
- `dart test`: 1077/1077 passed
