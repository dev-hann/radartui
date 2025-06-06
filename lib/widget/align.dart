import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/alignment.dart';
import 'package:radartui/widget/widget.dart';

class Align extends WidgetOld {
  Align({required this.alignment, required this.child});

  final Alignment alignment;
  final WidgetOld child;

  @override
  void render(Canvas canvas, Rect rect) {
    final childHeight = child.preferredHeight(rect.width);

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
        yOffset = ((rect.height - childHeight) / 2).floor();
        break;
      case Alignment.bottomLeft:
      case Alignment.bottomCenter:
      case Alignment.bottomRight:
        yOffset = rect.height - childHeight;
        break;
    }

    final childRect = Rect(
      x: switch (alignment) {
        Alignment.topLeft ||
        Alignment.centerLeft ||
        Alignment.bottomLeft => rect.x,
        Alignment.topCenter ||
        Alignment.center ||
        Alignment.bottomCenter => rect.x + (rect.width ~/ 2),
        Alignment.topRight ||
        Alignment.centerRight ||
        Alignment.bottomRight => rect.x + rect.width - rect.width,
      },
      y: rect.y + yOffset,
      width: rect.width,
      height: childHeight,
    );

    child.render(canvas, childRect);
  }

  @override
  int preferredHeight(int width) {
    return child.preferredHeight(width);
  }

  @override
  bool shouldUpdate(covariant Align oldWidget) {
    return alignment != oldWidget.alignment ||
        child.shouldUpdate(oldWidget.child);
  }
}
