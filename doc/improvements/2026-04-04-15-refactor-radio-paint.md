# Loop 15: Refactor RenderRadio.paint()

## Problem
`RenderRadio.paint()` in `lib/src/widgets/basic/radio.dart` is 42 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_paintIndicator()` for the radio indicator drawing logic.

## Scope
- `lib/src/widgets/basic/radio.dart` — RenderRadio class only
