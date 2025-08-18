import '../../foundation/edge_insets.dart';
import '../../foundation/offset.dart';
import '../../foundation/size.dart';
import '../../rendering/render_box.dart';
import '../../rendering/render_object.dart';
import '../../rendering/single_child_render_box.dart';
import '../framework.dart';

class Padding extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;
  const Padding({required this.padding, required super.child});
  @override
  RenderPadding createRenderObject(BuildContext context) =>
      RenderPadding(padding: padding);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderPadding).padding = padding;
  }
}

class RenderPadding extends SingleChildRenderBox {
  EdgeInsets padding;
  RenderPadding({required this.padding});

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
