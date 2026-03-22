# RadarTUI - AI Development Guide

> Flutter-like TUI framework for Dart

---

## 0. ⚠️ MANDATORY: Git Worktree Workflow

> **모든 AI 작업은 반드시 worktree에서 시작해야 합니다.**
> 메인 디렉토리(`~/Documents/radartui/`)에서 직접 수정 금지.

### Pre-Work Checklist (작업 전 필수)

- [ ] 작업 유형에 맞는 브랜치 네이밍 결정 (`feat/`, `fix/`, `refactor/`)
- [ ] Worktree 생성: `git worktree add ../.worktrees/<branch> -b <branch>`
- [ ] Worktree 디렉토리로 이동 후 작업 시작

### Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. CREATE worktree                                         │
│     git worktree add ../.worktrees/fix-xxx -b fix/xxx       │
├─────────────────────────────────────────────────────────────┤
│  2. WORK in isolated environment                            │
│     cd ../.worktrees/fix-xxx                                │
│     ... implement, test, format, analyze ...                │
├─────────────────────────────────────────────────────────────┤
│  3. FINISH: PR → Merge → Cleanup                            │
│     git worktree remove ../.worktrees/fix-xxx               │
└─────────────────────────────────────────────────────────────┘
```

### Commands

```bash
# Create worktree
git worktree add ../.worktrees/<branch-name> -b <branch-name>

# List all worktrees
git worktree list

# After merge, cleanup
git worktree remove ../.worktrees/<branch-name>
```

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feat/xxx` | `feat/add-gridview` |
| Fix | `fix/xxx` | `fix/memory-leak-focus` |
| Refactor | `refactor/xxx` | `refactor/simplify-layout` |

### Directory Structure

```
~/Documents/
├── radartui/              # Main worktree (main branch) - READ ONLY for AI
└── .worktrees/            # AI session worktrees - WORK HERE
    ├── feat-add-gridview/
    ├── fix-memory-leak/
    └── refactor-layout/
```

### Why Worktree?

| Without Worktree | With Worktree |
|-----------------|---------------|
| Main branch 오염 위험 | 격리된 환경에서 안전하게 작업 |
| 여러 작업 동시 진행 불가 | 여러 worktree로 병렬 작업 가능 |
| Rollback 어려움 | worktree 삭제로 즉시 초기화 |

---

## 1. Flutter Reference Principle

**CRITICAL: All implementations MUST reference Flutter's design patterns.**

### Before Implementing Any Widget

1. **Check Flutter source first**: https://github.com/flutter/flutter/tree/master/packages/flutter/lib/src/widgets
2. **Match Flutter API**: Keep constructor parameters, method signatures consistent
3. **Preserve naming**: Use identical class/parameter names unless technically impossible
4. **Maintain behavior**: Widget behavior should match Flutter's semantics

### Flutter → RadarTUI Adaptation Rules

| Flutter | RadarTUI | Reason |
|---------|----------|--------|
| `double` coordinates | `int` coordinates | Terminal cells are discrete |
| `Color(0xFFRRGGBB)` | `Color(value)` | ANSI 16-color palette |
| `Widget build()` | `Widget build()` | Same pattern |
| `State<T>` | `State<T>` | Same pattern |
| Mouse/Touch events | Keyboard events only | Terminal limitation |

### Required Flutter API Compatibility

```dart
// Flutter
class Expanded extends StatelessWidget {
  final int flex;
  final Widget child;
  const Expanded({super.key, this.flex = 1, required this.child});
}

// RadarTUI - MATCH THIS PATTERN
class Expanded extends StatelessWidget {
  final int flex;
  final Widget child;
  const Expanded({this.flex = 1, required this.child});  // No Key support yet
}
```

### When to Deviate from Flutter

- **Terminal limitations**: No mouse, no gradients, no animations (limited)
- **Performance**: Simplified algorithms acceptable for TUI scale
- **Missing dependencies**: Implement minimal versions of Flutter utilities

---

## 2. Architecture

```
┌─────────────────────────────────────────────┐
│              Application Layer              │
├─────────────────────────────────────────────┤
│               Widgets Layer                 │
│     framework.dart, basic/, navigation.dart │
├─────────────────────────────────────────────┤
│              Scheduler Layer                │
│            binding.dart, frames             │
├─────────────────────────────────────────────┤
│              Rendering Layer                │
│        render_object.dart, render_box       │
├─────────────────────────────────────────────┤
│              Services Layer                 │
│    terminal.dart, output_buffer.dart,       │
│           key_parser.dart, logger.dart      │
├─────────────────────────────────────────────┤
│             Foundation Layer                │
│    Size, Offset, Color, EdgeInsets, etc.    │
└─────────────────────────────────────────────┘
```

### Dependency Flow

```
Application → radartui.dart → widgets/ → scheduler/ → rendering/ → services/ → foundation/
```

---

## 3. Directory Structure

