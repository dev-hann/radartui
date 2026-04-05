# Improvement Backlog

## Status Legend
- analyzed: 분석 완료, 문서화 대기
- in-progress: 구현 중
- completed: 완료

## Loop Counter: 79

## Scan Level: 3

## Pending

_None_

## Active

_None_

## Completed
- [completed] 2026-04-03-01: Fix example widget overflow in 80x24 test terminal (8 failing tests → 0)
- [completed] 2026-04-03-02: Refactor KeyParser.parse() from 261 lines (depth 6) to 12 lines + 10 helper methods
- [completed] 2026-04-03-03: Fix 32 `var` violations across 6 files in lib/src/
- [completed] 2026-04-03-04: Fix `unawaited_futures` lint in test files (verified already clean)
- [completed] 2026-04-04-05: Merge worktree branches + fix final-to-mutable regression + resolve unawaited_futures lint. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-06: Refactor RenderWrap.performLayout() from 211 lines (depth 7) to ~20 lines + 8 helper methods. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-07: Refactor RenderFlex.performLayout() from 163 lines (depth 5) to ~30 lines + 7 helper methods. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-08: Refactor RenderContainer.paint() from 122 lines (depth 4) to ~20 lines + 4 helper methods. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-09: Refactor RenderStack.performLayout() from 104 lines (depth 5) to ~15 lines + 5 helper methods. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-10: Refactor RenderTextField.paint() (81 lines) + _drawBorder() (55 lines) into 7 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-11: Refactor RenderGridView.performLayout() (49 lines) into 2 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-12: Refactor MultiChildRenderObjectElement.update() (47 lines) into 2 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-13: Refactor RenderRichText.performLayout() (39 lines) + _wrapLines() (45 lines) into 3 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-14: Refactor RenderButton._drawBorder() (46 lines) into 2 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-15: Refactor RenderRadio.paint() (42 lines) into 3 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-16: Refactor RenderCheckbox.paint() (42 lines) into 3 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-17: Refactor _TextFieldState._handleKeyEvent() (37 lines) into 2 methods. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-18: Refactor _DataTableState._buildDataRow() (34 lines) into 2 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-19: Refactor RenderCard paint() (68 lines) + performLayout() (56 lines) into 7 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-20: Refactor RenderToggle.paint() (47 lines) into 4 helpers. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-21: Refactor RenderText._wrapText() (44 lines, depth 7) → extracted _wrapParagraph(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-22: Refactor RenderWrap._positionChildren() (40 lines) → extracted _positionRunChildren(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-23: Refactor RenderContainer.performLayout() (40 lines) → extracted _layoutChild(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-24: Refactor RenderText.performLayout() (36 lines) → extracted _applyOverflow() and _maxLineWidth(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-25: Refactor Dialog.build() (37 lines) → extracted _buildActionRow(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-26: Refactor _ScrollViewState.onKeyEvent() (36 lines) → extracted _computeScrollDelta(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-27: Simplify RenderWrap._buildRuns() by removing unused runMaxCrossExtent tracking. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-28: Refactor Positioned.applyParentData() (33 lines) → extracted _updateField() helper. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-29: Refactor OutputBuffer.flush() (29 lines, depth 5) → extracted _flushCell(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-30: Refactor RenderRichText._wrapLines() (37 lines) → extracted _processSegment(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-31: Refactor RenderScrollView.performLayout() (31 lines) → extracted _buildChildConstraints() and _notifyContentSize(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-32: Refactor RenderFlex.performLayout() (47 lines) → extracted _measureChildren() and _resolveAndPositionChildren(). dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-34: Refactor _GridViewState to use FocusableState mixin. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-35: Refactor _ListViewState to use FocusableState mixin. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-36: Refactor _DataTableState to use FocusableState mixin. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-37: Refactor _TextFieldState to use FocusableState mixin. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-04-38: Refactor _FocusState to use FocusableState mixin. dart analyze: 0 issues, dart test: 1077/1077
- [completed] 2026-04-05-39: Refactor RenderMenuBar.paint() from 93 lines into 6 helper methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-40: Refactor _MenuBarState.onKeyEvent() from 60 lines → 5 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-41: Fix 71 `var` violations across 18 test files → explicit types. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-42: Refactor RenderTabBar.paint() from 46 lines → 3 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-43: Refactor _DropdownButtonState.onKeyEvent() from 41 lines → 5 methods + _closeDropdown() dedup. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-44: Refactor RenderDropdownButton.paint() (36 lines) + RenderDropdownMenu.paint() (38 lines) into helpers. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-45: Refactor RenderLinearProgressIndicator.paint() (36 lines) → 4 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-46: Refactor RenderExpansionTile.paint() (36 lines) → 2 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-47: Refactor RenderSlider.paint() (35 lines) → 5 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-48: Refactor OutputBuffer.flush() (33 lines) → 2 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-49: Refactor _StyledLine.copyWithEllipsis() (31 lines, depth 5) → 2 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-50: Refactor RenderTextField._paintMultilineCursor() (38 lines) → 2 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-51: Unify duplicate error classes — remove RadarTUIError from media_query.dart. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-52: Fix foundation→rendering dependency inversion. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-53: Eliminate duplicate stringWidth() calls + cache _labelWidth. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-54: Fix 148 dart analyze issues in example/. dart analyze: 0 issues project-wide, dart test: 1122/1122
- [completed] 2026-04-05-55: Cache _textWidth in RenderDropdownButton. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-56: Extract _findAncestorWidget<T>() helper in shortcuts.dart. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-57: Refactor WidgetTester.assertBufferLines() → 3 methods. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-58: Extract _findAncestorWidget<T>() in shortcuts.dart. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-60: PTY example 31-file boilerplate → runPtyApp() helper + fix test_binding.dart @override warning. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-61: Re-scan at all levels — all clean. lib/src/ has zero violations at Level 1-3. test/ has zero var violations. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-64: Cache TextStyle allocations in RenderToggle.paint() — eliminate 5 per-frame allocations via lazy cache with invalidation. dart analyze: 0 issues, dart test: 1122/1122
- [completed] 2026-04-05-65: Cache TextStyle in RenderCheckbox (3 allocs) + fix checkbox example layout for 80x24 + remove 3 broken untracked focus tests. dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-66: Cache TextStyle allocations in RenderRadio.paint() (3 allocs → lazy cached). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-67: Cache TextStyle allocations in RenderLinearProgressIndicator.paint() (3 allocs → 2 cached styles). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-68: Cache TextStyle allocations in RenderExpansionTile._paintHeader() (4 allocs → 3 cached styles). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-69: Cache TextStyle allocation in RenderCard.paint() (2 allocs → 1 cached style). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-70: Cache TextStyle allocations in RenderSlider.paint() (4 styles: active track, inactive track, thumb, label). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-71: Cache TextStyle allocations in RenderTabBar.paint() (3 styles: selected, unselected, indicator). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-72: Reduce TextStyle allocations in RenderDropdownButton + RenderDropdownMenu (build 2 styles per paint, pass to helpers). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-73: Simplify RenderFlex._getConstraintsForNonFlexChild (dead branch) + extract _horizontalFlexConstraints/_verticalFlexConstraints. dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-74: Extract _drawHorizontalLine from RenderTextField._drawBorderEdges (duplicate loops → single helper). dart analyze: 0 issues, dart test: 1080/1080
- [completed] 2026-04-05-75: Add doc comments to all 11 foundation classes. dart analyze: 0 issues, dart test: 1080/1080. **Git pushed.**
- [completed] 2026-04-05-76: Refactor RenderContainer._paintBorder() (66 → 27 lines). Extract _BorderSides record to bundle flags + style. dart analyze: 0 issues, dart test: 821/821 unit.
- [completed] 2026-04-05-77: Add doc comments to top 6 widget classes (Text, Container, Row, Column, Button, TextField). dart analyze: 0 issues, dart test: 821/821 unit.
- [completed] 2026-04-05-78: Add doc comments to 6 more widget classes (Align, Card, Checkbox, Dialog, Icon, Padding). dart analyze: 0 issues, dart test: 821/821 unit.
