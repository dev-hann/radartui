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
    final sides = _BorderSides(
      left: border!.left.isNotEmpty,
      right: border!.right.isNotEmpty,
      top: border!.top.isNotEmpty,
      bottom: border!.bottom.isNotEmpty,
      style: TextStyle(backgroundColor: color),
    );
    if (sides.top) {
      _paintHorizontalBorder(context, innerOffset, innerWidth, border!.top,
          isTop: true, sides: sides);
    }
    if (sides.bottom) {
      _paintHorizontalBorder(context, innerOffset, innerWidth, border!.bottom,
          isTop: false, innerHeight: innerHeight, sides: sides);
    }
    if (sides.left) {
      _paintVerticalBorder(context, innerOffset, innerHeight, border!.left,
          isLeft: true, innerWidth: innerWidth, sides: sides);
    }
    if (sides.right) {
      _paintVerticalBorder(context, innerOffset, innerHeight, border!.right,
          isLeft: false, innerWidth: innerWidth, sides: sides);
    }
  }

  void _paintHorizontalBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    String character, {
    required bool isTop,
    required _BorderSides sides,
    int innerHeight = 0,
  }) {
    final int y = isTop ? 0 : innerHeight - 1;
    final String leftCorner =
        isTop ? (sides.left ? '┌' : '╶') : (sides.left ? '└' : '╶');
    final String rightCorner =
        isTop ? (sides.right ? '┐' : '╴') : (sides.right ? '┘' : '╴');
    context.buffer
        .writeStyled(innerOffset.x, innerOffset.y + y, leftCorner, sides.style);
    for (int x = 1; x < innerWidth - 1; x++) {
      context.buffer.writeStyled(
          innerOffset.x + x, innerOffset.y + y, character, sides.style);
    }
    context.buffer.writeStyled(innerOffset.x + innerWidth - 1,
        innerOffset.y + y, rightCorner, sides.style);
  }

  void _paintVerticalBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerHeight,
    String character, {
    required bool isLeft,
    required int innerWidth,
    required _BorderSides sides,
  }) {
    final int x = isLeft ? 0 : innerWidth - 1;
    final int yStart = sides.top ? 1 : 0;
    final int yEnd = sides.bottom ? innerHeight - 1 : innerHeight;
    for (int y = yStart; y < yEnd; y++) {
      context.buffer.writeStyled(
          innerOffset.x + x, innerOffset.y + y, character, sides.style);
    }
  }
}

class _BorderSides {
  const _BorderSides({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.style,
  });
  final bool left;
  final bool right;
  final bool top;
  final bool bottom;
  final TextStyle style;
}
