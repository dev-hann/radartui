import '../../../radartui.dart';

class SizedBox extends SingleChildRenderObjectWidget {
  final int width;
  final int height;

  const SizedBox({this.width = 0, this.height = 0, super.child});
  const SizedBox.shrink({super.child})
      : width = 0,
        height = 0;
  const SizedBox.square({required int dimension, super.child})
      : width = dimension,
        height = dimension;


  @override
  RenderSizedBox createRenderObject(BuildContext context) =>
      RenderSizedBox(width, height);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final sizedBox = renderObject as RenderSizedBox;
    sizedBox.width = width;
    sizedBox.height = height;
  }
}

class RenderSizedBox extends RenderBox
    with ContainerRenderObjectMixin<RenderObject, ParentData> {
  int width;
  int height;

  RenderSizedBox(this.width, this.height);

  @override
  void performLayout(Constraints constraints) {
    final boxSize = Size(width, height);
    size = boxSize;

    if (children.isNotEmpty) {
      final child = children.first;
      child.layout(BoxConstraints.tight(boxSize));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (children.isNotEmpty) {
      context.paintChild(children.first, offset);
    }
  }
}
