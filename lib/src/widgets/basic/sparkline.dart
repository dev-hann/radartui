import '../../../radartui.dart';

/// A compact inline chart that renders a list of numeric [data] as a sparkline.
///
/// Maps each value to a block character whose height is proportional to the
/// value's position within the data range. Optionally set [color] for the bars.
class Sparkline extends StatelessWidget {
  /// Creates a [Sparkline] from the given numeric [data].
  const Sparkline({
    super.key,
    required this.data,
    this.color,
  });

  /// The numeric values to render as a sparkline.
  final List<double> data;

  /// The color of the sparkline characters.
  final Color? color;

  static const List<String> _blockChars = [
    '▁',
    '▂',
    '▃',
    '▄',
    '▅',
    '▆',
    '▇',
    '█',
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(height: 1);
    }

    double minVal = data[0];
    double maxVal = data[0];
    for (final v in data) {
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
    }

    final double range = maxVal - minVal;
    final List<String> chars = data.map((v) {
      if (range == 0) return _blockChars[0];
      final int idx = (((v - minVal) / range) * (_blockChars.length - 1))
          .round()
          .clamp(0, _blockChars.length - 1);
      return _blockChars[idx];
    }).toList();

    return _SparklineRenderWidget(
      chars: chars,
      color: color ?? Color.green,
    );
  }
}

class _SparklineRenderWidget extends RenderObjectWidget {
  const _SparklineRenderWidget({
    required this.chars,
    required this.color,
  });

  final List<String> chars;
  final Color color;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderSparkline createRenderObject(BuildContext context) => RenderSparkline(
        chars: chars,
        color: color,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderSparkline;
    final bool needsLayout = render.chars != chars;
    render.chars = chars;
    render.color = color;
    if (needsLayout) {
      render.markNeedsLayout();
    }
  }
}

/// The render object for [Sparkline], which paints block characters proportional
/// to each data value.
class RenderSparkline extends RenderBox {
  /// Creates a [RenderSparkline] with the given characters and color.
  RenderSparkline({
    required this.chars,
    required Color color,
  }) : _color = color;

  /// The block characters to render, one per data point.
  List<String> chars;

  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    _cachedStyle = null;
    markNeedsPaint();
  }

  TextStyle? _cachedStyle;

  @override
  void performLayout(Constraints constraints) {
    size = Size(chars.length, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cachedStyle ??= TextStyle(color: _color);
    final TextStyle style = _cachedStyle!;
    for (int i = 0; i < chars.length; i++) {
      context.buffer.writeStyled(offset.x + i, offset.y, chars[i], style);
    }
  }
}
