# Project Overview: radartui

**radartui** is a TUI (Text-based User Interface) framework written in Dart, inspired by [ratatui](https://github.com/ratatui-org/ratatui) from the Rust ecosystem. It enables developers to build structured, interactive terminal interfaces in a Flutter-like widget system.

## Key Features

- Widget-based layout system (Row, Column, Expanded, etc.)
- Keyboard event handling with focus management
- Input-ready `TextField` with cursor support
- Scrollable `ListView`
- Rich styling system (bold, underline, inverted, etc.)
- Designed for Dart developers — no native dependencies

## Technologies Used

- **Language**: Dart
- **Dependencies**: `collection`, `meta`
- **Dev Dependencies**: `lints`, `test`

## Getting Started

To get started with `radartui`, you need the Dart SDK. Once installed, you can clone the repository and run the example:

```bash
git clone https://github.com/dev-hann/radartui.git
cd radartui
dart run
```

## Project Structure

The project follows a typical Dart package structure:

- `lib/`: Contains the core `radartui` framework, organized into modules like `canvas`, `enum`, `input`, `logger`, `model`, `state`, `view`, and `widget`.
- `example/`: Provides a sample application demonstrating the usage of the `radartui` framework.
- `test/`: Contains unit tests for the `radartui` library.
- `assets/`: Stores project assets, such as `radartui.png`.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).