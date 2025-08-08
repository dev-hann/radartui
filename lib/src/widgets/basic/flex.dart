import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

abstract class Flex extends MultiChildRenderObjectWidget {
  final Axis direction;
  const Flex({required super.children, required this.direction});
  @override
  RenderFlex createRenderObject(BuildContext context) =>
      RenderFlex(direction: direction);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderFlex).direction = direction;
  }
}

class RenderFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, FlexParentData> {
  Axis direction;
  RenderFlex({required this.direction});

  @override
  void performLayout(Constraints constraints) {
    int mainAxisExtent = 0;
    int crossAxisExtent = 0;
    for (final child in children) {
      child.layout(constraints);
      final childParentData = child.parentData as FlexParentData;
      if (direction == Axis.vertical) {
        childParentData.offset = Offset(0, mainAxisExtent);
        mainAxisExtent += child.size!.height;
        crossAxisExtent =
            crossAxisExtent > child.size!.width
                ? crossAxisExtent
                : child.size!.width;
      } else {
        childParentData.offset = Offset(mainAxisExtent, 0);
        mainAxisExtent += child.size!.width;
        crossAxisExtent =
            crossAxisExtent > child.size!.height
                ? crossAxisExtent
                : child.size!.height;
      }
    }
    size =
        direction == Axis.vertical
            ? Size(crossAxisExtent, mainAxisExtent)
            : Size(mainAxisExtent, crossAxisExtent);
    AppLogger.log('RenderFlex.performLayout: direction=\$direction, size=\$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    int currentMain = 0;
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      context.paintChild(child, offset + childParentData.offset);
      currentMain +=
          direction == Axis.vertical ? child.size!.height : child.size!.width;
    }
  }
}
