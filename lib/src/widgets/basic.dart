import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

class Text extends RenderObjectWidget {
  final String data;
  final TextStyle? style;
  const Text(this.data, {this.style});
  @override
  RenderObjectElement createElement() => RenderObjectElement(this);
  @override
  RenderText createRenderObject(BuildContext context) =>
      RenderText(data, style);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderText = renderObject as RenderText;
    renderText.text = data;
    renderText.style = style;
    AppLogger.log('RenderText.updateRenderObject: text="$data", style=$style');
  }
}

class RenderText extends RenderBox {
  String text;
  TextStyle? style;
  RenderText(this.text, this.style);

  @override
  void performLayout(Constraints constraints) {
    size = Size(text.length, 1);
    AppLogger.log('RenderText.performLayout: text="$text", size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    AppLogger.log('RenderText.paint: text="$text", offset=$offset');
    for (int i = 0; i < text.length; i++) {
      context.buffer.writeStyled(offset.x + i, offset.y, text[i], style);
      AppLogger.log(
        '  Writing char: ${text[i]} at (${offset.x + i}, ${offset.y}) with style: $style',
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
    int currentMain = 0;
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      context.paintChild(child, offset + childParentData.offset);
      currentMain +=
          direction == Axis.vertical ? child.size!.height : child.size!.width;
    }
  }
}

// Container widget for styling and sizing
class Container extends SingleChildRenderObjectWidget {
  final Color? color;
  final int? width;
  final int? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const Container({
    Widget? child,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
  }) : super(child: child ?? const SizedBox());

  @override
  RenderContainer createRenderObject(BuildContext context) => RenderContainer(
    color: color,
    width: width,
    height: height,
    padding: padding,
    margin: margin,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final container = renderObject as RenderContainer;
    container.color = color;
    container.width = width;
    container.height = height;
    container.padding = padding;
    container.margin = margin;
  }
}

class RenderContainer extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ParentData> {
  Color? color;
  int? width;
  int? height;
  EdgeInsets? padding;
  EdgeInsets? margin;

  RenderContainer({
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    final totalMargin = margin ?? EdgeInsets.all(0);
    final totalPadding = padding ?? EdgeInsets.all(0);

    int containerWidth = width ?? boxConstraints.maxWidth;
    int containerHeight = height ?? 1;

    if (children.isNotEmpty) {
      final child = children.first;
      final childConstraints = BoxConstraints(
        maxWidth: containerWidth - totalPadding.left - totalPadding.right,
        maxHeight: containerHeight - totalPadding.top - totalPadding.bottom,
      );
      child.layout(childConstraints);

      if (width == null)
        containerWidth =
            child.size!.width + totalPadding.left + totalPadding.right;
      if (height == null)
        containerHeight =
            child.size!.height + totalPadding.top + totalPadding.bottom;
    }

    size = Size(
      containerWidth + totalMargin.left + totalMargin.right,
      containerHeight + totalMargin.top + totalMargin.bottom,
    );

    AppLogger.log('RenderContainer.performLayout: size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? EdgeInsets.all(0);
    final totalPadding = padding ?? EdgeInsets.all(0);
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);

    // Fill background if color is specified
    if (color != null) {
      final bgStyle = TextStyle(backgroundColor: color);
      for (
        int y = 0;
        y < size!.height - totalMargin.top - totalMargin.bottom;
        y++
      ) {
        for (
          int x = 0;
          x < size!.width - totalMargin.left - totalMargin.right;
          x++
        ) {
          context.buffer.writeStyled(
            innerOffset.x + x,
            innerOffset.y + y,
            ' ',
            bgStyle,
          );
        }
      }
    }

    // Paint child with padding offset
    if (children.isNotEmpty) {
      context.paintChild(
        children.first,
        innerOffset + Offset(totalPadding.left, totalPadding.top),
      );
    }
  }
}

// SizedBox for spacing
class SizedBox extends RenderObjectWidget {
  final int width;
  final int height;
  final Widget? child;

  const SizedBox({this.width = 0, this.height = 0, this.child});
  const SizedBox.square({required int dimension, this.child})
    : width = dimension,
      height = dimension;

  @override
  RenderObjectElement createElement() =>
      child != null
          ? SingleChildRenderObjectElement(
            this as SingleChildRenderObjectWidget,
          )
          : RenderObjectElement(this);

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
    AppLogger.log('RenderSizedBox.performLayout: size=$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // SizedBox doesn't paint anything
  }
}

// Center widget
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
    AppLogger.log('RenderCenter.performLayout: size=$size');
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
