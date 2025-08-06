import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart'; // Added import for framework.dart
import 'package:radartui/src/services/logger.dart'; // Added import

class Text extends RenderObjectWidget {
  final String data;
  const Text(this.data);
  @override
  RenderObjectElement createElement() => RenderObjectElement(this);
  @override
  RenderText createRenderObject(BuildContext context) => RenderText(data);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderText).text = data;
    AppLogger.log('RenderText.updateRenderObject: text="$data"');
  }
}

class RenderText extends RenderBox {
  String text;
  RenderText(this.text);
  @override
  void performLayout(Constraints constraints) {
    size = Size(text.length, 1);
    AppLogger.log('RenderText.performLayout: text="$text", size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    AppLogger.log('RenderText.paint: text="$text", offset=$offset');
    for (int i = 0; i < text.length; i++) {
      context.buffer.write(offset.x + i, offset.y, text[i]);
      AppLogger.log(
        '  Writing char: ${text[i]} at (${offset.x + i}, ${offset.y})',
      );
    }
  }
}

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
    AppLogger.log('RenderPadding.performLayout: padding=$padding, size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    AppLogger.log('RenderPadding.paint: offset=$offset');
    if (children.isNotEmpty) {
      context.paintChild(
        children.first,
        offset + Offset(padding.left, padding.top),
      );
    }
  }
}

class Column extends Flex {
  const Column({required List<Widget> children})
    : super(children: children, direction: Axis.vertical);
}

class Row extends Flex {
  const Row({required List<Widget> children})
    : super(children: children, direction: Axis.horizontal);
}

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
    AppLogger.log('RenderFlex.performLayout: direction=$direction, size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    AppLogger.log('RenderFlex.paint: direction=$direction, offset=$offset');
    int currentMain = 0;
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      context.paintChild(child, offset + childParentData.offset);
      currentMain +=
          direction == Axis.vertical ? child.size!.height : child.size!.width;
    }
  }
}
