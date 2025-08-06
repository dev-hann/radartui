# Radartui Architecture

This document outlines the architecture of the Radartui framework. It is designed to be a comprehensive guide for developers contributing to the project, explaining the core concepts, the responsibilities of each layer, and how they interact.

## Core Philosophy

The architecture is heavily inspired by Flutter, aiming to bring the declarative, reactive, and compositional paradigms to terminal user interfaces.

- **Everything is a Widget**: The UI is built by composing immutable `Widget` objects.
- **From Widgets to Pixels (Characters)**: A multi-layered pipeline transforms the widget tree into characters on the terminal screen.
- **Clear Separation of Concerns**: Each layer has a distinct responsibility, making the system easier to understand, test, and maintain.

## The Layered Architecture

The framework is divided into several layers, each building upon the one below it. The primary data flow is as follows:

**Widgets Layer** ➜ **Rendering Layer** ➜ **Services Layer**

--- 

### 1. Foundation Layer (`lib/src/foundation`)

- **Responsibility**: Provides fundamental, universal data types and utilities that are used across all other layers. This layer has no dependencies on other parts of the framework.
- **Key Components**:
  - `Color`: Represents a terminal color (e.g., ANSI colors).
  - `Size`, `Offset`, `Rect`: Core 2D geometry classes.
  - `Key`: A mechanism to identify and preserve state for widgets across rebuilds.
  - `Diagnosticable`: An interface for classes to provide detailed debugging information.

### 2. Services Layer (`lib/src/services`)

- **Responsibility**: Handles all direct interactions with the host system's terminal. It abstracts away the low-level details of terminal control, providing a clean API to the upper layers.
- **Key Components**:
  - `Terminal`: A service that provides information about the terminal, such as its dimensions.
  - `RawKeyboard`: A service that captures raw key presses from `stdin`.
  - `AnsiStyler`: A utility for creating ANSI escape codes for colors and text styles.
  - `OutputBuffer`: A crucial component for performance. It manages a 2D grid of characters representing the terminal screen. Drawing commands write to this buffer, and a `flush` operation intelligently updates only the changed parts of the real terminal, minimizing flicker.

### 3. Rendering Layer (`lib/src/rendering`)

- **Responsibility**: This is the core of the graphics pipeline. It takes a tree of `RenderObject`s and is responsible for layout and painting.
- **Key Concepts**:
  - **Render Tree**: A tree of `RenderObject` instances that mirrors the structure of the UI.
  - **Layout**: The process of determining the size and position of each `RenderObject`. It follows a strict protocol: constraints go down the tree, and sizes go up.
  - **Painting**: The process of drawing the `RenderObject`s onto a canvas-like abstraction (provided by the `OutputBuffer` from the Services Layer). The painting order is generally parent-first, then children.
- **Key Components**:
  - `RenderObject`: The base class for all objects in the render tree. Defines the abstract `layout()` and `paint()` methods.
  - `RenderBox`: The most common type of `RenderObject`, which lives in a 2D Cartesian coordinate system.
  - `PipelineOwner`: Manages the rendering pipeline, initiating layout and painting.

### 4. Widgets Layer (`lib/src/widgets`)

- **Responsibility**: Provides the user-facing API for building the UI. This is where developers will spend most of their time.
- **Key Concepts**:
  - **Widget Tree**: The immutable configuration for the UI, built by the developer.
  - **Element Tree**: The mutable instantiation of the widget tree. The `Element` tree is the glue that connects the `Widget` configuration to the stateful `RenderObject` tree. It is responsible for efficiently updating the UI by comparing new widget trees with old ones.
- **Key Components**:
  - `Widget`: The base class for all widgets. `StatelessWidget` and `StatefulWidget` are the primary building blocks.
  - `Element`: The base class for all elements. `ComponentElement` and `RenderObjectElement` are key subclasses.
  - `BuildContext`: A handle to a widget's location in the widget tree, passed to `build` methods.
  - **Basic Widgets**: `Text`, `Row`, `Column`, `Padding`, `Align`, etc. These are the fundamental pieces used to compose a UI.

### 5. Scheduler Layer (`lib/src/scheduler`)

- **Responsibility**: Drives the entire rendering pipeline. It decides *when* to build, lay out, and paint a new frame.
- **Key Components**:
  - `SchedulerBinding`: A singleton that connects the other layers. It listens for requests to schedule a new frame (e.g., from `setState()` or input events).
  - `runApp(Widget app)`: The main entry point for a Radartui application. It inflates the given widget and attaches it to the screen, kicking off the initial frame.

--- 

## How It All Fits Together: The Rendering Pipeline

1.  **`runApp(app)` is called**: The `SchedulerBinding` is initialized, and the root widget is inflated, creating the initial Widget, Element, and Render trees.
2.  **Frame is Scheduled**: The scheduler decides it's time to render the first frame.
3.  **Build**: The `Element` tree is built from the `Widget` tree.
4.  **Layout**: The `RenderingLayer` walks the `RenderObject` tree, calculating the size and position of every object.
5.  **Paint**: The `RenderingLayer` walks the `RenderObject` tree again, calling the `paint()` method on each object. The paint commands are written to the `OutputBuffer` in the `ServicesLayer`.
6.  **Flush**: The `OutputBuffer` compares its new state to the previous state and sends a minimal set of ANSI commands to the terminal to update the display.

When a `StatefulWidget` calls `setState()`:

- It notifies the framework that its state has changed.
- The `SchedulerBinding` schedules a new frame.
- During the `build` phase, the framework rebuilds only the necessary parts of the `Widget` tree.
- The `Element` tree is updated. It reuses existing elements where possible and updates their underlying `RenderObject`s with new configuration from the new widgets.
- The layout and paint phases are run again, and the screen is updated.
