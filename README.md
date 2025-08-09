# RadarTUI 🎯

A Flutter-like TUI (Text-based User Interface) framework for Dart that brings declarative UI to terminal applications.

[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🌟 Features

RadarTUI brings Flutter's declarative UI paradigm to terminal applications with:

- **🎨 Widget-based Architecture** - Familiar Flutter-style declarative UI
- **🎯 Rich Styling System** - Colors, text styles, backgrounds, and ANSI support
- **⌨️ Advanced Input Handling** - Arrow keys, special keys, shortcuts, and real-time events
- **📐 Flexible Layouts** - Row, Column, Container, Padding, Center, and more
- **🔄 State Management** - StatefulWidget, setState, and reactive updates
- **⚡ Efficient Rendering** - Diff-based updates and optimized terminal output
- **🖥️ Cross-platform** - Works on macOS, Linux, and Windows terminals

## 🚀 Quick Start

### Installation

Add RadarTUI to your `pubspec.yaml`:

```yaml
dependencies:
  radartui: ^0.0.1
```

### Hello World

```dart
import 'package:radartui/radartui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.blue,
      child: Center(
        child: Text(
          'Hello RadarTUI! 🎯',
          style: TextStyle(
            color: Color.white,
            bold: true,
          ),
        ),
      ),
    );
  }
}
```

## 📦 Core Widgets

| Widget | Description |
|--------|-------------|
| `Text` | Styled text with colors, bold, italic, underline |
| `Container` | Layout container with padding, margin, background |
| `Row/Column` | Flexbox-style horizontal/vertical layouts |
| `Padding` | Add spacing around child widgets |
| `Center` | Center widgets within their parent |
| `SizedBox` | Fixed-size spacing and constraints |

## 🎨 Styling System

### Colors
- **Standard Colors**: black, red, green, yellow, blue, magenta, cyan, white
- **Bright Variants**: All standard colors with bright versions
- **Custom Colors**: Support for 256-color terminals

### Text Styles
```dart
TextStyle(
  color: Color.green,
  backgroundColor: Color.black,
  bold: true,
  italic: true,
  underline: true,
)
```

## ⌨️ Input Handling

RadarTUI provides comprehensive keyboard input support:

- **Regular Keys**: All printable characters and numbers
- **Arrow Keys**: ↑↓←→ navigation
- **Special Keys**: Enter, Escape, Tab, Backspace, Delete
- **Navigation**: Home, End, Page Up/Down
- **Control**: Ctrl combinations (Ctrl+C, Ctrl+D, etc.)

## 📁 Examples

Explore the `example/` directory for comprehensive demos:

```bash
# Basic counter app
dart run example/main.dart

# Styling showcase
dart run example/style_demo.dart

# Interactive calculator
dart run example/calculator.dart

# Number guessing game
dart run example/guess_game.dart

# Loading animations
dart run example/spinner_demo.dart

# System monitoring dashboard
dart run example/dashboard.dart
```

## 🏗️ Architecture

RadarTUI follows a layered architecture inspired by Flutter:

```
┌─────────────────────────────────────┐
│            Widgets Layer            │  ← User-facing API
├─────────────────────────────────────┤
│           Scheduler Layer           │  ← Frame scheduling
├─────────────────────────────────────┤
│           Rendering Layer           │  ← Layout & painting
├─────────────────────────────────────┤
│           Services Layer            │  ← Terminal I/O
├─────────────────────────────────────┤
│          Foundation Layer           │  ← Basic types
└─────────────────────────────────────┘
```

## 🧪 Development Status

⚠️ **Alpha Release**: This project is under active development. The API may change between versions.

### Roadmap
- [x] Core widget system
- [x] Basic layouts (Row, Column, Container)
- [x] Text styling and colors
- [x] Keyboard input handling
- [x] Efficient rendering pipeline
- [ ] Animation system
- [ ] Focus management
- [ ] Theme system
- [ ] Widget testing utilities
- [ ] Performance profiling tools

## 🤝 Contributing

We welcome contributions! Please see [CLAUDE.md](CLAUDE.md) for detailed architecture information and development guidelines.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/your-org/radartui.git
cd radartui

# Get dependencies
dart pub get

# Run examples
dart run example/main.dart

# Run tests
dart test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

RadarTUI is heavily inspired by [Flutter](https://flutter.dev) and brings its declarative UI paradigm to terminal applications. Special thanks to the Flutter team for the amazing architecture patterns.
