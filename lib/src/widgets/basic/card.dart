import '../../../radartui.dart';

/// A material-design-inspired card with an optional background color, border, and padding.
///
/// Renders a box-drawing character border around its [child]. Without a child,
/// defaults to a zero-sized [SizedBox].
class Card extends SingleChildRenderObjectWidget {
  const Card({super.key, Widget? child, this.color, this.padding})
      : super(child: child ?? const SizedBox());
  final Color? color;
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

class RenderCard extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  RenderCard({Color? color, EdgeInsets? padding})
      : _color = color,
        _padding = padding;

  Color? _color;
  EdgeInsets? _padding;

  Color? get color => _color;
  set color(Color? v) {
    _color = v;
    _invalidateCache();
  }

  EdgeInsets? get padding => _padding;
  set padding(EdgeInsets? v) {
    _padding = v;
  }

  TextStyle? _cachedBorderStyle;

  void _invalidateCache() {
    _cachedBorderStyle = null;
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalPadding = padding ?? const EdgeInsets.all(0);
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
    final contentWidth =
        childSize.width + totalPadding.left + totalPadding.right + borderSize;
    final rawHeight =
        childSize.height + totalPadding.top + totalPadding.bottom + borderSize;
    final minHeight = borderSize + totalPadding.top + 1 + totalPadding.bottom;
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
    final totalPadding = padding ?? const EdgeInsets.all(0);
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
      for (int x = 0; x < width; x++) {
        context.buffer.writeStyled(offset.x + x, offset.y + y, ' ', bgStyle);
      }
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

  void _paintTopBorder(
    PaintingContext context,
    Offset offset,
    int width,
    TextStyle style,
  ) {
    context.buffer.writeStyled(offset.x, offset.y, '┌', style);
    for (int x = 1; x < width - 1; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, '─', style);
    }
    context.buffer.writeStyled(offset.x + width - 1, offset.y, '┐', style);
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
    context.buffer.writeStyled(offset.x, offset.y + height - 1, '└', style);
    for (int x = 1; x < width - 1; x++) {
      context.buffer.writeStyled(
        offset.x + x,
        offset.y + height - 1,
        '─',
        style,
      );
    }
    context.buffer.writeStyled(
      offset.x + width - 1,
      offset.y + height - 1,
      '┘',
      style,
    );
  }
}
