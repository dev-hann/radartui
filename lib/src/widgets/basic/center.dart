import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

class Center extends SingleChildRenderObjectWidget {
  const Center({required Widget child}) : super(child: child);

  @override
  RenderCenter createRenderObject(BuildContext context) => RenderCenter();
}

class RenderCenter extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ParentData> {
  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    if (children.isNotEmpty) {
      final child = children.first;
      child.layout(constraints);
      size = Size(boxConstraints.maxWidth, boxConstraints.maxHeight);
    } else {
      size = Size(boxConstraints.maxWidth, boxConstraints.maxHeight);
    }
    AppLogger.log('RenderCenter.performLayout: size=\$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (children.isNotEmpty) {
      final child = children.first;
      final childOffset = Offset(
        offset.x + (size!.width - child.size!.width) ~/ 2,
        offset.y + (size!.height - child.size!.height) ~/ 2,
      );
      context.paintChild(child, childOffset);
    }
  }
}
