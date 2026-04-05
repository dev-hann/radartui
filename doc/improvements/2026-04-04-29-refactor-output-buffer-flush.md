# Loop 29: Refactor OutputBuffer.flush()

## Problem
`OutputBuffer.flush()` in `lib/src/services/output_buffer.dart` has nesting depth 5 (for > for > if > if). AGENTS.md coding standards require nesting ≤ 3 levels.

## Plan
Extract `_flushRow()` for per-row rendering to reduce nesting.

## Scope
- `lib/src/services/output_buffer.dart` — OutputBuffer class only
