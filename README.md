# RadarTUI

A Flutter-inspired TUI framework for Dart. Build terminal UIs with declarative widgets, state management, diff-based rendering, and a rich widget library.

[![pub package](https://img.shields.io/pub/v/radartui.svg)](https://pub.dev/packages/radartui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue)](https://pub.dev/packages/radartui)

---

## Key Features

- **Declarative UI** - Flutter-like widget tree structure where the UI automatically updates when state changes
- **Rich Widget Library** - `Row`, `Column`, `Text`, `Container`, `Button`, `TextField`, `DataTable`, `TabBar`, and more
- **Efficient Rendering** - Diff-based terminal rendering that only redraws changed cells
- **Flexible Layout System** - Flexbox-based layout with `Flex`, `Stack`, `Wrap`, `GridView`, and `ListView`
- **State Management** - `StatelessWidget`, `StatefulWidget`, and `InheritedWidget` patterns
- **Focus Management** - Keyboard navigation and focus control between widgets
- **Animation System** - `AnimationController`, `Tween`, `CurvedAnimation` with easing curves
- **Navigation** - `Navigator`, `Route`, and `Dialog` for multi-screen apps
- **Keyboard Shortcuts** - `Shortcuts`, `Actions`, and `ShortcutActionsHandler` system
- **Widget Testing** - Built-in testing framework for TUI applications

## Architecture

RadarTUI follows a layered architecture inspired by Flutter:

```
┌──────────────────────────┐
│     Application Layer    │  User Applications
├──────────────────────────┤
│       Widgets Layer      │  Declarative UI Widgets
├──────────────────────────┤
│      Scheduler Layer     │  Frame Scheduling & Lifecycle
├──────────────────────────┤
│      Rendering Layer     │  Layout & Painting
├──────────────────────────┤
│       Services Layer     │  Terminal Control, I/O
├──────────────────────────┤
│      Foundation Layer    │  Basic Data Types
└──────────────────────────┘
```

## Getting Started

### 1. Add Dependency

Add RadarTUI to your `pubspec.yaml`:

```yaml
dependencies:
  radartui: ^0.0.2
```

### 2. Create Your First App

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
        'Press any key to increment the counter: $_counter\n'
        "Press 'q' to quit.",
        style: const TextStyle(color: AnsiColor.green),
      ),
    );
  }
}
```

### 3. Run Examples

```sh
cd example
dart pub get
dart run
```

## Available Widgets

| Category | Widgets |
|----------|---------|
| Layout | `Row`, `Column`, `Flex`, `Expanded`, `SizedBox`, `Padding`, `Center`, `Align`, `Spacer`, `Stack`, `Positioned`, `Wrap`, `GridView`, `ListView` |
| Display | `Text`, `RichText`, `Icon`, `Container`, `Card`, `Divider`, `SizedBox`, `DataTable` |
| Input | `Button`, `TextField`, `Checkbox`, `Radio`, `Toggle`, `Slider`, `DropdownButton`, `Form` |
| Navigation | `Navigator`, `Dialog`, `TabBar`, `TabBarView`, `MenuBar` |
| Status | `StatusBar`, `Toast`, `LinearProgressIndicator`, `CircularProgressIndicator` |
| Utility | `Builder`, `LayoutBuilder`, `StreamBuilder`, `FutureBuilder`, `SingleChildScrollView` |

## API Reference

Full API documentation is available at [pub.dev/documentation/radartui](https://pub.dev/documentation/radartui/latest/).

## Contributing

Contributions are welcome! Bug reports, feature suggestions, and code contributions are appreciated.

## License

RadarTUI is distributed under the [MIT License](LICENSE).
