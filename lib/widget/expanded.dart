import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/widget.dart';

class Expanded extends SingleChildWidget {
  Expanded({required super.child, this.flex = 1});
  final int flex;

  @override
  void render(Canvas canvas, Rect rect) {
    child.render(canvas, rect);
  }

  @override
  int preferredHeight(int width) {
    return child.preferredHeight(width); // 위임
  }
}
