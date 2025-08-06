# Radartui Implementation Plan

This document outlines the step-by-step plan to implement the Radartui framework based on the scaffolded project structure. The development follows a bottom-up approach, starting from the most fundamental layers and progressively building up to the final application-facing API.

---

### **Phase 1: Project Setup & Dependencies**

-   **Goal**: Ensure the project is correctly configured before starting to code.
-   **Tasks**:
    1.  Run `dart pub get` in the project root directory.
    2.  Run `dart pub get` in the `example/` directory.

### **Phase 2: Foundation Layer Implementation**

-   **Goal**: Complete the functionality of core data types used by all other layers.
-   **Tasks**:
    1.  **`size.dart`, `offset.dart`**: Implement arithmetic (`+`, `-`) and comparison (`==`, `hashCode`) operators.
    2.  **`rect.dart`**: Implement getters like `top`, `left`, `right`, `bottom`, and utility methods like `contains` and `overlaps`.
    3.  **`key.dart`**: Implement comparison operators.

### **Phase 3: Services Layer Implementation (Terminal I/O)**

-   **Goal**: Finalize the low-level functionality for drawing to the terminal and receiving input. This phase will enable visible output on the screen.
-   **Tasks**:
    1.  **`styler.dart`**: Implement the logic in `AnsiStyler` to generate actual ANSI escape codes for colors and styles (bold, underline, etc.).
    2.  **`terminal.dart`**: Implement the methods in the `Terminal` class (`hideCursor`, `clear`, `setCursorPosition`) using `stdout.write` and the corresponding ANSI codes.
    3.  **`output_buffer.dart`**:
        -   Add style properties (color, etc.) to the `Cell` class.
        -   Implement the `write` method in `OutputBuffer` to store `Cell` data in the in-memory `_grid`.
        -   **Core Task**: Implement the **screen diffing algorithm** in the `flush` method. This involves comparing the `_grid` with `_previousGrid` and sending a minimal set of ANSI commands to the terminal for updates.
    4.  **`keyboard.dart`**:
        -   Define the `KeyEvent` class, including properties for character, control keys, etc.
        -   Implement the `RawKeyboard` service to set `stdin` to raw mode and transform the input byte stream into a `Stream<KeyEvent>`.

### **Phase 4: Rendering Layer Implementation (Layout & Paint)**

-   **Goal**: Build the engine that calculates how and where widgets should be drawn on the screen.
-   **Tasks**:
    1.  **`render_object.dart`**:
        -   Implement child management methods (`add`, `remove`, `visitChildren`).
        -   Add 'dirty' flag logic for optimization (`markNeedsLayout`, `markNeedsPaint`).
    2.  **`render_box.dart`**: Implement the basic layout logic for `RenderBox`.
    3.  **`pipeline.dart`**: Implement the `flushLayout()` and `flushPaint()` logic in `PipelineOwner` to traverse the render tree and call `layout()` and `paint()` on each `RenderObject` in the correct order.
    4.  **`painting_context.dart`**: Define the painting API that uses the `OutputBuffer` to execute drawing commands (e.g., `drawText`).

### **Phase 5: Widgets Layer Implementation (UI Composition API)**

-   **Goal**: Complete the core logic for `Widget`, `State`, and `Element` that developers will use to build UIs.
-   **Tasks**:
    1.  **`element.dart`**: Implement the `mount`, `update`, and `unmount` methods to create, update, and destroy `RenderObject`s. **(This is a critical part of the framework)**.
    2.  **`framework.dart`**: Implement the `mount` and `update` logic for `ComponentElement`. This involves recursively calling `build()` to get a child widget and then mounting/updating the corresponding child `Element`.
    3.  **`state.dart`**: Implement the `setState` method in the `State` class. This should trigger a rebuild by marking the element as dirty and requesting a new frame from the `Scheduler`.

### **Phase 6: Scheduler Layer Implementation (Orchestration)**

-   **Goal**: Finalize the engine that connects all layers and drives the entire rendering pipeline.
-   **Tasks**:
    1.  **`binding.dart`**:
        -   Implement `runApp`: Create the initial `Widget`, `Element`, and `RenderObject` trees and attach them to the pipeline.
        -   Implement `scheduleFrame`: Use a `Timer` or `scheduleMicrotask` to efficiently handle frame requests.
        -   Implement `handleFrame` **(The Main Loop)**: Execute the pipeline in the correct order: `build` -> `layout` -> `paint` -> `flush` (from OutputBuffer).

### **Phase 7: Concrete Widget & RenderObject Implementation**

-   **Goal**: Implement actual, visible widgets like `Text` and `Column` and their corresponding rendering logic.
-   **Tasks**:
    1.  Create concrete `RenderBox` subclasses in the `rendering` layer, such as `RenderText` and `RenderFlex` (for Column/Row).
    2.  Implement the `build` methods in `widgets/basic.dart` to create and update these `RenderObject`s via their corresponding `RenderObjectWidget`s.

### **Phase 8: Testing & Example App**

-   **Goal**: Visually verify the framework's functionality with the example app and ensure stability with unit tests.
-   **Tasks**:
    1.  Build a meaningful UI in `example/main.dart` by composing `Column`, `Row`, `Text`, etc.
    2.  Run `dart run example/main.dart` to see the results and debug.
    3.  Begin writing unit tests in the `test/` directory, starting with the `foundation` and `services` layers.
