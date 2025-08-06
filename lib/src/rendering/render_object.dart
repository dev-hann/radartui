import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/services/output_buffer.dart';

class PaintingContext {
  final OutputBuffer buffer;
  PaintingContext(this.buffer);
  void paintChild(RenderObject child, Offset offset) => child.paint(this, offset);
}

class ParentData {}

abstract class RenderObject {
  RenderObject? _parent;
  set parent(RenderObject? value) => _parent = value; // Added setter
  ParentData? parentData;
  Size? size;
  bool _needsLayout = true;

  void markNeedsLayout() => _needsLayout = true;

  void layout(Constraints constraints) {
    if (!_needsLayout) return;
    performLayout(constraints);
    _needsLayout = false;
  }

  void performLayout(Constraints constraints);
  void paint(PaintingContext context, Offset offset);
}

abstract class Constraints {
  const Constraints(); // Added const constructor
}
