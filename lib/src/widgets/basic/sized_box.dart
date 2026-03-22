import '../../../radartui.dart';

class SizedBox extends SingleChildRenderObjectWidget {
  final int width;
  final int height;

  const SizedBox({super.key, this.width = 0, this.height = 0, super.child});
  const SizedBox.shrink({super.key, super.child})
      : width = 0,
        height = 0;
  const SizedBox.square({super.key, required int dimension, super.child})
      : width = dimension,
        height = dimension;

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
  int boxWidth;
  int boxHeight;

  RenderSizedBox(this.boxWidth, this.boxHeight);

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
