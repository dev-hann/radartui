# Loop 13: Refactor RenderRichText._wrapLines() + performLayout()

## Problem
`RenderRichText._wrapLines()` (46 lines) and `performLayout()` (39 lines) in `lib/src/widgets/basic/rich_text.dart` exceed the 30-line limit.

## Plan
1. Break `_wrapLines()` into: `_wrapSingleRun()` (wrap a single text run)
2. Break `performLayout()` into: `_measureRuns()` (compute total dimensions)

## Scope
- `lib/src/widgets/basic/rich_text.dart` — RenderRichText class only
