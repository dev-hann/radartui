## 📁 lib/src/rendering

This directory contains the core logic of the rendering engine, which determines how to place and draw the widget tree on the actual screen. It is responsible for layout calculation and painting abstraction.

### Key Files

- **`render_object.dart`**: Defines `RenderObject`, the base class for all render objects. It is the core of the rendering pipeline, containing the `performLayout()` (layout calculation) and `paint()` (drawing) protocols.
- **`render_box.dart`**: Defines a render object based on a 2D box constraints (`BoxConstraints`) system, similar to the box model in CSS. This is the standard layout model used by most widgets.