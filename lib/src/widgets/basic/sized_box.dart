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
  RenderSizedBox(int boxWidth, int boxHeight)
      : _boxWidth = boxWidth,
        _boxHeight = boxHeight;

  int _boxWidth;

  /// The fixed width.
  int get boxWidth => _boxWidth;

  /// Sets the width and marks the render object as needing layout.
  set boxWidth(int v) {
    if (_boxWidth == v) return;
    _boxWidth = v;
    markNeedsLayout();
  }

  int _boxHeight;

  /// The fixed height.
  int get boxHeight => _boxHeight;

  /// Sets the height and marks the render object as needing layout.
  set boxHeight(int v) {
    if (_boxHeight == v) return;
    _boxHeight = v;
    markNeedsLayout();
  }

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
