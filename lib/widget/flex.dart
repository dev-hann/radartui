import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/axis.dart';
import 'package:radartui/widget/expanded.dart';
import 'package:radartui/widget/widget.dart';

class Flex extends MultiChildWidget {
  Flex({required this.direction, required super.children});

  final Axis direction;

  @override
  void render(Canvas canvas, Rect rect) {
    final totalFlex = children.fold<int>(
      0,
      (sum, child) => child is Expanded ? sum + child.flex : sum,
    );

    int currentX = rect.x;
    int currentY = rect.y;

    for (final child in children) {
      final actualChild = child is Expanded ? child.child : child;

      final int size =
          (child is Expanded && totalFlex > 0)
              ? (direction == Axis.horizontal
                  ? (rect.width * child.flex ~/ totalFlex)
                  : (rect.height * child.flex ~/ totalFlex))
              : (direction == Axis.horizontal
                  ? rect.width ~/ children.length
                  : rect.height ~/ children.length);

      final childRect =
          direction == Axis.horizontal
              ? Rect(x: currentX, y: rect.y, width: size, height: rect.height)
              : Rect(x: rect.x, y: currentY, width: rect.width, height: size);

      actualChild.render(canvas, childRect);

      if (direction == Axis.horizontal) {
        currentX += size;
      } else {
        currentY += size;
      }
    }
  }

  @override
  int preferredHeight(int width) {
    if (direction == Axis.horizontal) {
      return children
          .map((child) {
            final actual = child is Expanded ? child.child : child;
            return actual.preferredHeight(width);
          })
          .fold(0, (a, b) => a > b ? a : b);
    } else {
      return children
          .map((child) {
            final actual = child is Expanded ? child.child : child;
            return actual.preferredHeight(width);
          })
          .fold(0, (a, b) => a + b);
    }
  }

  @override
  bool shouldUpdate(covariant Flex oldWidget) {
    if (children.length != oldWidget.children.length) return true;
    for (int i = 0; i < children.length; i++) {
      if (children[i].runtimeType != oldWidget.children[i].runtimeType ||
          children[i].key != oldWidget.children[i].key ||
          children[i].shouldUpdate(oldWidget.children[i])) {
        return true;
      }
    }
    return false;
  }
}
