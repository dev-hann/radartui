# 2026-04-05-76: Refactor RenderContainer._paintBorder() (66 → ≤30 lines)

## Problem
`RenderContainer._paintBorder()` is 66 lines, violating the 30-line limit from AGENTS.md Section 3.

The verbosity comes from computing 4 border-side flags + passing many named parameters to 4 helper calls.

## Design
1. Extract a `_BorderSides` record to group the 4 bool flags + TextStyle
2. Compute flags once in `_paintBorder` via a `_computeBorderSides()` helper
3. Simplify `_paintHorizontalBorder` and `_paintVerticalBorder` signatures to accept `_BorderSides`
4. Result: `_paintBorder` shrinks to ~15 lines of dispatch

## Scope
- `lib/src/widgets/basic/container.dart` only

## Flutter Reference
Flutter's `Container` uses `DecoratedBox` for borders — no direct render-object equivalent. Our approach is framework-internal optimization, not API change.

## Testing
Existing `test/integration/container_test.dart` covers border rendering. No new tests needed.
