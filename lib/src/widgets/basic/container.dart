import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/foundation/constants.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/widgets/basic/sized_box.dart';

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
    int containerHeight = height ?? LayoutConstants.defaultContainerHeight;

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
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? EdgeInsets.all(0);
    final totalPadding = padding ?? EdgeInsets.all(0);
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);

    // Fill background if color is specified
    if (color != null) {
      final bgStyle = TextStyle(backgroundColor: color);
      final bgWidth = size!.width - totalMargin.left - totalMargin.right;
      final bgHeight = size!.height - totalMargin.top - totalMargin.bottom;
      final bgLine = ' ' * bgWidth;

      for (int y = 0; y < bgHeight; y++) {
        for (int i = 0; i < bgLine.length; i++) {
          context.buffer.writeStyled(
            innerOffset.x + i,
            innerOffset.y + y,
            bgLine[i],
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
