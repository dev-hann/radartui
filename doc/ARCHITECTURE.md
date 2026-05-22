# Architecture

Flutter-inspired TUI framework. All rendering targets the terminal via ANSI escape sequences and direct `write()` syscalls.

## System Overview

```
User Application
       │
  radartui.dart (barrel export)
       │
  ┌────┴────┐
  │ Widgets  │  Widget, Element, State, Navigation, Focus
  └────┬────┘
  ┌────┴────┐
  │Scheduler │  Frame scheduling, Binding
  └────┬────┘
  ┌────┴────┐
  │Rendering │  RenderObject, RenderBox, Layout/Paint
  └────┬────┘
  ┌────┴────┐
  │Services  │  Terminal I/O, KeyParser, Logger, OutputBuffer
  └────┬────┘
  ┌────┴────┐
  │Foundation│  Size, Offset, Color, EdgeInsets, BoxConstraints
  └─────────┘
```

## Layers

### Foundation Layer

Pure Dart data types with no dependencies. No terminal, no rendering, no framework.

- `Size`, `Offset` — 2D integer geometry (terminal cells are discrete)
- `Color` — ANSI 16-color palette value
- `EdgeInsets` — spacing in 4 directions
- `BoxConstraints` — min/max width/height constraints
- `Axis`, `Flex`, `Alignment` — layout enumerations
- `ChangeNotifier` — observable value holder

### Services Layer

Terminal I/O and input processing.

- `Terminal` / `TerminalBackend` — terminal size, raw mode, write
- `RealTerminalBackend` — FFI-based terminal I/O
- `FfiWrite` — native `write()` syscall via `dart:ffi`, UTF-8 encoding
- `KeyParser` — stdin escape sequence → `LogicalKeyboardKey` mapping
- `RawKeyboard` — keyboard event stream
- `OutputBuffer` — ANSI escape sequence builder and flusher
- `Logger` — leveled logging to stderr

### Rendering Layer

The layout and paint engine. Operates on `RenderObject` trees.

- `RenderObject` — base class with parent/child, layout, paint lifecycle
- `RenderBox` — 2D box model with `Size`, `performLayout()`, `paint()`
- `SingleChildRenderBox` — `RenderObjectWithChildMixin` for single-child
- `StyleCacheMixin` — caches computed styles for performance

### Scheduler Layer

Frame scheduling and binding infrastructure.

- `BindingBase` — initializes service bindings
- `ServicesBinding` — terminal initialization
- `SchedulerBinding` — frame scheduling (`scheduleFrame()`)
- `RendererBinding` — connects render tree to pipeline
- `WidgetsBinding` — connects widget tree to render tree
- `AppBinding` — top-level binding, `runApp()`, `attachRootWidget()`

### Widgets Layer

Declarative UI framework. Users construct widget trees; the framework manages Elements and RenderObjects.

- `Widget` — immutable configuration descriptor
- `Element` — mutable tree node, lifecycle manager
- `StatelessWidget` / `StatefulWidget` — declarative widget base classes
- `RenderObjectWidget` — bridges Widget → RenderObject
- `State` — mutable state holder for StatefulWidget
- `BuildContext` — Element handle exposed to builders
- `InheritedWidget` — dependency injection down the tree

## Dependency Flow

```
Application → widgets/ → scheduler/ → rendering/ → services/ → foundation/
```

Rules:
- Each layer only imports from layers below it
- `foundation/` has zero imports from other layers
- `services/` only imports `foundation/`
- `rendering/` imports `services/` and `foundation/`
- `scheduler/` imports `rendering/`, `services/`, `foundation/`
- `widgets/` imports `scheduler/`, `rendering/`, `services/`, `foundation/`

### Accepted Exceptions

- **`animation/` → `scheduler/`**: `AnimationController` requires `SchedulerBinding` for frame scheduling callbacks (`scheduleFrame()`, `scheduleFrameCallback()`). This is an accepted upward dependency — animation timing fundamentally depends on the frame scheduler.

## Widget → Element → RenderObject Pipeline

### StatelessWidget

```
StatelessWidget.build(context)
       │
       └──→ returns child Widget
                │
                └──→ Element inflates child Widget → recursive
```

### StatefulWidget

```
StatefulWidget.createElement() → StatefulElement
       │
       StatefulElement.state → State
       │
       State.build(context) → returns child Widget
       │
       State.setState() → markNeedsBuild() → rebuild on next frame
```

### RenderObjectWidget

```
RenderObjectWidget.createElement() → RenderObjectElement
RenderObjectWidget.createRenderObject() → RenderObject
RenderObjectWidget.updateRenderObject() → sync properties
       │
       RenderObject.performLayout() → compute Size
       RenderObject.paint(context, offset) → emit drawing commands
```

## Rendering Cycle

```
Widget tree change
       │
  markNeedsBuild() / setState()
       │
  SchedulerBinding.scheduleFrame()
       │
  buildScope() — rebuild dirty Elements
       │
  RenderObject.markNeedsLayout()
       │
  performLayout() — top-down constraint propagation
       │
  RenderObject.markNeedsPaint()
       │
  paint() — emit draw commands to OutputBuffer
       │
  OutputBuffer.flush() → FfiWrite.writeString()
       │
  Terminal stdout (ANSI escape sequences)
```

## Focus Management

```
FocusNode tree
       │
  FocusTraversalPolicy (Tab order)
       │
  FocusScopeNode — groups focus nodes (per Route/Dialog)
       │
  KeyEvent dispatch:
  RawKeyboard → FocusManager → focused FocusNode → onKey callback
```

## Navigation

```
Navigator (Overlay-based)
       │
  Route → ModalRoute → buildPage() / buildTransitions()
       │
  Overlay → Stack of OverlayEntry
       │
  push() / pop() → OverlayEntry insert/remove → rebuild
```

## Terminal Rendering

```
paint() calls on RenderObject tree
       │
  PaintingContext → OutputBuffer operations:
    writeString(x, y, text, style)
    fillRect(x, y, width, height, char, style)
    drawBorder(x, y, width, height, border, style)
       │
  OutputBuffer.flush()
       │
  Diff-based update: only changed cells written
       │
  FfiWrite.writeString(fd, utf8EncodedAnsi)
       │
  Terminal (ANSI escape sequences rendered)
```

## Adding a New Feature

See the 8-step checklist in [AGENTS.md](../AGENTS.md) Section 8.
