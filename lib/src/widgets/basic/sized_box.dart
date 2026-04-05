import '../../../radartui.dart';

/// A widget with a fixed [width] and [height].
///
/// Use [SizedBox.shrink] for a zero-sized box or [SizedBox.square] for equal
/// dimensions. If given a child, constrains it to the specified size.
class SizedBox extends SingleChildRenderObjectWidget {
  /// Creates a [SizedBox] with the given [width] and [height].
  const SizedBox({super.key, this.width = 0, this.height = 0, super.child});

  /// Creates a zero-sized box.
  const SizedBox.shrink({super.key, super.child})
      : width = 0,
        height = 0;

  /// Creates a box with equal [width] and [height] set to [dimension].
  const SizedBox.square({super.key, required int dimension, super.child})
      : width = dimension,
        height = dimension;

  /// The fixed width in terminal cells.
  final int width;

  /// The fixed height in terminal cells.
  final int height;

  @override
  RenderSizedBox createRenderObject(BuildContext context) =>
      RenderSizedBox(width, height);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final sizedBox = renderObject as RenderSizedBox;
    sizedBox.boxWidth = width;
    sizedBox.boxHeight = height;
  }
}

/// The render object for [SizedBox], which constrains its child to a fixed size.
class RenderSizedBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  /// Creates a [RenderSizedBox] with the given dimensions.
  RenderSizedBox(this.boxWidth, this.boxHeight);

  /// The fixed width.
  int boxWidth;

  /// The fixed height.
  int boxHeight;

  @override
  void performLayout(Constraints constraints) {
    final boxSize = Size(boxWidth, boxHeight);
    size = boxSize;

    if (child != null) {
      child!.layout(BoxConstraints.tight(boxSize));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
