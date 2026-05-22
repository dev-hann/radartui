# Changelog

## 0.0.3 (2026-05-23)

### Foundation & Rendering
- Fix `StyleCache._isValid` starting as true on empty cache
- Fix `BoxConstraints` remove dead `asBoxConstraints` getter
- Fix `RenderObject.layout()` propagation chain — use `markNeedsLayout()`
- Fix `ContainerRenderObjectMixin.children` returning mutable internal list
- Add assert for non-negative `Size` dimensions
- Fix `EdgeInsets.only` parameter order to match Flutter (left, top, right, bottom)
- Deprecate `Colors` class in favor of `Color` static constants
- Fix `TextStyle.merge` doc comment to reflect union semantics

### Widget Bug Fixes
- Fix checkbox, radio, toggle border rendering (correct positions `[ ]`, `( )`)
- Fix textfield vertical border not rendering (`bufferHeight` not passed)
- Fix card `_resolveDimension` ignoring min/max constraints
- Fix card and container negative child constraints
- Fix `DropdownButton` null crash when value not in items + background width
- Fix `DropdownButton` generic type `T` lost in menu render widget
- Fix `LinearProgressIndicator` losing null value (indeterminate mode dead code)
- Fix `DataTable` duplicate space-key handling and `_focusedRowIndex` out of bounds
- Fix `DefaultTextStyle.maybeOf` never returning null
- Fix `GridView` and `ListView` selectedIndex out of bounds on items change
- Fix `FocusScope._removeNodeAtIndex` not decrementing currentIndex
- Fix `FocusableState._swapFocusNode` not triggering onFocusChange
- Fix `ScrollableState` recreating controller on every didUpdateWidget
- Rename `ScrollController.animateTo` to `jumpTo` (no animation implemented)
- Fix `FutureBuilder` unsafe cast `AsyncSnapshot<Never> as AsyncSnapshot<T>`
- Fix `ExpansionTile` accessing controller private field instead of public API
- Fix `ListView` MediaQuery dependency not registered
- Fix `LayoutBuilder` unnecessary element unmount/remount on every layout

### Framework Fixes
- Fix `ComponentElement` never unmounting `_child` (memory leak)
- Fix `InheritedElement.update` notifying dependents after rebuild (wrong order)
- Fix `ParentDataElement` double-updating child in mount and update
- Fix `TextFormField` not integrating with `Form` registration (now extends `FormField<String>`)

### Stability Improvements
- Fix `StreamBuilder` setState after dispose from stream callbacks
- Fix `Checkbox`, `Radio`, `LinearProgressIndicator`, `CircularProgressIndicator` AnimationController listener leaks
- Fix `RawKeyboard` crashing on piped stdin (try-catch for echoMode/lineMode)

### Structural Improvements
- Refactor `Divider` to extract shared base classes, eliminating ~80 lines of duplication
- Unify `Colors.` → `Color.` usage across theme and dialog widgets
- Fix `foundation.dart` export ordering

### Documentation
- Add `TESTING.md`, `ROADMAP.md`, `doc/ARCHITECTURE.md`, `doc/CONVENTIONS.md`
- Update `AGENTS.md` with TDD enforcement, feature checklist, and super.key clarification

## 0.0.2 (2026-04-05)

- Expand pubspec description for pub.dev compliance
- Upgrade `ffi` dependency to `^2.0.0`
- Add `platforms` field (linux, macos, windows)
- Improve README with pub.dev badges and widget catalog
- Add dartdoc comments to public API elements
- Exclude log files and dev-only files from published package

## 0.0.1 (2026-04-05)

Initial release of RadarTUI.

### Core Framework
- Flutter-like Widget, Element, RenderObject architecture
- `StatelessWidget`, `StatefulWidget`, `InheritedWidget`
- Layout system: `Row`, `Column`, `Flex`, `Stack`, `Positioned`, `Wrap`, `Grid`
- Basic widgets: `Text`, `Container`, `Button`, `TextField`, `Checkbox`, `Radio`
- Advanced widgets: `DataTable`, `TabBar`/`TabBarView`, `DropdownButton`, `Icon`, `ListView`, `GridView`
- Navigation: `Navigator`, `Route`, `Dialog`
- Focus management system
- Theme system (`Theme`, `DefaultTextStyle`, `MediaQuery`)
- Animation system (`AnimationController`, `Tween`, `CurvedAnimation`, `Curves`)
- Form widgets: `Form`, `FormField`, `TextFormField`
- Async widgets: `StreamBuilder`, `FutureBuilder`
- Keyboard shortcuts: `Shortcuts`, `Actions`, `ShortcutActionsHandler`
- Widget testing framework

