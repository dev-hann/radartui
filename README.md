# radartui

A Flutter-like TUI (Text-based User Interface) framework for Dart.

## Overview

RadarTUI brings Flutter's declarative UI paradigm to terminal applications. Build rich, interactive TUI apps with:

- **Widget-based architecture** similar to Flutter
- **Rich styling system** with colors, text styles, and backgrounds  
- **Advanced keyboard input handling** with arrow keys, special keys, and shortcuts
- **Layout widgets** like Row, Column, Container, Padding, Center
- **State management** with StatefulWidget and setState
- **Real-time rendering** with efficient diff-based updates

## Features

### Core Widgets
- `Text` - Styled text with colors, bold, italic, underline
- `Container` - Layout container with padding, margin, and background colors
- `Row/Column` - Flexbox-style layouts
- `Padding` - Add spacing around widgets
- `Center` - Center widgets within their parent
- `SizedBox` - Fixed-size spacing

### Styling
- 16 standard terminal colors (black, red, green, yellow, blue, magenta, cyan, white + bright variants)
- Text styles: bold, italic, underline
- Background colors
- ANSI escape sequence support

### Input Handling
- Full keyboard support including:
  - Regular characters and numbers
  - Arrow keys (↑↓←→)
  - Special keys (Enter, Escape, Tab, Backspace, Delete)
  - Navigation keys (Home, End, Page Up/Down)
  - Ctrl combinations
- Real-time key event parsing and handling

## Examples

Run any example with `dart run example/<filename>.dart`:

### Basic Examples
- **`main.dart`** - Simple counter that increments on any key press
- **`style_demo.dart`** - Showcase of colors, styles, and Container widgets

### Interactive Applications  
- **`calculator.dart`** - Fully functional calculator with keyboard input
- **`guess_game.dart`** - Number guessing game with feedback and scoring
- **`spinner_demo.dart`** - Loading animations with progress bars and status updates
- **`dashboard.dart`** - Real-time system monitoring dashboard with graphs
- **`advanced_keyboard.dart`** - Complete keyboard testing application

### Quick Start

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
          'Hello RadarTUI!',
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

## Architecture

RadarTUI follows Flutter's layered architecture:

1. **Foundation Layer** - Basic data types (Size, Offset, Color, EdgeInsets)
2. **Services Layer** - Terminal interaction, keyboard input, output buffering  
3. **Rendering Layer** - Layout calculation and painting system
4. **Widgets Layer** - User-facing widget API
5. **Scheduler Layer** - Frame scheduling and rendering pipeline

## Development Status

This project is currently under heavy development. The API is not stable and is subject to change.
