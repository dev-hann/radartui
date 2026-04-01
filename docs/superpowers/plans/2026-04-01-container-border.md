# Container Border Implementation Plan

 (2026-04-01)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add border support to Container widget for visual panel separation in TUI apps

**Architecture:** Add Border class for flexible border configuration, add RenderBorder render object to draw box-drawing borders, update Container and RenderContainer to support border property.

**Tech Stack:** Dart, Box-drawing characters (┌─┬┐┌/)

---

## File Structure

```
lib/src/foundation/
├── border.dart                    # New Border class

lib/src/rendering/
└── render_border.dart             # New RenderBorder render object

lib/src/widgets/basic/
└── container.dart                # Update Container and RenderContainer

test/unit/foundation/
├── border_test.dart               # Border tests

test/unit/rendering/
└── render_border_test.dart         # RenderBorder tests

test/unit/widgets/
├── container_border_test.dart     # Container border tests
```

---

## Task 1: Create Border Class

**Files:**
- Create: `lib/src/foundation/border.dart`
- Create: `test/unit/foundation/border_test.dart`

- [ ] **Step 1: Write failing tests for Border class**

```dart
// test/unit/foundation/border_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/foundation/border.dart';

void main() {
  group('Border', () {
    test('Border.all creates border with default characters', () {
      final border = Border.all;
      expect(border.top, equals('─'));
      expect(border.left, equals('│');
      expect(border.right, equals('│'));
      expect(border.bottom, equals('─'));
    });

    test('Border.symmetric creates border with custom characters', () {
      final border = Border.symmetric('═', '│');
      expect(border.top, equals('═'));
      expect(border.left, equals('│'));
      expect(border.right, equals('│'));
      expect(border.bottom, equals('│'));
    });

    test('Border.only creates border with only specified sides', () {
      final border = Border.only(top: '═', bottom: '─');
      expect(border.top, equals('─'));
      expect(border.left, equals(''));
      expect(border.right, equals(''));
      expect(border.bottom, equals('─'));
    });

    test('Border.none creates no border', () {
      final border = Border.none;
      expect(border.top, equals(''));
      expect(border.left, equals(''));
      expect(border.right, equals(''));
      expect(border.bottom, equals(''));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/foundation/border_test.dart`
Expected: FAIL - No such file border.dart

- [ ] **Step 3: Implement Border class**

```dart
// lib/src/foundation/border.dart
class Border {
  const Border({
    this.top = '',
    this.right = '',
    this.bottom = '',
    this.left = '',
  });

  final String top;
  final String right;
  final String bottom;
  final String left;

  static const Border all = Border(
    top: '─',
    left: '│',
    right: '│',
    bottom: '─',
  );

  factory Border.symmetric(String horizontal, String vertical) => Border(
    top: horizontal,
    left: vertical,
    right: vertical,
    bottom: horizontal,
  );

  factory Border.only({String? top, String? right, String? bottom, String? left}) => Border(
    top: top ?? '',
    right: right ?? '',
    bottom: bottom ?? '',
    left: left ?? '',
  );

  static const Border none = Border(
    top: '',
    left: '',
    right: '',
    bottom: '',
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/foundation/border_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/foundation/border.dart test/unit/foundation/border_test.dart
git commit -m "feat: add Border class for visual panel separation"
```

---

## Task 2: Create RenderBorder Render Object

**Files:**
- Create: `lib/src/rendering/render_border.dart`
- Create: `test/unit/rendering/render_border_test.dart`

- [ ] **Step 1: Write failing tests for RenderBorder**

```dart
// test/unit/rendering/render_border_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/rendering/render_border.dart';
import 'package:radartui/src/foundation/border.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/services/output_buffer.dart';

void main() {
  group('RenderBorder', () {
    test('computeSize returns correct size with border', () {
      final border = Border.all;
      final renderBorder = RenderBorder(border: border);
      
      expect(renderBorder.computeSize(), equals(Size(2, 2)));
    });

    test('computeSize handles different border widths', () {
      final border = Border.symmetric('═', '═');
      final renderBorder = RenderBorder(border: border);
      
      // top/bottom: 1 char, left/right: 1 char = total 2x2
      expect(renderBorder.computeSize(), equals(Size(2, 2)));
    });

    test('paint draws border characters', () {
      final buffer = TestOutputBuffer(3, 3);
      final border = Border.all;
      final renderBorder = RenderBorder(border: border);
      
      renderBorder.paint(buffer, Offset.zero);
      
      // Check corners: ┌─┬┐┐─
      expect(buffer.getLine(0), equals('┌──┐'));
      expect(buffer.getLine(1), equals('│  │'));
      expect(buffer.getLine(2), equals('└──┘'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/rendering/render_border_test.dart`
