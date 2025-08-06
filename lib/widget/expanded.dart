import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/single_child_render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Expanded extends SingleChildRenderObjectWidget {
  const Expanded({
    super.key,
    required super.child,
    this.flex = 1,
  });

  final int flex;

  @override
  RenderObject createRenderObject() {
    return RenderExpanded(flex: flex, child: child);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderExpanded).flex = flex;
  }
}

class RenderExpanded extends RenderObject {
  RenderExpanded({required this.flex, required this.child});

  int flex;
  late Widget child;

  @override
  void paint(Canvas canvas) {
    child.render(canvas, layoutRect);
  }

  @override
  int preferredHeight(int width) {
    return child.preferredHeight(width);
  }
}