import '../../../radartui.dart';

class Padding extends SingleChildRenderObjectWidget {
  const Padding({super.key, required this.padding, required super.child});
  final EdgeInsets padding;
  @override
  RenderPadding createRenderObject(BuildContext context) =>
      RenderPadding(padding: padding);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderPadding).padding = padding;
  }
}

class RenderPadding extends SingleChildRenderBox {
  RenderPadding({required this.padding});
  EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.deflate(padding);

  @override
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) {
    return Size(
      childSize.width + padding.left + padding.right,
      childSize.height + padding.top + padding.bottom,
    );
  }

  @override
  Size computeSizeWithoutChild(BoxConstraints constraints) =>
      Size(padding.left + padding.right, padding.top + padding.bottom);

  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) =>
      parentOffset + Offset(padding.left, padding.top);
}
