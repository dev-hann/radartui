import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/edge_insets.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/single_child_render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Padding extends SingleChildRenderObjectWidget {
  const Padding({
    super.key,
    required super.child,
    required this.padding,
  });

  final EdgeInsets padding;

  @override
  RenderObject createRenderObject() {
    return RenderPadding(padding: padding, child: child);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderPadding).padding = padding;
  }
}

class RenderPadding extends RenderObject {
  RenderPadding({required this.padding, required this.child});

  EdgeInsets padding;
  late Widget child;

  @override
  void paint(Canvas canvas) {
    final paddedRect = Rect(
      x: layoutRect.x + padding.left,
      y: layoutRect.y + padding.top,
      width: layoutRect.width - padding.left - padding.right,
      height: layoutRect.height - padding.top - padding.bottom,
    );
    child.render(canvas, paddedRect);
  }

  @override
  int preferredHeight(int width) {
    final innerWidth = width - padding.left - padding.right;
    return child.preferredHeight(innerWidth) + padding.top + padding.bottom;
  }
}