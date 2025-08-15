# RadarTUI Architecture & Development Guide 🏗️

This document provides comprehensive architectural information and development guidelines for RadarTUI, a Flutter-like TUI framework for Dart.

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Directory Structure](#-directory-structure)
- [Core Components](#-core-components)
- [Dependencies & Import Graph](#-dependencies--import-graph)
- [Refactoring Guidelines](#-refactoring-guidelines)
- [Common Patterns](#-common-patterns)
- [Performance Considerations](#-performance-considerations)
- [Testing Strategy](#-testing-strategy)
- [Future Improvements](#-future-improvements)

## 🎯 Project Overview

RadarTUI is a terminal user interface framework that adapts Flutter's declarative widget paradigm for text-based applications. It provides:

- **Declarative UI**: Widget tree with build() methods
- **State Management**: StatefulWidget/StatelessWidget pattern
- **Efficient Rendering**: Diff-based terminal output
- **Rich Input**: Comprehensive keyboard event handling
- **Flexible Layouts**: Row, Column, Container, Padding, etc.

## 🏗️ Architecture

RadarTUI follows a layered architecture inspired by Flutter:

### Layer Hierarchy (Bottom to Top)

```
┌─────────────────────────────────────────────────────────────┐
│                      Application Layer                      │
│                    (User Applications)                      │
├─────────────────────────────────────────────────────────────┤
│                       Widgets Layer                         │
│           framework.dart, basic/, StatefulWidget            │
├─────────────────────────────────────────────────────────────┤
│                      Scheduler Layer                        │
│              binding.dart, Frame Scheduling                 │
├─────────────────────────────────────────────────────────────┤
│                      Rendering Layer                        │
│            render_object.dart, render_box.dart              │
├─────────────────────────────────────────────────────────────┤
│                      Services Layer                         │
│       terminal.dart, output_buffer.dart, key_parser.dart    │
├─────────────────────────────────────────────────────────────┤
│                     Foundation Layer                        │
│         Basic types: Size, Offset, Color, EdgeInsets        │
└─────────────────────────────────────────────────────────────┘
```

### Key Design Principles

1. **Separation of Concerns**: Each layer has specific responsibilities
2. **Immutable Widgets**: Widgets are immutable; state is separate
3. **Efficient Rendering**: Only changed cells are updated in terminal
4. **Event-Driven**: Keyboard input drives state changes and re-renders

## 📁 Directory Structure

```
lib/
├── radartui.dart                    # Public API exports
└── src/
    ├── foundation/                  # Basic data types & constants
    │   ├── alignment.dart          # Alignment options for layouts
    │   ├── axis.dart               # Axis enum (horizontal/vertical)
    │   ├── box_constraints.dart    # Constraints for box layouts
    │   ├── color.dart              # Color & TextStyle classes
    │   ├── constants.dart          # Layout constants & magic numbers
    │   ├── edge_insets.dart        # Spacing/padding utilities
    │   ├── offset.dart             # 2D position representation
    │   └── size.dart               # 2D dimensions
    │
    ├── services/                    # System interaction layer
    │   ├── key_parser.dart         # Keyboard input parsing
    │   ├── logger.dart             # Debug logging system
    │   ├── output_buffer.dart      # Terminal output buffering
    │   └── terminal.dart           # Terminal control (cursor, colors)
    │
    ├── rendering/                   # Layout & painting engine
    │   ├── render_object.dart      # Base rendering primitives
    │   └── render_box.dart         # Box layout model & constraints
    │
    ├── scheduler/                   # Frame scheduling & lifecycle
    │   └── binding.dart            # Main app lifecycle & frame pump
    │
    └── widgets/                     # User-facing widget API
        ├── framework.dart          # Core widget system (Widget, Element, State)
        ├── basic.dart              # Widget exports
        ├── focus_manager.dart      # Manages widget focus state
        ├── navigation.dart         # Navigator and routing system
        ├── navigator_observer.dart # Observer for navigator events
        └── basic/                  # Concrete widget implementations
            ├── button.dart         # Clickable button widget
            ├── center.dart         # Centering layout widget
            ├── column.dart         # Vertical flex layout
            ├── container.dart      # Box model widget with styling
            ├── dialog.dart         # Dialog box widget
            ├── flex.dart           # Base flex layout widget
            ├── focus.dart          # Widget to manage focus
            ├── indicator.dart      # Loading indicator widget
            ├── list_view.dart      # Scrollable list of widgets
            ├── padding.dart        # Spacing widget
            ├── row.dart            # Horizontal flex layout
            ├── sized_box.dart      # Fixed-size constraints
            ├── text.dart           # Styled text rendering
            └── textfield.dart      # Text input field widget
```

## 🧩 Core Components

### Foundation Layer (`lib/src/foundation/`)

**Purpose**: Provides basic data types used throughout the framework.

#### Key Files:

- **`constants.dart`** ⭐ CENTRAL CONFIG

  - Layout constants (max dimensions, defaults)
  - Prevents magic numbers scattered throughout codebase
  - Import this whenever using layout calculations

- **`color.dart`**

  - 16 ANSI terminal colors + bright variants
  - TextStyle class with equals/hashCode implementation
  - Used by: output_buffer, container, text widgets

- **`size.dart`**, **`offset.dart`**, **`edge_insets.dart`**
  - Basic geometry types
  - Used extensively in layout calculations
  - Immutable value objects

- **`alignment.dart`**: Defines alignment values for positioning.

- **`box_constraints.dart`**: Defines constraints for `RenderBox` widgets.

### Services Layer (`lib/src/services/`)

**Purpose**: Handles system-level interactions and I/O.

#### Key Files:

- **`terminal.dart`** 🖥️ TERMINAL CONTROL

  - ANSI escape sequences for cursor positioning
  - Terminal size detection with fallbacks
  - Color/style output formatting

- **`output_buffer.dart`** ⚡ RENDERING OPTIMIZATION

  - Double-buffered terminal output
  - Only updates changed cells (diff-based)
  - Cell equality optimization with proper hashCode
  - Critical for performance at large terminal sizes

- **`key_parser.dart`** ⌨️ INPUT HANDLING

  - Raw keyboard input → structured KeyEvent objects
  - Handles special keys, arrow keys, Ctrl combinations
  - ANSI escape sequence parsing
  - const constructors for performance

- **`logger.dart`** 🐛 DEBUG SUPPORT
  - File-based logging (avoids terminal interference)
  - Can be extended to override print() function

### Rendering Layer (`lib/src/rendering/`)

**Purpose**: Layout calculation and painting abstraction.

#### Key Files:

- **`render_object.dart`** 🎨 PAINTING ABSTRACTION

  - Base classes: RenderObject, PaintingContext, Constraints
  - Layout protocol: performLayout() → paint()
  - Parent-child relationships and tree traversal

- **`render_box.dart`** 📐 BOX LAYOUT MODEL
  - BoxConstraints system (like CSS box model)
  - FlexParentData for flex layouts
  - ContainerRenderObjectMixin for multi-child containers

### Scheduler Layer (`lib/src/scheduler/`)

**Purpose**: Frame scheduling and application lifecycle.

#### Key Files:

- **`binding.dart`** ⚙️ MAIN APP CONTROLLER
  - SchedulerBinding singleton: the heart of the framework
  - Frame scheduling: build → layout → paint pipeline
  - Keyboard input stream management
  - Signal handling (Ctrl+C, terminal resize)
  - App initialization and cleanup

### Widgets Layer (`lib/src/widgets/`)

**Purpose**: Declarative UI API that users interact with.

#### Key Files:

- **`framework.dart`** 🏛️ WIDGET SYSTEM CORE
  - Widget, Element, State base classes
  - Widget lifecycle: createElement() → mount() → build() → update()
  - Element tree management and updateChild() logic
  - StatefulWidget/StatelessWidget patterns

- **`focus_manager.dart`**: Manages the focus tree and handles focus changes.

- **`navigation.dart`**: Provides a `Navigator` for routing and screen management.

- **`navigator_observer.dart`**: Listens to navigator events.

#### Widget Implementations (`lib/src/widgets/basic/`):

- **`text.dart`**: Text rendering with styles
- **`container.dart`**: Box model with padding, margin, colors
- **`row.dart`/`column.dart`**: Flex layouts (horizontal/vertical)
- **`center.dart`**: Centers child within available space
- **`padding.dart`**: Adds spacing around child
- **`sized_box.dart`**: Fixed dimensions and spacing
- **`button.dart`**: A pressable button widget.
- **`dialog.dart`**: A widget for creating dialog boxes.
- **`focus.dart`**: A widget for managing focus for its descendants.
- **`indicator.dart`**: A widget to show a loading indicator.
- **`list_view.dart`**: A scrollable list of widgets.
- **`textfield.dart`**: A text input field.

## 🔗 Dependencies & Import Graph

### Import Rules & Dependencies

```
Application Code
    ↓ imports
radartui.dart (public API)
    ↓ exports
widgets/framework.dart + widgets/basic.dart
    ↓ depends on
scheduler/binding.dart ← rendering/render_*.dart ← services/*.dart ← foundation/*
```

### Critical Dependencies:

1. **widgets/framework.dart** depends on:

   - `scheduler/binding.dart` (for frame scheduling)
   - `rendering/render_*.dart` (for RenderObject)

2. **scheduler/binding.dart** depends on:

   - `services/terminal.dart`, `services/output_buffer.dart`, `services/key_parser.dart`
   - `rendering/render_box.dart` (for constraints)

3. **rendering/render_box.dart** depends on:

   - `foundation/constants.dart` (for layout constants)
   - All foundation types

4. **All service classes** depend on:
   - `foundation/` types
   - Some services may depend on each other (e.g., output_buffer → terminal)

### Import Guidelines:

- **Always import foundation/constants.dart** when using magic numbers
- **Use relative imports** within the same layer
- **Use package imports** for cross-layer dependencies
- **Avoid circular dependencies** between layers

## 🔧 Refactoring Guidelines

### Recently Completed Refactoring (2024)

1. **Code Duplication Removal**:

   - Moved `_updateChild()` from 3 classes → `Element.updateChild()`
   - Location: `lib/src/widgets/framework.dart:29`

2. **Constants Centralization**:

   - Created `lib/src/foundation/constants.dart`
   - Replaced magic numbers with named constants

3. **Performance Optimizations**:

   - TextStyle equals/hashCode implementation
   - Container background rendering optimization
   - const constructors in KeyParser

4. **Error Handling Improvements**:
   - Keyboard input parsing with try-catch
   - Terminal mode setting error handling
   - StreamController disposal safety

### Refactoring Principles:

#### 🎯 When to Refactor:

1. **Code Duplication**: 3+ identical code blocks
2. **Magic Numbers**: Hardcoded constants without explanation
3. **Performance Issues**: O(n²) algorithms, unnecessary allocations
4. **Poor Error Handling**: Silent failures, unhandled exceptions
5. **Tight Coupling**: Classes that know too much about each other

#### 🛠️ How to Refactor Safely:

1. **Understand Dependencies**: Use the import graph above
2. **Start from Foundation**: Refactor lower layers first
3. **Maintain Public APIs**: Don't break the `lib/radartui.dart` exports
4. **Test Each Layer**: Verify examples still work
5. **Document Changes**: Update this file with architectural changes

#### ⚠️ Refactoring Danger Zones:

1. **framework.dart**: Core widget system - changes affect everything
2. **binding.dart**: App lifecycle - breaking this breaks all apps
3. **output_buffer.dart**: Rendering performance - changes affect visual output
4. **Public exports in radartui.dart**: User-facing API breaks

### Refactoring Checklist:

- [ ] Does this change maintain backward compatibility?
- [ ] Are all imports updated for new file locations?
- [ ] Do all examples still compile and run?
- [ ] Is the change documented in this file?
- [ ] Are new constants added to `foundation/constants.dart`?
- [ ] Are error cases handled properly?

## 📋 Common Patterns

### Widget Implementation Pattern:

```dart
// 1. Widget class (immutable configuration)
class MyWidget extends RenderObjectWidget {
  final String data;
  final Color? color;

  const MyWidget(this.data, {this.color});

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderMyWidget createRenderObject(BuildContext context) =>
      RenderMyWidget(data, color);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderMyWidget;
    render.data = data;
    render.color = color;
  }
}

// 2. RenderObject class (layout + painting)
class RenderMyWidget extends RenderBox {
  String data;
  Color? color;

  RenderMyWidget(this.data, this.color);

  @override
  void performLayout(Constraints constraints) {
    // Calculate size based on constraints and content
    size = Size(data.length, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw to terminal buffer
    for (int i = 0; i < data.length; i++) {
      context.buffer.writeStyled(
        offset.x + i, offset.y, data[i],
        TextStyle(color: color)
      );
    }
  }
}
```

### State Management Pattern:

```dart
class StatefulExample extends StatefulWidget {
  const StatefulExample();

  @override
  State<StatefulExample> createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  int _counter = 0;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // Set up listeners, subscriptions
    _subscription = SchedulerBinding.instance.keyboard.keyEvents.listen(_onKey);
  }

  @override
  void dispose() {
    // Clean up resources
    _subscription?.cancel();
    super.dispose();
  }

  void _onKey(KeyEvent event) {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}
```

### Error Handling Pattern:

```dart
// Services layer error handling
void updateTerminalMode(bool value) {
  try {
    stdin.lineMode = value;
    stdin.echoMode = value;
  } catch (e) {
    AppLogger.log('Failed to set terminal mode: $e');
    // Continue execution - don't break the app
  }
}

// Input parsing error handling
static KeyEvent parseInput(List<int> data) {
  try {
    // Parse input
    return KeyEvent(parsedKey);
  } catch (e) {
    AppLogger.log('Input parsing error: $e');
    return const KeyEvent('Unknown');
  }
}
```

## ⚡ Performance Considerations

### Critical Performance Areas:

1. **Output Buffering** (`output_buffer.dart`):

   - Only render changed cells
   - Use proper equals/hashCode for Cell objects
   - Avoid string concatenation in hot paths

2. **Layout Calculations** (render\_\*.dart):

   - Cache size calculations when possible
   - Avoid nested loops in layout algorithms
   - Use constraints to limit work

3. **Memory Management**:

   - Use const constructors where possible
   - Dispose subscriptions and streams
   - Avoid creating objects in paint() methods

4. **Input Processing** (`key_parser.dart`):
   - Pre-allocate common KeyEvent instances
   - Use switch statements over if-else chains

### Performance Monitoring:

```dart
// Add performance logging to hot paths:
final stopwatch = Stopwatch()..start();
// ... expensive operation ...
AppLogger.log('Operation took: ${stopwatch.elapsedMilliseconds}ms');
```

## 🧪 Testing Strategy

### Testing Levels:

1. **Unit Tests**: Individual classes and functions

   - Foundation types (Size, Offset, Color)
   - Services (KeyParser, OutputBuffer logic)
   - Widget creation and configuration

2. **Integration Tests**: Cross-layer interactions

   - Widget → RenderObject communication
   - Keyboard input → state changes
   - Layout calculation pipelines

3. **End-to-End Tests**: Full application scenarios
   - Example applications run correctly
   - Terminal output matches expectations
   - Keyboard navigation works

### Testing Guidelines:

- Mock terminal I/O for consistent test environments
- Test error cases (invalid input, terminal failures)
- Verify performance characteristics (no O(n²) algorithms)
- Test memory cleanup (subscription disposal)

## 🚀 Future Improvements

### High Priority:

1. **Animation System**:

   - Tween-based animations
   - Integration with frame scheduler
   - Smooth transitions between states

2. **Theme System**:
   - Centralized color/style configuration
   - Light/dark theme support
   - Custom theme definitions

### Medium Priority:

4. **Widget Testing Framework**:

   - Widget test utilities
   - Mock terminal environment
   - Assertion helpers for TUI apps

5. **Performance Profiling**:

   - Frame time monitoring
   - Memory usage tracking
   - Performance regression detection

6. **Advanced Layouts**:
   - Grid layouts
   - Scrollable containers
   - Flexible sizing (similar to Flutter's Flexible/Expanded)

### Low Priority:

7. **Accessibility**:

   - Screen reader support
   - High contrast modes
   - Keyboard-only navigation

8. **Developer Tools**:
   - Widget inspector
   - Layout debugging visualization
   - Performance flamegraphs

### Architecture Evolution:

As the framework grows, consider these architectural improvements:

- **Plugin System**: Allow third-party widgets and services
- **Multi-Threading**: Background layout calculations
- **Hot Reload**: Development-time UI updates
- **Widget Composition**: Higher-order widget patterns

## 🔄 Version History & Migration

### v0.0.1 (Current):

- Basic widget system
- Text rendering and styling
- Simple layouts (Row, Column, Container)
- Keyboard input handling
- Focus Management
- Navigation and Routing

### Future Versions:

- Document breaking changes here
- Provide migration guides
- Maintain backward compatibility when possible

---

## 📞 Contact & Contributions

When contributing to RadarTUI:

1. **Read this document** thoroughly to understand the architecture
2. **Follow the refactoring guidelines** to maintain code quality
3. **Update this document** when making architectural changes
4. **Test your changes** with the provided examples
5. **Consider performance implications** of your changes

This document is a living guide - keep it updated as the framework evolves! 🚀