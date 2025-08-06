
import 'package:radartui/src/rendering/render_object.dart';

/// A RenderObject that uses a 2D Cartesian coordinate system.
///
/// This is the most common base class for render objects.
abstract class RenderBox extends RenderObject {
  // RenderBox introduces a simpler layout model based on BoxConstraints.
  @override
  void layout(Constraints constraints) {
    // TODO: Implement the layout logic for a box.
    // This usually involves calling a `performLayout` method that subclasses can override.
  }
}

/// Constraints for a RenderBox, including min/max width and height.
class BoxConstraints extends Constraints {
  final int minWidth, maxWidth, minHeight, maxHeight;

  const BoxConstraints({
    this.minWidth = 0,
    this.maxWidth = 9999, // A large number representing infinity
    this.minHeight = 0,
    this.maxHeight = 9999,
  });

  // TODO: Add utility methods (e.g., enforce, loosen, tighten).
}
