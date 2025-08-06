
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';

/// Represents a 2D rectangle with an origin (offset) and a size.
class Rect {
  final Offset offset;
  final Size size;

  const Rect.fromLTWH(int left, int top, int width, int height)
      : offset = Offset(left, top),
        size = Size(width, height);

  // TODO: Implement other constructors (e.g., fromCircle, fromPoints)
  // TODO: Implement getters for top, left, right, bottom
  // TODO: Implement methods for intersection, contains, etc.
}
