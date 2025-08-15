# RadarTUI Architecture & Development Guide 🏗️

This document provides comprehensive architectural information and development guidelines for RadarTUI, a Flutter-like TUI framework for Dart.

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

1.  **Separation of Concerns**: Each layer has specific responsibilities.
2.  **Immutable Widgets**: Widgets are immutable; state is separate.
3.  **Efficient Rendering**: Only changed cells are updated in the terminal.
4.  **Event-Driven**: Keyboard input drives state changes and re-renders.

## 📁 Directory Structure

This directory structure provides a high-level overview. For more details on the role of each directory and its files, **please refer to the `README.md` file within each directory.**

```
lib/
├── radartui.dart
└── src/
    ├── foundation/ (-> see lib/src/foundation/README.md)
    ├── services/   (-> see lib/src/services/README.md)
    ├── rendering/  (-> see lib/src/rendering/README.md)
    ├── scheduler/  (-> see lib/src/scheduler/README.md)
    └── widgets/    (-> see lib/src/widgets/README.md)
        └── basic/  (-> see lib/src/widgets/basic/README.md)
example/            (-> see example/README.md)
└── src/            (-> see example/src/README.md)
```

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

1.  **widgets/framework.dart** depends on:
    - `scheduler/binding.dart` (for frame scheduling)
    - `rendering/render_*.dart` (for RenderObject)

2.  **scheduler/binding.dart** depends on:
    - `services/terminal.dart`, `services/output_buffer.dart`, `services/key_parser.dart`
    - `rendering/render_box.dart` (for constraints)

3.  **rendering/render_box.dart** depends on:
    - `foundation/constants.dart` (for layout constants)
    - All foundation types

4.  **All service classes** depend on:
    - `foundation/` types
    - Some services may depend on each other (e.g., output_buffer → terminal)

### Import Guidelines:

- **Always import foundation/constants.dart** when using magic numbers.
- **Use relative imports** within the same layer.
- **Use package imports** for cross-layer dependencies.
- **Avoid circular dependencies** between layers.

## 🎨 Coding Style & Rules

For detailed Dart coding style, lint rules, naming conventions, and code quality verification procedures, please refer to the **[CLAUDE.md](CLAUDE.md)** document.

## 📖 Documentation Guide

This project aims for folder-based documentation to improve code readability and maintainability. When you change the code, you **must** update the relevant documentation with it.

### 🔄 Documentation Update Process

1.  **Code Change**: Modify, add, or delete files within a specific folder.
2.  **Check Relevant `README.md`**: Open the `README.md` file of the folder where the change occurred.
3.  **Modify Document Content**:
    - If the role of a file has changed, update its description.
    - If a new file has been added, add it to the list with a brief description.
    - If a file has been deleted, remove it from the list.
    - If the overall role of the folder has changed, also modify the folder description at the top of the `README.md`.
4.  **Commit Changes Together**: Submit the code changes and document changes as a single atomic commit. It is good practice to specify that the commit includes documentation changes, such as with `docs:`.

**Example Commit Message:**

```
feat(widgets): Add ListView widget and update docs

- Add new ListView widget for scrollable lists.
- Update `lib/src/widgets/basic/README.md` to include ListView.
```

Please cooperate to keep all project documents up-to-date through this guide.