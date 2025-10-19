## 📁 lib/src/foundation

This directory contains the most basic components of the RadarTUI framework. It defines core data types, constants, and utility classes that are used in common by all other layers.

### Key Files

- **`alignment.dart`**: Used to specify the alignment direction.
- **`axis.dart`**: Defines the main axis (horizontal/vertical) of widgets like `Row` or `Column`.
- **`box_constraints.dart`**: Defines the constraints that limit the minimum/maximum size a widget can have.
- **`change_notifier.dart`**: Provides a change notification API using the observer pattern. Used for state management.
- **`color.dart`**: Defines ANSI colors and text styles that can be used in the terminal.
- **`constants.dart`**: Centrally manages layout-related constant values used throughout the framework.
- **`edge_insets.dart`**: Defines the inner padding values used in widgets like `Padding`.
- **`offset.dart`**: Represents a location (x, y) in a 2D coordinate system.
- **`size.dart`**: Represents a size (width, height) in a 2D space.