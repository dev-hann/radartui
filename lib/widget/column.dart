import 'package:radartui/radartui.dart';

class Column extends Widget {
  Column({required this.children});

  final List<Widget> children;

  @override
  void render(Canvas canvas, Rect rect) {
    final width = rect.width;
    int currentY = rect.y;

    for (final child in children) {
      final childHeight = child.preferredHeight(width);
      final childRect = Rect(
        x: rect.x,
        y: currentY,
        width: width,
        height: childHeight,
      );
      child.render(canvas, childRect);
      currentY += childHeight;
    }
  }

  @override
  int preferredHeight(int width) {
    return children.fold(0, (sum, child) => sum + child.preferredHeight(width));
  }
}
