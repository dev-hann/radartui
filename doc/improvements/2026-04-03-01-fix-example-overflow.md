# Fix Example Widget Overflow in 80x24 Test Terminal

## Problem
8 integration tests fail because example widgets use fixed-width Container headers and layouts that overflow the 80x24 test terminal. The rendered output clips expected text, causing assertion failures.

### Root Cause
- `grid_view_example.dart`: Container `width: 50` header + padding(2 each side = 4) + Center = title overflows right edge. Only "Widget" is visible.
- `radio_example.dart`: Container `width: 50` header + padding(4) = 54+ columns. Multiple sections overflow vertically (24 rows).
- `checkbox_example.dart`: Container `width: 50` header + padding(4). Too many sections for 24 rows.
- `data_table_example.dart`: Container `width: 70` header + padding(2) = 72+ columns. Tight fit with data.

### Failing Tests
1. `grid_view_example_test.dart`: "renders grid with items" (line 11)
2. `grid_view_example_test.dart`: "displays selected item" (line 32)
3. `radio_example_test.dart`: "renders radio button groups" (line 11)
4. `radio_example_test.dart`: "shows priority and language options" (line 23)
5. `radio_example_test.dart`: "displays current selection" (line 43)
6. `checkbox_example_test.dart`: "renders checkboxes and labels" (line 11)
7. `checkbox_example_test.dart`: "displays current selection status" (line 33)
8. `data_table_example_test.dart`: "shows table data" (line 22)

## Improvement
Reduce header Container widths and tighten layouts in all 4 example files to fit within 80x24. Also remove `const` from Container headers where width needs to change.

### Strategy
- Shrink header widths from 50/70 to 40-50 depending on title text
- Reduce padding where possible
- Ensure all asserted text fits within 80 columns and 24 rows

## Impact
- `example/src/grid_view_example.dart`
- `example/src/radio_example.dart`
- `example/src/checkbox_example.dart`
- `example/src/data_table_example.dart`
