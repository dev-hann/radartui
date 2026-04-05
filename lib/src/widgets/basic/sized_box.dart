import '../../../radartui.dart';

/// A widget with a fixed [width] and [height].
///
/// Use [SizedBox.shrink] for a zero-sized box or [SizedBox.square] for equal
/// dimensions. If given a child, constrains it to the specified size.
class SizedBox extends SingleChildRenderObjectWidget {
  const SizedBox({super.key, this.width = 0, this.height = 0, super.child});
  const SizedBox.shrink({super.key, super.child})
      : width = 0,
        height = 0;
  const SizedBox.square({super.key, required int dimension, super.child})
      : width = dimension,
        height = dimension;
  final int width;
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

class RenderSizedBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderSizedBox(this.boxWidth, this.boxHeight);
  int boxWidth;
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
