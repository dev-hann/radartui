# Changelog

## 0.0.1

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
