import '../../../radartui.dart';

/// A convenience widget that combines common painting, positioning, and sizing.
///
/// Supports [color] background, [width]/[height] constraints, [padding],
/// [margin], and box-drawing [border] characters.
class Container extends SingleChildRenderObjectWidget {
  /// Creates a [Container] with optional styling and a single [child].
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

  /// The background color of the container.
  final Color? color;

  /// The fixed width of the container, or `null` to size from the child.
  final int? width;

  /// The fixed height of the container, or `null` to size from the child.
  final int? height;

  /// Inner padding between the border and the child.
  final EdgeInsets? padding;

  /// Outer margin around the container.
  final EdgeInsets? margin;

  /// The box-drawing border characters to draw around the container.
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

/// Render object that paints a container with optional background, border, padding, and margin.
class RenderContainer extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  /// Creates a [RenderContainer] with the given visual properties.
  RenderContainer({
    Color? color,
    int? width,
    int? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Border? border,
  })  : _color = color,
        _width = width,
        _height = height,
        _padding = padding,
        _margin = margin,
        _border = border {
    _invalidateBorderDimensions();
  }

  Color? _color;
  int? _width;
  int? _height;
  EdgeInsets? _padding;
  EdgeInsets? _margin;
  Border? _border;
  bool _cachedHasBorder = false;
  int _cachedBorderHorizontal = 0;
  int _cachedBorderVertical = 0;
  TextStyle? _cachedBgStyle;
  TextStyle? _cachedBorderStyle;
  _BorderSides? _cachedBorderSides;

  /// The background color, or `null` for a transparent background.
  Color? get color => _color;

  /// Sets the background color.
  set color(Color? value) {
    if (_color == value) return;
    _color = value;
    _cachedBgStyle = null;
    _cachedBorderStyle = null;
    _cachedBorderSides = null;
    markNeedsPaint();
  }

  /// Inner padding between the border and the child.
  EdgeInsets? get padding => _padding;

  /// Sets the inner padding and marks layout as needed.
  set padding(EdgeInsets? value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  /// Outer margin around the container.
  EdgeInsets? get margin => _margin;

  /// Sets the outer margin and marks layout as needed.
  set margin(EdgeInsets? value) {
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  /// The box-drawing border characters.
  Border? get border => _border;

  /// Sets the border characters and marks layout as needed.
  set border(Border? value) {
    if (_border == value) return;
    _border = value;
    _cachedBorderSides = null;
    _invalidateBorderDimensions();
    markNeedsLayout();
  }

  /// The fixed width, or `null` to size from the child.
  int? get containerWidth => _width;

  /// Sets the fixed width and marks layout as needed.
  set containerWidth(int? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  /// The fixed height, or `null` to size from the child.
  int? get containerHeight => _height;

  /// Sets the fixed height and marks layout as needed.
  set containerHeight(int? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  bool get _hasBorder => _cachedHasBorder;
  int get _borderHorizontal => _cachedBorderHorizontal;
  int get _borderVertical => _cachedBorderVertical;

  void _invalidateBorderDimensions() {
    if (_border == null) {
      _cachedHasBorder = false;
      _cachedBorderHorizontal = 0;
      _cachedBorderVertical = 0;
      return;
    }
    _cachedHasBorder = _border!.top.isNotEmpty ||
        _border!.right.isNotEmpty ||
        _border!.bottom.isNotEmpty ||
        _border!.left.isNotEmpty;
    _cachedBorderHorizontal = _cachedHasBorder
        ? (_border!.left.isNotEmpty ? 1 : 0) +
            (_border!.right.isNotEmpty ? 1 : 0)
        : 0;
    _cachedBorderVertical = _cachedHasBorder
        ? (_border!.top.isNotEmpty ? 1 : 0) +
            (_border!.bottom.isNotEmpty ? 1 : 0)
        : 0;
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalMargin = margin ?? EdgeInsets.zero;
    final totalPadding = padding ?? EdgeInsets.zero;

    int containerW = _width ?? boxConstraints.maxWidth;
    int containerH = _height ?? LayoutConstants.defaultContainerHeight;

    if (child != null) {
      final resolved = _layoutChild(containerW, containerH, totalPadding);
      containerW = resolved.$1;
      containerH = resolved.$2;
    }

    size = Size(
      containerW + totalMargin.horizontal,
      containerH + totalMargin.vertical,
    );
  }

  (int, int) _layoutChild(
    int containerW,
    int containerH,
    EdgeInsets totalPadding,
  ) {
    final int horizPad = totalPadding.horizontal + _borderHorizontal;
    final int vertPad = totalPadding.vertical + _borderVertical;
    child!.layout(BoxConstraints(
      maxWidth: containerW - horizPad,
      maxHeight: containerH - vertPad,
    ));

    final resolvedW = _width ?? child!.size!.width + horizPad;
    final resolvedH = _height ?? child!.size!.height + vertPad;
    return (resolvedW, resolvedH);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? EdgeInsets.zero;
    final totalPadding = padding ?? EdgeInsets.zero;
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);
    final innerWidth =
        (size!.width - totalMargin.horizontal).clamp(0, size!.width);
    final innerHeight =
        (size!.height - totalMargin.vertical).clamp(0, size!.height);

    _paintBackground(context, innerOffset, innerWidth, innerHeight);

    if (child != null) {
      final Offset childOffset = _childPaintOffset(totalPadding);
      context.paintChild(child!, innerOffset + childOffset);
    }

    if (_hasBorder) {
      _paintBorder(context, innerOffset, innerWidth, innerHeight);
    }
  }

  Offset _childPaintOffset(EdgeInsets totalPadding) {
    final int borderLeft = _hasBorder && border!.left.isNotEmpty ? 1 : 0;
    final int borderTop = _hasBorder && border!.top.isNotEmpty ? 1 : 0;
    return Offset(borderLeft + totalPadding.left, borderTop + totalPadding.top);
  }

  void _paintBackground(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    int innerHeight,
  ) {
    if (_color == null) return;
    _cachedBgStyle ??= TextStyle(backgroundColor: _color);
    for (int y = 0; y < innerHeight; y++) {
      context.fillBackground(
        innerOffset.x,
        innerOffset.y + y,
        innerWidth,
        _cachedBgStyle!,
      );
    }
  }

  void _ensureBorderCached() {
    _cachedBorderStyle ??= TextStyle(backgroundColor: _color);
    _cachedBorderSides ??= _BorderSides(
      left: border!.left.isNotEmpty,
      right: border!.right.isNotEmpty,
      top: border!.top.isNotEmpty,
      bottom: border!.bottom.isNotEmpty,
      style: _cachedBorderStyle!,
    );
  }

  void _paintBorder(
    PaintingContext context,
    Offset innerOffset,
    int innerWidth,
    int innerHeight,
  ) {
    _ensureBorderCached();
    final sides = _cachedBorderSides!;
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
    final int inner = innerWidth > 2 ? innerWidth - 2 : 0;
    context.writeString(
      innerOffset.x,
      innerOffset.y + y,
      '$leftCorner${character * inner}$rightCorner',
      sides.style,
    );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _BorderSides &&
        other.left == left &&
        other.right == right &&
        other.top == top &&
        other.bottom == bottom &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(left, right, top, bottom, style);
}
