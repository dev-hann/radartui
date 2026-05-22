# Roadmap

## Final Goal

Flutter-parity TUI framework for Dart. Build terminal UIs with declarative widgets, state management, diff-based rendering, and a rich widget library matching Flutter's architecture.

## Feature Matrix

| ID | Feature | Status | Version |
|----|---------|--------|---------|
| F01 | Widget / Element / RenderObject architecture | Completed | 0.0.1 |
| F02 | Layout system (Row, Column, Flex, Stack, Positioned, Wrap) | Completed | 0.0.1 |
| F03 | Basic widgets (Text, Container, Button, TextField) | Completed | 0.0.1 |
| F04 | Focus management system | Completed | 0.0.1 |
| F05 | Navigation (Navigator, Route, Dialog) | Completed | 0.0.1 |
| F06 | Theme system (Theme, DefaultTextStyle, MediaQuery) | Completed | 0.0.1 |
| F07 | Animation system (AnimationController, Tween, CurvedAnimation, Curves) | Completed | 0.0.1 |
| F08 | Form widgets (Form, FormField, TextFormField) | Completed | 0.0.1 |
| F09 | Async widgets (StreamBuilder, FutureBuilder) | Completed | 0.0.1 |
| F10 | Keyboard shortcuts (Shortcuts, Actions, ShortcutActionsHandler) | Completed | 0.0.1 |
| F11 | RichText / TextSpan / DefaultTextStyle / Icon | Completed | 0.0.1 |
| F12 | DataTable, TabBar/TabBarView, DropdownButton | Completed | 0.0.1 |
| F13 | PTY golden test framework | Completed | 0.0.1 |
| F14 | Widget testing framework (testWidgets, WidgetTester) | Completed | 0.0.1 |
| F15 | Checkbox, Radio, Toggle, Slider | Completed | 0.0.1 |
| F16 | ListView with virtualization | Completed | 0.0.1 |
| F17 | GridView | Completed | 0.0.1 |
| F18 | TreeView | Completed | 0.0.1 |
| F19 | MenuBar | Completed | 0.0.1 |
| F20 | ExpansionTile | Completed | 0.0.1 |
| F21 | Sparkline | Completed | 0.0.1 |
| F22 | StatusBar, Toast | Completed | 0.0.1 |
| F23 | Progress indicators (Linear, Circular) | Completed | 0.0.1 |
| F24 | SingleChildScrollView | Completed | 0.0.1 |
| F25 | LayoutBuilder, Builder | Completed | 0.0.1 |
| F26 | Overlay, NavigatorObserver | Completed | 0.0.1 |
| F27 | Card, Divider | Completed | 0.0.1 |
| F28 | Padding, SizedBox, Spacer, Align, Center | Completed | 0.0.1 |
| F29 | Container border support | Completed | 0.0.1 |
| F30 | Key system (GlobalKey, LocalKey, ValueKey) | Planned | - |
| F31 | InheritedWidget optimizations | Planned | - |
| F32 | CustomPainter / CustomPaint | Planned | - |
| F33 | Sliver layout protocol | Planned | - |
| F34 | Mouse events | N/A | Terminal limitation |
| F35 | Gesture / Drag and Drop | N/A | Terminal limitation |

## Milestones

### M1: Core Framework (Completed)
- Widget / Element / RenderObject architecture
- Layout system (Flex, Stack)
- Basic widgets (Text, Container, Button, TextField)
- Focus management
- Rendering pipeline (OutputBuffer, FfiWrite)

### M2: Widget Library v1 (Completed)
- Form widgets
- Checkbox, Radio, Toggle, Slider
- ListView with virtualization
- GridView
- Navigation (Navigator, Route, Dialog)
- Theme system

### M3: Advanced Features (Completed)
- Animation system
- Keyboard shortcuts
- RichText, Icon, DataTable
- TabBar, DropdownButton, MenuBar
- TreeView, ExpansionTile, Sparkline

### M4: Testing & Quality (Completed)
- Widget testing framework
- PTY golden test framework
- 110+ tests passing
- Container border support

### M5: Key System & Polish (Planned)
- GlobalKey, LocalKey, ValueKey
- `super.key` in constructors
- Widget reuse optimization
- InheritedWidget performance

### M6: Advanced Layout (Planned)
- CustomPainter / CustomPaint
- Sliver layout protocol
- ScrollView improvements
- Wrap widget improvements

## Widget Catalog

### Layout
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Row | Full | Completed |
| Column | Full | Completed |
| Flex | Full | Completed |
| Expanded | Full | Completed |
| SizedBox | Full | Completed |
| Padding | Full | Completed |
| Center | Full | Completed |
| Align | Full | Completed |
| Spacer | Full | Completed |
| Stack | Full | Completed |
| Positioned | Full | Completed |
| Wrap | Partial | Completed |
| GridView | Partial | Completed |
| ListView | Partial (basic virtualization) | Completed |
| SingleChildScrollView | Partial | Completed |
| LayoutBuilder | Full | Completed |

### Display
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Text | Full (terminal rendering) | Completed |
| RichText | Partial (TextSpan) | Completed |
| Icon | Adapted (terminal icons) | Completed |
| Container | Partial (no transform) | Completed |
| Card | Adapted (terminal border) | Completed |
| Divider | Full | Completed |
| DataTable | Partial | Completed |
| StatusBar | RadarTUI-specific | Completed |
| Sparkline | RadarTUI-specific | Completed |
| LinearProgressIndicator | Adapted | Completed |
| CircularProgressIndicator | Adapted | Completed |

### Input
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Button | Adapted (keyboard) | Completed |
| TextField | Partial (no selection handle) | Completed |
| Checkbox | Adapted (keyboard) | Completed |
| Radio | Adapted (keyboard) | Completed |
| Toggle | Adapted (keyboard) | Completed |
| Slider | Adapted (keyboard) | Completed |
| DropdownButton | Partial | Completed |
| Form | Partial | Completed |
| FormField | Partial | Completed |
| TextFormField | Partial | Completed |

### Navigation
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Navigator | Partial | Completed |
| Route | Partial | Completed |
| Dialog | Adapted | Completed |
| TabBar | Partial | Completed |
| TabBarView | Partial | Completed |
| TabController | Partial | Completed |
| MenuBar | Adapted | Completed |

### Status & Feedback
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Toast | RadarTUI-specific | Completed |
| LinearProgressIndicator | Adapted | Completed |
| CircularProgressIndicator | Adapted | Completed |

### Utility
| Widget | Flutter Parity | Status |
|--------|---------------|--------|
| Builder | Full | Completed |
| LayoutBuilder | Full | Completed |
| StreamBuilder | Full | Completed |
| FutureBuilder | Full | Completed |
| DefaultTextStyle | Full | Completed |
| MediaQuery | Adapted (terminal size) | Completed |
| Theme | Adapted (ANSI colors) | Completed |
| Shortcuts | Adapted (keyboard only) | Completed |
| Actions | Adapted | Completed |
| ShortcutActionsHandler | Adapted | Completed |
| Focus / FocusScope | Partial | Completed |
| InheritedWidget | Full | Completed |
| Overlay | Partial | Completed |
| TreeView | RadarTUI-specific | Completed |
| ExpansionTile | Partial | Completed |

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `ffi` | ^2.0.0 | Terminal I/O via native `write()` and `isatty()` |
| `collection` | ^1.17.0 | Equality comparisons, data structures |
| `test` | ^1.31.0 | Test framework |