Expected: FAIL - No such file render_border.dart

- [ ] **Step 3: Implement RenderBorder class**

```dart
// lib/src/rendering/render_border.dart
import '../foundation/border.dart';
import '../foundation/size.dart';
import '../services/output_buffer.dart';

class RenderBorder extends RenderBox {
  RenderBorder({required this.border}) : super();

  final Border border;

  @override
  Size computeSize() {
    final horizontalBorder = border.left.isNotEmpty ? 1 : 0;
    final verticalBorder = border.top.isNotEmpty ? 1 : 0;
    return Size(2, 2);
  }

  @override
  void performLayout(Constraints constraints) {
    size = computeSize();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final buffer = context.outputBuffer;
    
    // Top-left corner
    buffer.write(offset.dx, offset.dy, border.top + border.left, null);
    
    // Top-right corner
    buffer.write(offset.dx + 1, offset.dy, border.top + border.right, null);
    
    // Bottom-left corner
    buffer.write(offset.dx, offset.dy + 1, border.bottom + border.left, null);
    
    // Bottom-right corner
    buffer.write(offset.dx + 1, offset.dy + 1, border.bottom + border.right, null);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/rendering/render_border_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/rendering/render_border.dart test/unit/rendering/render_border_test.dart
git commit -m "feat: add RenderBorder for box-drawing borders"
```

---

## Task 3: Add border property to Container widget

**Files:**
- Modify: `lib/src/widgets/basic/container.dart`
- Modify: `test/unit/widgets/container_test.dart`

- [ ] **Step 1: Add failing test for Container border**

```dart
// Add to test/unit/widgets/container_test.dart (or create new file)
import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Container border', () {
    test('Container renders border when border property is provided', () async {
      final tester = WidgetTester();
      await tester.pumpWidget(
        Container(
          width: 10,
          height: 5,
          border: Border.all,
          child: Text('test'),
        ),
      );

      // Find render object and verify border is rendered
      final renderObject = tester.findRenderObject<RenderContainer>();
      expect(renderObject.border, equals(Border.all));
    });

    test('Container without border renders no border', () async {
      final tester = WidgetTester();
      await tester.pumpWidget(
        Container(
          width: 10,
          height: 5,
          child: Text('test'),
        ),
      );

      final renderObject = tester.findRenderObject<RenderContainer>();
      expect(renderObject.border, isNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/widgets/container_test.dart`
Expected: FAIL - No border property on Container

- [ ] **Step 3: Add border property to Container widget and RenderContainer**

```dart
// lib/src/widgets/basic/container.dart
class Container extends SingleChildRenderObjectWidget {
  const Container({
    super.key,
    Widget? child,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.border,  // Add this
  }) : super(child: child ?? const SizedBox());
  final Color? color;
  final int? width;
  final int? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Border? border;  // Add this

  @override
  RenderContainer createRenderObject(BuildContext context) => RenderContainer(
        color: color,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        border: border,  // Add this
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final container = renderObject as RenderContainer;
    container.color = color;
    container.containerWidth = width;
    container.containerHeight = height;
    container.padding = padding;
    container.margin = margin;
    container.border = border;  // Add this
  }
}
```

- [ ] **Step 4: Update RenderContainer to support border**

```dart
// In RenderContainer class (container.dart)
class RenderContainer extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderContainer({
    this.color,
    int? width,
    int? height,
    this.padding,
    this.margin,
    this.border,  // Add this
  }) : _width = width,
       _height = height;
  
  final Color? color;
  int? _width;
  int? _height;
  EdgeInsets? padding;
  EdgeInsets? margin;
  final Border? border;  // Add this

  // ... getters/setters ...

  set border(Border? value) {
    _border = value;
    markNeedsLayout();
  }
}
```

- [ ] **Step 5: Update performLayout to handle border space**