```
lib/
├── radartui.dart              # Public API export
└── src/
    ├── foundation/            # Basic types (Size, Offset, Color, EdgeInsets)
    ├── services/              # Terminal I/O, key parsing, logging
    ├── rendering/             # RenderObject tree, layout
    ├── scheduler/             # Frame scheduling, binding
    └── widgets/               # Widget framework
        ├── framework.dart     # Widget, Element, State base classes
        ├── focus_manager.dart # Focus management
        ├── navigation.dart    # Navigator, Route
        └── basic/             # Concrete widgets (Text, Button, etc.)

example/
├── main.dart                  # Example runner with menu
└── src/                       # Individual widget examples
```

---

## 4. Coding Standards

### Mandatory Rules

| Rule | Example |
|------|---------|
| `dart format` before commit | `dart format .` |
| `final` for non-reassigned variables | `final size = Size(10, 5);` |
| No `var` | Use explicit types or `final` |
| `const` for immutable objects | `const Text('hello')` |
| Explicit public API types | `Size layout(BoxConstraints c)` |

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | UpperCamelCase | `RadioGroup` |
| Methods/Variables | lowerCamelCase | `handleInput` |
| Private members | Prefix `_` | `_internalState` |
| Files | snake_case.dart | `radio_button.dart` |
| Static constants | SCREAMING_SNAKE_CASE | `MAX_WIDTH` |

### Code Structure

- Functions: MAX 30 lines, prefer < 20
- Nesting: MAX 3 levels
- One public class per file
- Class member order: static fields → instance fields → constructors → methods

---

## 5. Widget Implementation Pattern

### StatelessWidget Template

```dart
class MyWidget extends StatelessWidget {
  final Widget child;
  
  const MyWidget({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
```

### StatefulWidget Template

```dart
class MyWidget extends StatefulWidget {
  final String value;
  
  const MyWidget({required this.value});
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late String _value;
  
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }
  
  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(_value);
  }
}
```

### RenderObjectWidget Template

```dart
class MyRenderWidget extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;
  
  const MyRenderWidget({
    required this.padding,
    required Widget child,
  }) : super(child: child);
  
  @override
  RenderObject createRenderObject() {
    return RenderMyRender(padding);
  }
  
  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderMyRender).padding = padding;
  }
}

class RenderMyRender extends RenderBox with RenderObjectWithChildMixin {
  EdgeInsets _padding;
  
  RenderMyRender(this._padding);
  
  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }
  
  @override
  void performLayout() {
    // Layout logic
  }
  
  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint logic
  }
}
```

---

## 6. Testing

### 6.1 Test Types

| Type | Location | Purpose |
|------|----------|---------|
| Unit Tests | `test/unit/` | Foundation, Services 로직 검증 |
| Widget Tests | `test/widgets/` | Widget 렌더링, lifecycle 검증 |
| Integration Tests | `test/integration/` | 전체 앱 동작 검증 |

### 6.2 Running Tests

```bash
dart test                    # All tests
dart test test/unit/         # Unit tests only
dart test test/unit/foundation/  # Foundation tests only
dart test test/unit/services/    # Services tests only
```

### 6.3 Test Directory Structure

```
test/
├── unit/
│   ├── foundation/
│   │   ├── box_constraints_test.dart
│   │   ├── offset_test.dart
│   │   ├── edge_insets_test.dart
│   │   ├── size_test.dart
│   │   └── color_test.dart
│   └── services/
│       ├── key_parser_test.dart
│       └── output_buffer_test.dart
├── widgets/
│   └── basic/
│       ├── text_test.dart
│       └── container_test.dart
└── integration/
    └── app_test.dart
```

### 6.4 Bug-Prone Areas (Priority Testing)

| Area | File | Risk |
|------|------|------|
| `isTight` logic | `box_constraints.dart` | HIGH - previously used `>=` instead of `==` |
| `deflate` edge cases | `box_constraints.dart` | HIGH - negative values handling |
| F-key parsing | `key_parser.dart` | HIGH - complex escape sequences |
| Modifier keys | `key_parser.dart` | MEDIUM - shift/alt/ctrl combinations |
| 16-color ANSI | `output_buffer.dart` | MEDIUM - values 10-15 handling |
| Space key | `key_parser.dart` | MEDIUM - was returning `char` instead of `KeyCode.space` |

### 6.5 Unit Test Template

```dart
import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('ClassName', () {
    group('constructor', () {
      test('creates instance with default values', () {
        final instance = ClassName();
        expect(instance.property, equals(defaultValue));
      });
    });

    group('methodName', () {
      test('returns expected result for valid input', () {
        final result = instance.method(validInput);
        expect(result, equals(expectedOutput));
      });

      test('handles edge case', () {
        final result = instance.method(edgeCaseInput);
        expect(result, equals(edgeCaseOutput));
      });
    });
  });
}
```

### 6.6 Interactive Widget Testing

