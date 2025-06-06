import 'package:radartui/radartui.dart';

class Rect {
  Rect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final int x;
  final int y;
  final int width;
  final int height;
  factory Rect.fromCanvas(Canvas canvas) {
    return Rect(
      x: 0,
      y: 0,
      width: canvas.windowSize.width,
      height: canvas.windowSize.height,
    );
  }
}
