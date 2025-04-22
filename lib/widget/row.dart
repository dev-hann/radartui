import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/widget.dart';

class Row extends Widget {
  Row({required this.children});

  final List<Widget> children;

  @override
  void render(Canvas canvas, Rect rect) {
    final childCount = children.length;
    final childWidth = (rect.width / childCount).floor();

    for (int i = 0; i < childCount; i++) {
      final child = children[i];
      final childRect = Rect(
        x: rect.x + i * childWidth,
        y: rect.y,
        width: childWidth,
        height: rect.height,
      );
      child.render(canvas, childRect);
    }
  }

  @override
  int preferredHeight(int width) {
    final childWidth = (width / children.length).floor();
    int maxHeight = 0;
    for (final child in children) {
      final h = child.preferredHeight(childWidth);
      if (h > maxHeight) maxHeight = h;
    }
    return maxHeight;
  }
}
