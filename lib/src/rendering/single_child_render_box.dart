import '../foundation.dart';
import 'render_box.dart';
import 'render_object.dart';

/// A render box that manages a single child with customizable layout and
/// painting behavior.
abstract class SingleChildRenderBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;

    if (child != null) {
      final childConstraints = getConstraintsForChild(boxConstraints);
      child!.layout(childConstraints);
      size = computeSizeFromChild(boxConstraints, child!.size!);
    } else {
      size = computeSizeWithoutChild(boxConstraints);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final childOffset = computeChildOffset(offset, child!.size!);
      context.paintChild(child!, childOffset);
    }
  }

  /// Returns the constraints to apply to the child during layout.
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints;

  /// Computes this render box's size based on the child's [childSize].
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) =>
      childSize;

  /// Computes this render box's size when it has no child.
  Size computeSizeWithoutChild(BoxConstraints constraints) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  /// Computes the offset at which to paint the child.
  Offset computeChildOffset(Offset parentOffset, Size childSize) =>
      parentOffset;
}