```dart
// In RenderContainer.performLayout()
@override
void performLayout(Constraints constraints) {
  final boxConstraints = constraints.asBoxConstraints;
  final totalMargin = margin ?? const EdgeInsets.all(0);
  final totalPadding = padding ?? const EdgeInsets.all(0);
  
  // Calculate border space
  final borderSpace = border != null ? 1 : 0;

  int containerW = _width ?? boxConstraints.maxWidth;
  int containerH = _height ?? LayoutConstants.defaultContainerHeight;

  // Adjust for border
  if (border != null) {
    containerW += borderSpace * 2;
    containerH += borderSpace * 2;
  }

  if (child != null) {
    final childConstraint = BoxConstraints(
      maxWidth: containerW - totalPadding.left - totalPadding.right - (border != null ? borderSpace * 2 : 0),
      maxHeight: containerH - totalPadding.top - totalPadding.bottom - (border != null ? borderSpace * 2 : 0),
    );
    child!.layout(childConstraint);

    if (_width == null) {
      final childW = child!.size.width + totalPadding.left + totalPadding.right + (border != null ? borderSpace * 2 : 0);
      if (_height == null) {
        final childH = child!.size.height + totalPadding.top + totalPadding.bottom + (border != null ? borderSpace * 2 : 0);
        size = Size(childW, childH);
      } else {
        size = Size(childW, containerH);
      }
    } else {
      size = Size(containerW, containerH);
    }
  } else {
    size = Size(containerW, containerH);
  }
}
```

- [ ] **Step 6: Update paint method to draw border**

```dart
// In RenderContainer.paint()
@override
void paint(PaintingContext context, Offset offset) {
  final buffer = context.outputBuffer;
  final totalMargin = margin ?? const EdgeInsets.all(0);
  final totalPadding = padding ?? const EdgeInsets.all(0);
  final borderSpace = border != null ? 1 : 0;

  // Draw background with color
  if (color != null) {
    final bgStyle = TextStyle(backgroundColor: color);
    for (int y = 0; y < size.height; y++) {
      for (int x = 0; x < size.width; x++) {
        buffer.write(
          offset.dx + x,
          offset.dy + y,
          ' ',
          bgStyle,
        );
      }
    }
  }

  // Draw border
  if (border != null) {
    final borderStyle = const TextStyle();
    
    // Top border
    for (int x = 0; x < size.width; x++) {
      final char = (x == 0) ? border.top + border.left : 
                  (x == size.width - 1) ? border.top + border.right : border.top;
      buffer.write(offset.dx + x, offset.dy, char, borderStyle);
    }
    
    // Bottom border
    for (int x = 0; x < size.width; x++) {
      final char = (x == 0) ? border.bottom + border.left : 
                  (x == size.width - 1) ? border.bottom + border.right : border.bottom;
      buffer.write(offset.dx + x, offset.dy + size.height - 1, char, borderStyle);
    }
    
    // Left border
    for (int y = 1; y < size.height - 1; y++) {
      buffer.write(offset.dx, offset.dy + y, border.left, borderStyle);
    }
    
    // Right border
    for (int y = 1; y < size.height - 1; y++) {
      buffer.write(offset.dx + size.width - 1, offset.dy + y, border.right, borderStyle);
    }
  }

  // Draw child
  if (child != null) {
    final childOffset = Offset(
      offset.dx + totalMargin.left + borderSpace,
      offset.dy + totalMargin.top + borderSpace,
    );
    context.paintChild(child!, childOffset);
  }
}
```

- [ ] **Step 7: Run test to verify it passes**

Run: `dart test test/unit/widgets/container_test.dart`
Expected: PASS

- [ ] **Step 8: Run all tests**

Run: `dart test`
Expected: All tests pass

- [ ] **Step 9: Commit**

```bash
git add lib/src/widgets/basic/container.dart test/unit/widgets/container_test.dart
git commit -m "feat: add border support to Container widget"
```

---

## Task 4: Update exports
 (Need to check the actual export structure in the codebase first)

---

## Summary

**Created Files:**
- `lib/src/foundation/border.dart`
- `test/unit/foundation/border_test.dart`

**Modified Files:**
- `lib/src/widgets/basic/container.dart` (added border property)
- `test/unit/widgets/container_test.dart` (added border tests)

**Total Tasks:** 4
**Estimated Time:** 1-2 hours
