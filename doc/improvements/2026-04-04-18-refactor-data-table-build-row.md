# Loop 18: Refactor _DataTableState._buildDataRow()

## Problem
`_DataTableState._buildDataRow()` in `lib/src/widgets/basic/data_table.dart` is 34 lines. AGENTS.md coding standards require functions ≤ 30 lines.

## Plan
Extract `_buildDataCell()` for individual cell rendering.

## Scope
- `lib/src/widgets/basic/data_table.dart` — _DataTableState class only
