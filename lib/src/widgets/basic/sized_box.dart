import 'package:radartui/radartui.dart';

class SizedBox extends RenderObjectWidget {
  final int width;
  final int height;

  const SizedBox({this.width = 0, this.height = 0});
  const SizedBox.shrink() : width = 0, height = 0;
  const SizedBox.square({required int dimension})
    : width = dimension,
      height = dimension;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

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

class RenderSizedBox extends RenderBox {
  int width;
  int height;

  RenderSizedBox(this.width, this.height);

  @override
  void performLayout(Constraints constraints) {
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // SizedBox doesn't paint anything
  }
}
