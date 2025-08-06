# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**radartui** is a TUI (Text-based User Interface) framework written in Dart, inspired by ratatui from Rust. It provides a Flutter-like widget system for building interactive terminal applications.

## Common Development Commands

### Running the Application
```bash
dart run                    # Run the main application
dart run example/bin/       # Run the example application
```

### Testing
```bash
dart test                   # Run all tests
dart test test/specific_test.dart  # Run a specific test
```

### Code Analysis and Linting
```bash
dart analyze               # Static analysis using analysis_options.yaml
dart format .             # Format all Dart files
```

### Dependencies
```bash
dart pub get              # Install dependencies
dart pub upgrade          # Update dependencies
```

## Architecture Overview

The framework follows an **Elm-like architecture** with a **Widget-Element-RenderObject** pattern similar to Flutter:

### Core Components

1. **Widget Layer** (`lib/widget/`)
   - `Widget`: Abstract base class for all widgets
   - `StatelessWidget`: Immutable widgets that build once
   - `StatefulWidget`: Widgets with mutable state and lifecycle
   - `Element`: Bridge between widgets and render objects
   - `RenderObject`: Handles layout and painting

2. **Canvas System** (`lib/canvas/`)
   - `Canvas`: Terminal rendering abstraction
   - `Rect`: Rectangle geometry for layout
   - `Style`: Text styling (colors, formatting)
   - `Size`: Dimension handling

3. **Input System** (`lib/input/`)
   - `Input`: Keyboard event handling with stream-based architecture
   - `Key`: Key event model with support for special keys and modifiers

4. **Focus Management** (`lib/widget/focus_manager.dart`)
   - Singleton pattern for managing focus state
   - Tab navigation between focusable widgets
   - Automatic focus registration/cleanup

5. **State Management** (`lib/state/state.dart`)
   - Base State class for focus management utilities
   - Integration with FocusManager for navigation

### Widget Types

- **Layout Widgets**: `Row`, `Column`, `Expanded`, `Padding`, `Align`
- **Interactive Widgets**: `Button`, `TextField`, `ListView`
- **Display Widgets**: `Text`, `Card`

### Element Tree Architecture

The framework uses a three-layer architecture:
- **Widget**: Immutable configuration
- **Element**: Manages widget lifecycle and updates
- **RenderObject**: Handles layout calculations and painting

Key Element types:
- `StatelessElement`: For stateless widgets
- `StatefulElement`: For stateful widgets with lifecycle management
- `RenderObjectElement`: For widgets that directly render content

## Flutter-like Features

### Core Flutter Features Implemented

1. **setState()** - Reactive state management with automatic rebuilds
2. **BuildContext** - Widget tree navigation and context access
3. **Widget Keys** - Unique widget identification with ValueKey, ObjectKey
4. **InheritedWidget** - State sharing down the widget tree
5. **Lifecycle Methods** - initState(), dispose(), didUpdateWidget()
6. **Gesture Detection** - Flutter-like event handling with callbacks
7. **Layout Widgets** - SingleChildWidget, MultiChildWidget, FlexWidget patterns

## Key Patterns

### Widget Creation (Flutter-like)
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [...]);
  }
}
```

### State Management with setState()
```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### InheritedWidget for State Sharing
```dart
class Provider<T> extends InheritedWidget {
  const Provider({required this.value, required super.child});
  
  final T value;
  
  @override
  bool updateShouldNotify(Provider<T> oldWidget) => value != oldWidget.value;
  
  static T? of<T>(BuildContext context) {
    final provider = InheritedWidget.of<Provider<T>>(context);
    return provider?.value;
  }
}
```

### Focus Handling
Widgets can be made focusable by providing a `focusID` parameter. The `FocusManager` singleton handles focus navigation automatically.

## Development Notes

- The codebase is transitioning from an older widget system (`WidgetOld`) to the new Element-based architecture
- Korean comments are present in some files, indicating ongoing development
- The framework uses Dart's `meta` package for annotations like `@mustCallSuper`
- Canvas rendering runs in a 100ms loop for real-time updates
- Input handling is stream-based for reactive keyboard events
- Focus management follows a registration pattern where widgets auto-register when rendered

## Platform Support

- ✅ Linux terminal
- ✅ macOS terminal (iTerm2, Apple Terminal)
- ❌ Windows (not yet supported)

## Dependencies

- `collection`: Enhanced collection utilities
- `meta`: Annotations for static analysis
- `lints`: Dart linting rules (recommended set)
- `test`: Unit testing framework