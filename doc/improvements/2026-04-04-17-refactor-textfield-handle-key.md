# Loop 17: Refactor _TextFieldState._handleKeyEvent()

## Problem
`_TextFieldState._handleKeyEvent()` in `lib/src/widgets/basic/textfield.dart` is 37 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract key handling into separate methods for each key type: `_handleBackspace()`, `_handleDelete()`, `_handleCharacterInput()`.

## Scope
- `lib/src/widgets/basic/textfield.dart` — _TextFieldState class only