## 2026-04-01: Phase 4 Animation System

### Core Animation Classes
- `Animation<T>` abstract base with value/status getters and listener management
- `AnimationController` timeline controller (0.0 → 1.0) using SchedulerBinding
- `Tween<T>` / `ColorTween` value interpolation (TUI: snaps at midpoint for discrete ANSI colors)
- `CurvedAnimation` applies easing curves to parent animation
- `Curve` / `Curves` - linear, easeIn, easeOut easing functions

### Widget Integration
- `Button` - focus/unfocus color animation (150ms, easeOut)
- `Checkbox` - check/uncheck color animation (100ms)
- `Radio` - select/deselect color animation (100ms)

### Infrastructure
- Added persistent frame callbacks to `SchedulerBinding`
- `FocusableState` mixin - added `onFocusChange` hook

### Test Coverage
- 856 tests passing (829 → 856)

## 2026-03-31: Phase 1 Widgets

- `IndexedStack` widget
- `TabBar` / `TabBarView` with `TabController`
- `DropdownButton<T>` and `DropdownMenuItem<T>`
- `Shortcuts` / `Actions` / `ShortcutActionsHandler` / `Intent` / `Action`
- `RichText` / `TextSpan`
- `DefaultTextStyle`
- `Icon` widget
- `DataTable` with sorting and selection

## 2025-10-19: Async Widgets

- Added `StreamBuilder<T>`, `FutureBuilder<T>`, `AsyncSnapshot<T>`
- Flutter API compatible

## 2025-03-22: Major Architecture Improvements

### Phase 1: Critical Bug Fixes

- Layout caching (constraints change detection in `RenderObject.layout()`)
- ParentData initialization via `setupParentData()` method
- Stack Positioned bug fix (bottom/right positioning)
- TextField border overflow protection

### Phase 2: Test Coverage Expansion

- Added `framework_test.dart` (Element/Widget lifecycle)
- Added `flex_test.dart` (Flex layout algorithm)
- Added `stack_test.dart` (Stack/Positioned)
- Added `text_test.dart` (Text/RenderText with multiline)
- Test count: 362 → 503

### Phase 3: Performance Improvements

- `RenderObjectWithChildMixin<C>` for single-child render objects
- `RelayoutBoundary` support in `RenderObject`
- ListView virtualization with `ScrollController`
- InheritedWidget dependency cleanup (memory leak fix)

### Phase 4: Feature Additions

- Text multiline support (`softWrap`, `maxLines`, `overflow`)
- `TextSelection` class for text range selection
- `Clipboard` class for copy/paste operations
- `Form`, `FormField<T>`, `TextFormField` widgets
- `Wrap` widget with `WrapAlignment`, `WrapCrossAlignment`
- Word navigation in TextField (`moveCursorWordLeft`, `moveCursorWordRight`)

## 2025-03: Core Framework Improvements

### Phase 1: Critical Bug Fixes

- StatefulElement.unmount, ListView.dispose, ContainerRenderObjectMixin.remove

### Phase 2: Key System

- Key, LocalKey, ValueKey<T>, GlobalKey, UniqueKey

### Phase 3: InheritedWidget

- InheritedWidget, MediaQuery, Theme

### Phase 4: Positioned Widget

- Positioned widget, ParentDataWidget pattern

### Phase 5: Focus System

- Refactored Focus System (explicit register/unregister)

### Phase 6: Code Quality

- Type safety, super.key, @override annotations

### Phase 7: Widget Enhancements

- Spacer, ListView<T>, Stack refactor, TextEditingController ChangeNotifier

### Phase 8: Test Coverage

- ListView, TextEditingController, Button, Checkbox, Radio, Spacer

### Phase 9: Navigation

- Route lifecycle, canPop, ModalRoute FocusScope
