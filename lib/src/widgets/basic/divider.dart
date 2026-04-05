import '../../../radartui.dart';

/// A horizontal line that separates content.
///
/// Draws a [character] (default `─`) with optional [height] and [thickness].
/// Use [VerticalDivider] for a vertical separator.
class Divider extends StatelessWidget {
  /// Creates a [Divider] with optional [height], [thickness], and [color].
  const Divider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.character,
  });

  /// The total height allocated for the divider.
  final int? height;

  /// The number of rows actually drawn as the divider line.
  final int? thickness;

  /// The color of the divider line.
  final Color? color;

  /// The character used to draw the line; defaults to `─`.
  final String? character;

  @override
  Widget build(BuildContext context) {
    return _DividerRenderWidget(
      height: height ?? 1,
      thickness: thickness ?? 1,
      color: color ?? Color.brightBlack,
      character: character ?? '─',
    );
  }
}

/// A vertical line that separates content.
///
/// Draws a [character] (default `│`) with optional [width] and [thickness].
class VerticalDivider extends StatelessWidget {
  /// Creates a [VerticalDivider] with optional [width], [thickness], and [color].
  const VerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.color,
    this.character,
  });

  /// The total width allocated for the divider.
  final int? width;

  /// The number of columns actually drawn as the divider line.
  final int? thickness;

  /// The color of the divider line.
  final Color? color;

  /// The character used to draw the line; defaults to `│`.
  final String? character;

  @override
  Widget build(BuildContext context) {
    return _VerticalDividerRenderWidget(
      width: width ?? 1,
      thickness: thickness ?? 1,
      color: color ?? Color.brightBlack,
      character: character ?? '│',
    );
  }
}

class _DividerRenderWidget extends RenderObjectWidget {
  const _DividerRenderWidget({
    required this.height,
    required this.thickness,
    required this.color,
    required this.character,
  });
  final int height;
  final int thickness;
  final Color color;
  final String character;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderDivider createRenderObject(BuildContext context) => RenderDivider(
        dividerHeight: height,
        thickness: thickness,
        color: color,
        character: character,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final divider = renderObject as RenderDivider;
    divider.dividerHeight = height;
    divider.thickness = thickness;
    divider.color = color;
    divider.character = character;
  }
}

class _VerticalDividerRenderWidget extends RenderObjectWidget {
  const _VerticalDividerRenderWidget({
    required this.width,
    required this.thickness,
    required this.color,
    required this.character,
  });
  final int width;
  final int thickness;
  final Color color;
  final String character;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderVerticalDivider createRenderObject(BuildContext context) =>
      RenderVerticalDivider(
        dividerWidth: width,
        thickness: thickness,
        color: color,
        character: character,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final divider = renderObject as RenderVerticalDivider;
    divider.dividerWidth = width;
    divider.thickness = thickness;
    divider.color = color;
    divider.character = character;
  }
}

/// Render object that paints a horizontal divider line.
class RenderDivider extends RenderBox {
  /// Creates a [RenderDivider] with the given dimensions and visual properties.
  RenderDivider({
    required this.dividerHeight,
    required this.thickness,
    required Color color,
    required this.character,
  }) : _color = color;

  /// The total height of the divider area.
  int dividerHeight;

  /// The number of rows actually drawn.
  int thickness;

  Color _color;

  /// The color of the divider line.
  Color get color => _color;

  /// Sets the color and invalidates the paint cache.
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    _cachedStyle = null;
  }

  /// The character used to draw the line.
  String character;
  TextStyle? _cachedStyle;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    size = Size(boxConstraints.maxWidth, dividerHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cachedStyle ??= TextStyle(color: _color);
    final TextStyle textStyle = _cachedStyle!;
    final lineChar = character.isNotEmpty ? character[0] : '─';

    for (int y = 0; y < thickness && y < dividerHeight; y++) {
      for (int x = 0; x < size!.width; x++) {
        context.buffer.writeStyled(
          offset.x + x,
          offset.y + y,
          lineChar,
          textStyle,
        );
      }
    }
  }
}

/// Render object that paints a vertical divider line.
class RenderVerticalDivider extends RenderBox {
  /// Creates a [RenderVerticalDivider] with the given dimensions and visual properties.
  RenderVerticalDivider({
    required this.dividerWidth,
    required this.thickness,
    required Color color,
    required this.character,
  }) : _color = color;

  /// The total width of the divider area.
  int dividerWidth;

  /// The number of columns actually drawn.
  int thickness;

  Color _color;

  /// The color of the divider line.
  Color get color => _color;

  /// Sets the color and invalidates the paint cache.
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    _cachedStyle = null;
  }

  /// The character used to draw the line.
  String character;
  TextStyle? _cachedStyle;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    size = Size(dividerWidth, boxConstraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cachedStyle ??= TextStyle(color: _color);
    final TextStyle textStyle = _cachedStyle!;
    final lineChar = character.isNotEmpty ? character[0] : '│';

    for (int x = 0; x < thickness && x < dividerWidth; x++) {
      for (int y = 0; y < size!.height; y++) {
        context.buffer.writeStyled(
          offset.x + x,
          offset.y + y,
          lineChar,
          textStyle,
        );
      }
    }
  }
}