```dart
import 'dart:io';
import 'package:radartui/radartui.dart';

void main() {
  final binding = SchedulerBinding.instance;
  binding.runApp(MyTestWidget());
  FocusManager.instance.initialize();

  Future.delayed(const Duration(milliseconds: 200), () {
    binding.inputTest(' ');
    Future.delayed(const Duration(milliseconds: 100), () {
      binding.inputTest('\n');
      Future.delayed(const Duration(milliseconds: 100), () {
        exit(0);
      });
    });
  });
}
```

### 6.7 Required Test Cases for Interactive Widgets

- [ ] Space key triggers primary action
- [ ] Enter key triggers confirmation
- [ ] Tab key navigates focus
- [ ] ESC key returns to previous screen
- [ ] Visual focus indication works
- [ ] State changes render immediately

---

## 7. Quality Verification

**MANDATORY before any commit:**

```bash
dart analyze
```

**Must return:** `No issues found!`

Fix ALL errors, warnings, and hints. Zero tolerance.

---

## 8. Current Limitations

| Feature | Status | Note |
|---------|--------|------|
| Mouse events | N/A | Terminal limitation |
| Scrolling | Basic | Limited ListView support |
| Animations | Basic | Simple indicators only |

---

## 9. Development History

### 2025-03-22: Major Architecture Improvements
- **Phase 1: Critical Bug Fixes**
  - Layout caching (constraints change detection in `RenderObject.layout()`)
  - ParentData initialization via `setupParentData()` method
  - Stack Positioned bug fix (bottom/right positioning)
  - TextField border overflow protection
  
- **Phase 2: Test Coverage Expansion**
  - Added `framework_test.dart` (Element/Widget lifecycle)
  - Added `flex_test.dart` (Flex layout algorithm)
  - Added `stack_test.dart` (Stack/Positioned)
  - Added `text_test.dart` (Text/RenderText with multiline)
  - Test count: 362 → 503

- **Phase 3: Performance Improvements**
  - `RenderObjectWithChildMixin<C>` for single-child render objects
  - `RelayoutBoundary` support in `RenderObject`
  - ListView virtualization with `ScrollController`
  - InheritedWidget dependency cleanup (memory leak fix)

- **Phase 4: Feature Additions**
  - Text multiline support (`softWrap`, `maxLines`, `overflow`)
  - `TextSelection` class for text range selection
  - `Clipboard` class for copy/paste operations
  - `Form`, `FormField<T>`, `TextFormField` widgets
  - `Wrap` widget with `WrapAlignment`, `WrapCrossAlignment`
  - Word navigation in TextField (`moveCursorWordLeft`, `moveCursorWordRight`)

### 2025-10-19: Async Widgets
- Added `StreamBuilder<T>`, `FutureBuilder<T>`, `AsyncSnapshot<T>`
- Flutter API compatible

### 2025-03: Core Framework Improvements
- **Phase 1**: Fixed critical bugs (StatefulElement.unmount, ListView.dispose, ContainerRenderObjectMixin.remove)
- **Phase 2**: Implemented Key System (Key, LocalKey, ValueKey\<T\>, GlobalKey, UniqueKey)
- **Phase 3**: Implemented InheritedWidget, MediaQuery, Theme
- **Phase 4**: Implemented Positioned widget, ParentDataWidget pattern
- **Phase 5**: Refactored Focus System (explicit register/unregister)
- **Phase 6**: Code quality improvements (type safety, super.key, @override annotations)
- **Phase 7**: Widget enhancements (Spacer, ListView\<T\>, Stack refactor, TextEditingController ChangeNotifier)
- **Phase 8**: Test coverage expansion (ListView, TextEditingController, Button, Checkbox, Radio, Spacer)
- **Phase 9**: Navigation system improvements (Route lifecycle, canPop, ModalRoute FocusScope)

### Implemented Features
- `Expanded` / `Flexible` / `Spacer` widgets
- `MainAxisAlignment` / `CrossAxisAlignment`
- `Positioned` widget
- `Widget Key system` (Key, LocalKey, ValueKey, GlobalKey, UniqueKey)
- `InheritedWidget` (dependency injection)
- `MediaQuery` / `Theme`
- `ListView<T>` (generic support with virtualization)
- `TextEditingController` extends `ChangeNotifier` (with selection, clipboard)
- `Route<T>` lifecycle methods (install, didPush, didPop, dispose)
- `Route.canPop` and `Route.isCurrent`
- `ModalRoute` with FocusScope integration
- `Text` widget with multiline support (softWrap, maxLines, overflow)
- `TextSelection` and `Clipboard` for text editing
- `Form` / `FormField<T>` / `TextFormField` for form validation
- `Wrap` widget for wrapping flex layout
- `RenderObjectWithChildMixin<C>` for optimized single-child render objects
- `RelayoutBoundary` for layout optimization

### Pending Implementation
- `GridView` widget
- `IndexedStack` widget
