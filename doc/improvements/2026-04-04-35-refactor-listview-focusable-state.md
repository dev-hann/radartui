# 2026-04-04-35: Refactor _ListViewState to use FocusableState mixin

## Problem

`_ListViewState` manually manages FocusNode lifecycle despite `FocusableState` mixin providing this functionality. Same pattern as GridView (fixed in loop 34).

Duplicate code:
- `FocusManager.instance.registerNode(_focusNode)` / `unregisterNode`
- `_focusNode.addListener(_onFocusChanged)` / `removeListener`
- `_focusNode.dispose()`
- `bool _hasFocus` field + `_onFocusChanged()` method

## Solution

Replace manual FocusNode management with `FocusableState<ListView<T>>` mixin. ScrollController lifecycle remains in `_ListViewState`.

## Scope

- `lib/src/widgets/basic/list_view.dart` — `_ListViewState` class only

## Design

1. Add `with FocusableState<ListView<T>>` to `_ListViewState`
2. Remove: `_focusNode` field, `_hasFocus` field, `_onFocusChanged()`, FocusManager calls
3. Rename `_handleKeyEvent` → `onKeyEvent` (mixin override)
4. Replace `_hasFocus` → `hasFocus`
5. Keep ScrollController logic in `initState`/`dispose`

## Result

- Removed 20 lines, added 6 lines (-14 net)
- Removed: `_focusNode` field, `_hasFocus` field, `_onFocusChanged()`, manual FocusManager registration/unregistration, manual FocusNode dispose
- Added: `with FocusableState<ListView<T>>`, `onKeyEvent` override
- `dart analyze`: 0 issues
- `dart test`: 1077/1077 passed
