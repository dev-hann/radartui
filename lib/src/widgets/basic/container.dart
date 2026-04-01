import '../../../radartui.dart';

class Container extends SingleChildRenderObjectWidget {
  const Container({
    super.key,
    Widget? child,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.border,
  }) : super(child: child ?? const SizedBox());
  final Color? color;
  final int? width;
  final int? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Border? border;

  @override
  RenderContainer createRenderObject(BuildContext context) => RenderContainer(
        color: color,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        border: border,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final container = renderObject as RenderContainer;
    container.color = color;
    container.containerWidth = width;
    container.containerHeight = height;
    container.padding = padding;
    container.margin = margin;
    container.border = border;
  }
}

class RenderContainer extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderContainer({
    this.color,
    int? width,
    int? height,
    this.padding,
    this.margin,
    this.border,
  })  : _width = width,
        _height = height;
  Color? color;
  int? _width;
  int? _height;
  EdgeInsets? padding;
  EdgeInsets? margin;
  Border? border;

  int? get containerWidth => _width;
  set containerWidth(int? value) => _width = value;

  int? get containerHeight => _height;
  set containerHeight(int? value) => _height = value;

  bool get _hasBorder {
    if (border == null) return false;
    return border!.top.isNotEmpty ||
        border!.right.isNotEmpty ||
        border!.bottom.isNotEmpty ||
        border!.left.isNotEmpty;
  }

  int get _borderHorizontal => _hasBorder
      ? (border!.left.isNotEmpty ? 1 : 0) + (border!.right.isNotEmpty ? 1 : 0)
      : 0;
  int get _borderVertical => _hasBorder
      ? (border!.top.isNotEmpty ? 1 : 0) + (border!.bottom.isNotEmpty ? 1 : 0)
      : 0;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalMargin = margin ?? const EdgeInsets.all(0);
    final totalPadding = padding ?? const EdgeInsets.all(0);

    int containerW = _width ?? boxConstraints.maxWidth;
    int containerH = _height ?? LayoutConstants.defaultContainerHeight;

    if (child != null) {
      final childConstraint = BoxConstraints(
        maxWidth: containerW -
            totalPadding.left -
            totalPadding.right -
            _borderHorizontal,
        maxHeight: containerH -
            totalPadding.top -
            totalPadding.bottom -
            _borderVertical,
      );
      child!.layout(childConstraint);

      if (_width == null) {
        containerW = child!.size!.width +
            totalPadding.left +
            totalPadding.right +
            _borderHorizontal;
      }
      if (_height == null) {
        containerH = child!.size!.height +
            totalPadding.top +
            totalPadding.bottom +
            _borderVertical;
      }
    }

    size = Size(
      containerW + totalMargin.left + totalMargin.right,
      containerH + totalMargin.top + totalMargin.bottom,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? const EdgeInsets.all(0);
    final totalPadding = padding ?? const EdgeInsets.all(0);
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);

    final innerWidth = size!.width - totalMargin.left - totalMargin.right;
    final innerHeight = size!.height - totalMargin.top - totalMargin.bottom;

    if (color != null) {
      final bgStyle = TextStyle(backgroundColor: color);

      for (int y = 0; y < innerHeight; y++) {
        for (int x = 0; x < innerWidth; x++) {
          context.buffer.writeStyled(
            innerOffset.x + x,
            innerOffset.y + y,
            ' ',
            bgStyle,
          );
        }
      }
    }

    if (child != null) {
      final int borderLeft = _hasBorder && border!.left.isNotEmpty ? 1 : 0;
      final int borderTop = _hasBorder && border!.top.isNotEmpty ? 1 : 0;

      context.paintChild(
        child!,
        innerOffset +
            Offset(
              borderLeft + totalPadding.left,
              borderTop + totalPadding.top,
            ),
      );
    }

    if (_hasBorder) {
      final borderStyle = TextStyle(backgroundColor: color);
      final int hasLeft = border!.left.isNotEmpty ? 1 : 0;
      final int hasRight = border!.right.isNotEmpty ? 1 : 0;
      final int hasTop = border!.top.isNotEmpty ? 1 : 0;
      final int hasBottom = border!.bottom.isNotEmpty ? 1 : 0;

      if (hasTop == 1) {
        final String topLeft = hasLeft == 1 ? '┌' : '╶';
        final String topRight = hasRight == 1 ? '┐' : '╴';

        context.buffer.writeStyled(
          innerOffset.x,
          innerOffset.y,
          topLeft,
          borderStyle,
        );
        for (int x = 1; x < innerWidth - 1; x++) {
          context.buffer.writeStyled(
            innerOffset.x + x,
            innerOffset.y,
            border!.top,
            borderStyle,
          );
        }
        context.buffer.writeStyled(
          innerOffset.x + innerWidth - 1,
          innerOffset.y,
          topRight,
          borderStyle,
        );
      }

      if (hasBottom == 1) {
        final String bottomLeft = hasLeft == 1 ? '└' : '╶';
        final String bottomRight = hasRight == 1 ? '┘' : '╴';

        context.buffer.writeStyled(
          innerOffset.x,
          innerOffset.y + innerHeight - 1,
          bottomLeft,
          borderStyle,
        );
        for (int x = 1; x < innerWidth - 1; x++) {
          context.buffer.writeStyled(
            innerOffset.x + x,
            innerOffset.y + innerHeight - 1,
            border!.bottom,
            borderStyle,
          );
        }
        context.buffer.writeStyled(
          innerOffset.x + innerWidth - 1,
          innerOffset.y + innerHeight - 1,
          bottomRight,
          borderStyle,
        );
      }

      if (hasLeft == 1) {
        final int yStart = hasTop == 1 ? 1 : 0;
        final int yEnd = hasBottom == 1 ? innerHeight - 1 : innerHeight;
        for (int y = yStart; y < yEnd; y++) {
          context.buffer.writeStyled(
            innerOffset.x,
            innerOffset.y + y,
            border!.left,
            borderStyle,
          );
        }
      }

      if (hasRight == 1) {
        final int yStart = hasTop == 1 ? 1 : 0;
        final int yEnd = hasBottom == 1 ? innerHeight - 1 : innerHeight;
        for (int y = yStart; y < yEnd; y++) {
          context.buffer.writeStyled(
            innerOffset.x + innerWidth - 1,
            innerOffset.y + y,
            border!.right,
            borderStyle,
          );
        }
      }
    }
  }
}
