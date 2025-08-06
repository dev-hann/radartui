import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/axis.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/multi_child_render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Flex extends MultiChildRenderObjectWidget {
  const Flex({
    super.key,
    super.children,
    this.direction = Axis.vertical,
  });

  final Axis direction;

  @override
  RenderObject createRenderObject() {
    return RenderFlex(direction: direction, children: children);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderFlex).direction = direction;
  }

  @override
  void render(Canvas canvas, Rect rect) {
    // This should be handled by the RenderObject
  }

  @override
  int preferredHeight(int width) {
    // This should be handled by the RenderObject
    return 0;
  }

  @override
  int preferredWidth(int height) {
    // This should be handled by the RenderObject
    return 0;
  }
}

class RenderFlex extends RenderObject {
  RenderFlex({required this.direction, required this.children});

  Axis direction;
  late List<Widget> children;

  @override
  void paint(Canvas canvas) {
    final mainSize = direction == Axis.vertical ? layoutRect.height : layoutRect.width;
    final perChildSize = (mainSize / children.length).floor();
    int currentOffset = direction == Axis.vertical ? layoutRect.y : layoutRect.x;

    for (final child in children) {
      final childRect = direction == Axis.vertical
          ? Rect(
              x: layoutRect.x,
              y: currentOffset,
              width: layoutRect.width,
              height: perChildSize,
            )
          : Rect(
              x: currentOffset,
              y: layoutRect.y,
              width: perChildSize,
              height: layoutRect.height,
            );

      child.render(canvas, childRect);
      currentOffset += perChildSize;
    }
  }

  @override
  int preferredHeight(int width) {
    if (direction == Axis.horizontal) {
      return children.map((child) => child.preferredHeight(width)).fold(0, (a, b) => a > b ? a : b);
    } else {
      return children.map((child) => child.preferredHeight(width)).fold(0, (a, b) => a + b);
    }
  }

  @override
  int preferredWidth(int height) {
    if (direction == Axis.vertical) {
      return children.map((child) => child.preferredWidth(height)).fold(0, (a, b) => a > b ? a : b);
    } else {
      return children.map((child) => child.preferredWidth(height)).fold(0, (a, b) => a + b);
    }
  }
}