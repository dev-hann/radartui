## 📁 lib/src/widgets

This directory contains the core classes related to the widgets that developers use directly to build the UI. It is the foundation of the declarative UI paradigm.

### Key Files and Directories

- **`framework.dart`**: Defines the most fundamental abstract classes of the widget system, such as `Widget`, `Element`, and `State`. It is responsible for the widget lifecycle and element tree management.
- **`basic.dart`**: Exports all the concrete widgets in the `basic/` directory.
- **`focus_manager.dart`**: Contains the logic for managing keyboard focus within the UI and handling focus movement between widgets.
- **`navigation.dart`**: Contains the logic related to the `Navigator` widget, which manages transitions between screens (Routes).
- **`navigator_observer.dart`**: Defines an observer class that detects changes in the `Navigator`'s state (push, pop, etc.) and executes callbacks.
- **`basic/`**: A directory where concrete widget classes used to compose the UI, such as `Text`, `Container`, `Row`, and `Column`, are implemented.