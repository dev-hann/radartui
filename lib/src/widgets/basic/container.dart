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
      final resolved = _layoutChild(containerW, containerH, totalPadding);
      containerW = resolved.$1;
      containerH = resolved.$2;
    }

    size = Size(
      containerW + totalMargin.left + totalMargin.right,
      containerH + totalMargin.top + totalMargin.bottom,
    );
  }

  (int, int) _layoutChild(
    int containerW,
    int containerH,
    EdgeInsets totalPadding,
  ) {
    final childConstraint = BoxConstraints(
      maxWidth: containerW -
          totalPadding.left -
          totalPadding.right -
          _borderHorizontal,
      maxHeight:
          containerH - totalPadding.top - totalPadding.bottom - _borderVertical,
    );
    child!.layout(childConstraint);

    final resolvedW = _width ??
        child!.size!.width +
            totalPadding.left +
            totalPadding.right +
            _borderHorizontal;
    final resolvedH = _height ??
        child!.size!.height +
            totalPadding.top +
            totalPadding.bottom +
            _borderVertical;
    return (resolvedW, resolvedH);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? const EdgeInsets.all(0);
    final totalPadding = padding ?? const EdgeInsets.all(0);
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);
    final innerWidth = size!.width - totalMargin.left - totalMargin.right;
    final innerHeight = size!.height - totalMargin.top - totalMargin.bottom;

    _paintBackground(context, innerOffset, innerWidth, innerHeight);

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
      _paintBorder(context, innerOffset, innerWidth, innerHeight);
    }
  }

  void _paintBackground(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    int innerHeight,
  ) {
    if (color == null) return;
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

  void _paintBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    int innerHeight,
  ) {
    final borderStyle = TextStyle(backgroundColor: color);
    final int hasLeft = border!.left.isNotEmpty ? 1 : 0;
    final int hasRight = border!.right.isNotEmpty ? 1 : 0;
    final int hasTop = border!.top.isNotEmpty ? 1 : 0;
    final int hasBottom = border!.bottom.isNotEmpty ? 1 : 0;

    if (hasTop == 1) {
      _paintHorizontalBorder(
        context,
        innerOffset,
        innerWidth,
        hasLeft,
        hasRight,
        border!.top,
        isTop: true,
        borderStyle: borderStyle,
      );
    }

    if (hasBottom == 1) {
      _paintHorizontalBorder(
        context,
        innerOffset,
        innerWidth,
        hasLeft,
        hasRight,
        border!.bottom,
        isTop: false,
        innerHeight: innerHeight,
        borderStyle: borderStyle,
      );
    }

    if (hasLeft == 1) {
      _paintVerticalBorder(
        context,
        innerOffset,
        innerHeight,
        hasTop,
        hasBottom,
        border!.left,
        isLeft: true,
        innerWidth: innerWidth,
        borderStyle: borderStyle,
      );
    }

    if (hasRight == 1) {
      _paintVerticalBorder(
        context,
        innerOffset,
        innerHeight,
        hasTop,
        hasBottom,
        border!.right,
        isLeft: false,
        innerWidth: innerWidth,
        borderStyle: borderStyle,
      );
    }
  }

  void _paintHorizontalBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    int hasLeft,
    int hasRight,
    String character, {
    required bool isTop,
    required TextStyle borderStyle,
    int innerHeight = 0,
  }) {
    final int y = isTop ? 0 : innerHeight - 1;
    final String leftCorner =
        isTop ? (hasLeft == 1 ? '┌' : '╶') : (hasLeft == 1 ? '└' : '╶');
    final String rightCorner =
        isTop ? (hasRight == 1 ? '┐' : '╴') : (hasRight == 1 ? '┘' : '╴');

    context.buffer.writeStyled(
      innerOffset.x,
      innerOffset.y + y,
      leftCorner,
      borderStyle,
    );
    for (int x = 1; x < innerWidth - 1; x++) {
      context.buffer.writeStyled(
        innerOffset.x + x,
        innerOffset.y + y,
        character,
        borderStyle,
      );
    }
    context.buffer.writeStyled(
      innerOffset.x + innerWidth - 1,
      innerOffset.y + y,
      rightCorner,
      borderStyle,
    );
  }

  void _paintVerticalBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerHeight,
    int hasTop,
    int hasBottom,
    String character, {
    required bool isLeft,
    required int innerWidth,
    required TextStyle borderStyle,
  }) {
    final int x = isLeft ? 0 : innerWidth - 1;
    final int yStart = hasTop == 1 ? 1 : 0;
    final int yEnd = hasBottom == 1 ? innerHeight - 1 : innerHeight;
    for (int y = yStart; y < yEnd; y++) {
      context.buffer.writeStyled(
        innerOffset.x + x,
        innerOffset.y + y,
        character,
        borderStyle,
      );
    }
  }
}
