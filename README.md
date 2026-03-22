# RadarTUI: A Flutter-Inspired TUI Framework for Dart

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Dart](https://img.shields.io/badge/Platform-Dart-blue.svg)](https://dart.dev)
[![Style: effective_dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://dart.dev/guides/language/effective-dart)

**RadarTUI is a Flutter-style framework for building beautiful and responsive Terminal User Interfaces (TUIs) using Dart.** Easily develop complex terminal applications with a declarative widget paradigm.

---

## 🎯 Key Features

- **✨ Declarative UI**: A Flutter-like widget tree structure where the UI automatically updates when the state changes.
- **📦 Rich Widget Library**: Provides essential layout and UI widgets like `Row`, `Column`, `Text`, `Container`, `Button`, `TextField`, and more.
- **⚡️ Efficient Rendering**: Intelligent diff-based terminal rendering optimization that only redraws the parts that have changed.
- **⌨️ Flexible Input Handling**: Easily handle keyboard events and interact with the application state.
- **🎨 Flexible Layout System**: Easily configure complex UIs with a powerful Flexbox-based layout widget.
- **🧭 Intuitive State Management**: Clear and predictable state management through `StatelessWidget` and `StatefulWidget` patterns.

## 🏗️ Architecture

RadarTUI follows a layered architecture inspired by Flutter. Each layer has a clearly defined role, enhancing the code's maintainability and scalability.

```
┌──────────────────────────┐
│     Application Layer    │ (User Applications)
├──────────────────────────┤
│       Widgets Layer      │ (Declarative UI Widgets)
├──────────────────────────┤
│      Scheduler Layer     │ (Frame Scheduling & Lifecycle)
├──────────────────────────┤
│      Rendering Layer     │ (Layout & Painting)
├──────────────────────────┤
│       Services Layer     │ (Terminal Control, I/O)
├──────────────────────────┤
│      Foundation Layer    │ (Basic Data Types)
└──────────────────────────┘
```

For more detailed architecture information, please refer to the [AGENTS.md](AGENTS.md) document.

## 🚀 Getting Started

### 1. Add Dependency

Add RadarTUI to your `pubspec.yaml` file.

```yaml
dependencies:
  radartui:
    path: ../ # Or specify the pub.dev version
```

### 2. Basic Example Code

Here is a simple counter application example.

```dart
import 'package:radartui/radartui.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatefulWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      if (event.key == 'q') {
        shutdown();
      } else {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Press any key to increment the counter: $_counter
Press 'q' to quit.',
        style: const TextStyle(color: AnsiColor.green),
      ),
    );
  }
}
```

## 📦 How to Run Examples

Check out the various examples included in the project to see the features of RadarTUI.

1.  Navigate to the `example` directory.

    ```sh
    cd example
    ```

2.  Install dependencies.

    ```sh
    dart pub get
    ```

3.  Run the desired example. (`main.dart` provides a menu to select various examples)
    ```sh
    dart run
    ```

## 🗺️ Roadmap

RadarTUI is continuously evolving, with plans for the following features:

- [ ] **Animation System**: Smooth visual transitions for state changes.
- [ ] **Focus Management System**: Keyboard navigation and focus control between widgets.
- [ ] **Theme System**: Centralized management of colors and styles for the entire application.
- [ ] **Widget Testing Framework**: Testing utilities for TUI applications.
- [ ] **Advanced Layout Widgets**: More layout options like `Grid`, `Stack`, `ListView`.

## 🤝 Contributing

Contributions to RadarTUI are welcome! Bug reports, feature suggestions, code contributions, and any other form of participation are appreciated.

Before you start contributing, reading the [AGENTS.md](AGENTS.md) architecture document will be very helpful in understanding the project structure.

## 📜 License

RadarTUI is distributed under the [MIT License](LICENSE).