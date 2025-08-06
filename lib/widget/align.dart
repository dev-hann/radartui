import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/alignment.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/single_child_render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Align extends SingleChildRenderObjectWidget {
  const Align({
    super.key,
    required super.child,
    this.alignment = Alignment.center,
  });

  final Alignment alignment;

  @override
  RenderObject createRenderObject() {
    return RenderAlign(alignment: alignment, child: child);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderAlign).alignment = alignment;
  }
}

class RenderAlign extends RenderObject {
  RenderAlign({required this.alignment, required super.child});

  Alignment alignment;

  @override
  void paint(Canvas canvas) {
    if (child == null) return;

    final childRenderObject = child!;
    final childHeight = childRenderObject.preferredHeight(layoutRect.width);

    // 위치 계산
    int yOffset;
    switch (alignment) {
      case Alignment.topLeft:
      case Alignment.topCenter:
      case Alignment.topRight:
        yOffset = 0;
        break;
      case Alignment.centerLeft:
      case Alignment.center:
      case Alignment.centerRight:
        yOffset = ((layoutRect.height - childHeight) / 2).round();
        break;
      case Alignment.bottomLeft:
      case Alignment.bottomCenter:
      case Alignment.bottomRight:
        yOffset = layoutRect.height - childHeight;
        break;
      default:
        yOffset = 0;
        break;
    }

    final childRect = Rect(
      x: switch (alignment) {
        Alignment.topLeft ||
        Alignment.centerLeft ||
        Alignment.bottomLeft => layoutRect.x,
        Alignment.topCenter ||
        Alignment.center ||
        Alignment.bottomCenter => layoutRect.x + (layoutRect.width ~/ 2),
        Alignment.topRight ||
        Alignment.centerRight ||
        Alignment.bottomRight => layoutRect.x + layoutRect.width - childRenderObject.preferredWidth(childHeight),
      },
      y: layoutRect.y + yOffset,
      width: layoutRect.width,
      height: childHeight,
    );

    childRenderObject.layout(childRect);
    childRenderObject.paint(canvas);
  }

  @override
  int preferredHeight(int width) {
    if (child == null) return 0;
    return child!.preferredHeight(width);
  }

  @override
  int preferredWidth(int height) {
    if (child == null) return 0;
    return child!.preferredWidth(height);
  }
}