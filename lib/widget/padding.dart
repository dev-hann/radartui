import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/edge_insets.dart';
import 'package:radartui/widget/widget.dart';

class Padding extends Widget {
  Padding({required this.padding, required this.child});
  final EdgeInsets padding;
  final Widget child;

  @override
  void render(Canvas canvas, Rect rect) {
    final paddedRect = Rect(
      x: rect.x + padding.left,
      y: rect.y + padding.top,
      width: rect.width - padding.left - padding.right,
      height: rect.height - padding.top - padding.bottom,
    );
    child.render(canvas, paddedRect);
  }

  @override
  int preferredHeight(int width) {
    final innerWidth = width - padding.left - padding.right;
    return child.preferredHeight(innerWidth) + padding.top + padding.bottom;
  }

  @override
  bool shouldUpdate(covariant Padding oldWidget) {
    return padding != oldWidget.padding || child.shouldUpdate(oldWidget.child);
  }
}
