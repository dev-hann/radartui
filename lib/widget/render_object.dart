import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';

abstract class RenderObject {
  late Rect layoutRect;

  void layout(Rect rect) {
    layoutRect = rect;
  }

  void paint(Canvas canvas);
}
