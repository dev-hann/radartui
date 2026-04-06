import '../../../radartui.dart';

/// A material-design-inspired card with an optional background color, border, and padding.
///
/// Renders a box-drawing character border around its [child]. Without a child,
/// defaults to a zero-sized [SizedBox].
class Card extends SingleChildRenderObjectWidget {
  /// Creates a [Card] with an optional [child], [color], and [padding].
  const Card({super.key, Widget? child, this.color, this.padding})
      : super(child: child ?? const SizedBox());

  /// The background color applied to the card border and fill.
  final Color? color;

  /// The inner padding between the border and the child.
  final EdgeInsets? padding;

  @override
  RenderCard createRenderObject(BuildContext context) =>
      RenderCard(color: color, padding: padding);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final card = renderObject as RenderCard;
    card.color = color;
    card.padding = padding;
  }
}

/// The render object for [Card], responsible for drawing a box-drawing border
/// and optional background fill around its child.
class RenderCard extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  /// Creates a [RenderCard] with the given [color] and [padding].
  RenderCard({Color? color, EdgeInsets? padding})
      : _color = color,
        _padding = padding;

  Color? _color;
  EdgeInsets? _padding;

  /// The background color for the card's border and fill.
  Color? get color => _color;

  /// Sets the background color and invalidates the cached style.
  set color(Color? v) {
    if (_color == v) return;
    _color = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The inner padding between the card border and its child.
  EdgeInsets? get padding => _padding;

  /// Sets the inner padding and marks layout as needed.
  set padding(EdgeInsets? v) {
    if (_padding == v) return;
    _padding = v;
    markNeedsLayout();
  }

  TextStyle? _cachedBorderStyle;

  void _invalidateCache() {
    _cachedBorderStyle = null;
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalPadding = padding ?? EdgeInsets.zero;
    const borderSize = 2;

    if (child != null) {
      _layoutChild(boxConstraints, totalPadding, borderSize);
    } else {
      size = Size(
        boxConstraints.maxWidth,
        LayoutConstants.defaultContainerHeight,
      );
    }
  }

  void _layoutChild(
    BoxConstraints boxConstraints,
    EdgeInsets totalPadding,
    int borderSize,
  ) {
    child!.layout(
      _buildChildConstraints(boxConstraints, totalPadding, borderSize),
    );
    size = _resolveCardSize(
      boxConstraints,
      totalPadding,
      borderSize,
      child!.size!,
    );
  }

  BoxConstraints _buildChildConstraints(
    BoxConstraints boxConstraints,
    EdgeInsets totalPadding,
    int borderSize,
  ) {
    final availableWidth = boxConstraints.maxWidth - borderSize;
    final availableHeight = boxConstraints.maxHeight - borderSize;
    return BoxConstraints(
      minWidth: 0,
      maxWidth: availableWidth - totalPadding.left - totalPadding.right,
      minHeight: 0,
      maxHeight: availableHeight - totalPadding.top - totalPadding.bottom,
    );
  }

  Size _resolveCardSize(
    BoxConstraints boxConstraints,
    EdgeInsets totalPadding,
    int borderSize,
    Size childSize,
  ) {
    final contentWidth = childSize.width + totalPadding.horizontal + borderSize;
    final rawHeight = childSize.height + totalPadding.vertical + borderSize;
    final minHeight = borderSize + totalPadding.vertical + 1;
    return Size(
      _resolveDimension(
        boxConstraints.minWidth,
        boxConstraints.maxWidth,
        contentWidth,
      ),
      _resolveDimension(
        boxConstraints.minHeight,
        boxConstraints.maxHeight,
        rawHeight < minHeight ? minHeight : rawHeight,
      ),
    );
  }

  int _resolveDimension(int minDim, int maxDim, int contentDim) {
    return minDim >= maxDim ? maxDim : contentDim;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalPadding = padding ?? EdgeInsets.zero;
    final width = size!.width;
    final height = size!.height;
    _ensureStylesCached();
    final TextStyle borderStyle = _cachedBorderStyle!;

    _paintBackground(context, offset, width, height);
    _paintChild(context, offset, totalPadding);
    _paintTopBorder(context, offset, width, borderStyle);
    _paintSideBorders(context, offset, width, height, borderStyle);
    _paintBottomBorder(context, offset, width, height, borderStyle);
  }

  void _ensureStylesCached() {
    if (_cachedBorderStyle != null) return;
    _cachedBorderStyle = TextStyle(backgroundColor: _color);
  }

  void _paintBackground(
    PaintingContext context,
    Offset offset,
    int width,
    int height,
  ) {
    if (color == null) return;
    final TextStyle bgStyle = _cachedBorderStyle!;
    for (int y = 0; y < height; y++) {
      context.fillBackground(offset.x, offset.y + y, width, bgStyle);
    }
  }

  void _paintChild(
    PaintingContext context,
    Offset offset,
    EdgeInsets totalPadding,
  ) {
    if (child != null) {
      context.paintChild(
        child!,
        offset + Offset(1 + totalPadding.left, 1 + totalPadding.top),
      );
    }
  }

  int _innerWidth(int width) => width > 2 ? width - 2 : 0;

  void _paintTopBorder(
    PaintingContext context,
    Offset offset,
    int width,
    TextStyle style,
  ) {
    context.writeString(
      offset.x,
      offset.y,
      '┌${'─' * _innerWidth(width)}┐',
      style,
    );
  }

  void _paintSideBorders(
    PaintingContext context,
    Offset offset,
    int width,
    int height,
    TextStyle style,
  ) {
    for (int y = 1; y < height - 1; y++) {
      context.buffer.writeStyled(offset.x, offset.y + y, '│', style);
      context.buffer.writeStyled(
        offset.x + width - 1,
        offset.y + y,
        '│',
        style,
      );
    }
  }

  void _paintBottomBorder(
    PaintingContext context,
    Offset offset,
    int width,
    int height,
    TextStyle style,
  ) {
    final int y = offset.y + height - 1;
    context.writeString(
      offset.x,
      y,
      '└${'─' * _innerWidth(width)}┘',
      style,
    );
  }
}
