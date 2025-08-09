import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

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

class RenderPadding extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ParentData> {
  EdgeInsets padding;
  RenderPadding({required this.padding});
  @override
  void performLayout(Constraints constraints) {
    if (children.isNotEmpty) {
      final child = children.first;
      child.layout((constraints as BoxConstraints).deflate(padding));
      size = Size(
        child.size!.width + padding.left + padding.right,
        child.size!.height + padding.top + padding.bottom,
      );
    } else {
      size = Size(padding.left + padding.right, padding.top + padding.bottom);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (children.isNotEmpty) {
      context.paintChild(
        children.first,
        offset + Offset(padding.left, padding.top),
      );
    }
  }
}
