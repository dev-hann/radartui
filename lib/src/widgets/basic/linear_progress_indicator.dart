import '../../../radartui.dart';

/// A horizontal bar that fills proportionally to [value] (0.0–1.0).
///
/// Displays a colored bar within a fixed-height track. When [value] is `null`,
/// shows an indeterminate animation. Supports custom [backgroundColor] and [color].
class LinearProgressIndicator extends StatefulWidget {
  /// Creates a [LinearProgressIndicator] with an optional [value].
  const LinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.indicatorWidth,
  });

  /// The progress value between 0.0 and 1.0, or `null` for indeterminate.
  final double? value;

  /// The color of the unfilled track background.
  final Color? backgroundColor;

  /// The color of the filled progress bar.
  final Color? color;

  /// The fixed width of the indicator, or `null` to fill available space.
  final int? indicatorWidth;

  @override
  State<LinearProgressIndicator> createState() =>
      _LinearProgressIndicatorState();
}

class _LinearProgressIndicatorState extends State<LinearProgressIndicator> {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
    _controller.addListener(() => setState(() {}));

    if (widget.value == null) {
      _controller.addStatusListener(_onStatusChanged);
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool becameIndeterminate =
        oldWidget.value != null && widget.value == null;
    final bool becameDeterminate =
        oldWidget.value == null && widget.value != null;

    if (becameIndeterminate) {
      _controller.addStatusListener(_onStatusChanged);
      _controller.forward();
    } else if (becameDeterminate) {
      _controller.removeStatusListener(_onStatusChanged);
      _controller.stop();
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LinearProgressIndicatorRenderWidget(
      value: widget.value,
      animValue: _animation.value,
      backgroundColor: widget.backgroundColor ?? Color.brightBlack,
      color: widget.color ?? Color.green,
      indicatorWidth: widget.indicatorWidth,
    );
  }
}

class _LinearProgressIndicatorRenderWidget extends RenderObjectWidget {
  const _LinearProgressIndicatorRenderWidget({
    required this.value,
    required this.animValue,
    required this.backgroundColor,
    required this.color,
    this.indicatorWidth,
  });

  final double? value;
  final double animValue;
  final Color backgroundColor;
  final Color color;
  final int? indicatorWidth;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderLinearProgressIndicator createRenderObject(BuildContext context) =>
      RenderLinearProgressIndicator(
        value: value,
        animValue: animValue,
        backgroundColor: backgroundColor,
        color: color,
        indicatorWidth: indicatorWidth,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderLinearProgressIndicator;
    render.value = value;
    render.animValue = animValue;
    render.backgroundColor = backgroundColor;
    render.color = color;
    render.indicatorWidth = indicatorWidth;
  }
}

/// Render object that paints a linear progress bar with determinate or indeterminate fill.
class RenderLinearProgressIndicator extends RenderBox {
  /// Creates a [RenderLinearProgressIndicator] with the given value and colors.
  RenderLinearProgressIndicator({
    required double? value,
    required double animValue,
    required Color backgroundColor,
    required Color color,
    int? indicatorWidth,
  })  : _value = value ?? 0.0,
        _animValue = animValue,
        _backgroundColor = backgroundColor,
        _color = color,
        _indicatorWidth = indicatorWidth;

  double? _value;
  double _animValue;
  Color _backgroundColor;
  Color _color;
  int? _indicatorWidth;

  /// The progress value (0.0–1.0), or `null` for indeterminate.
  double? get value => _value;

  /// Sets the progress value.
  set value(double? v) {
    if (_value == v) return;
    _value = v;
    markNeedsPaint();
  }

  /// The current animation value for indeterminate mode.
  double get animValue => _animValue;

  /// Sets the animation value.
  set animValue(double v) {
    if (_animValue == v) return;
    _animValue = v;
    markNeedsPaint();
  }

  /// The background track color.
  Color get backgroundColor => _backgroundColor;

  /// Sets the background color.
  set backgroundColor(Color v) {
    if (_backgroundColor == v) return;
    _backgroundColor = v;
    _invalidateCache();
  }

  /// The filled bar color.
  Color get color => _color;

  /// Sets the fill color.
  set color(Color v) {
    if (_color == v) return;
    _color = v;
    _invalidateCache();
  }

  /// The fixed width, or `null` to fill available space.
  int? get indicatorWidth => _indicatorWidth;

  /// Sets the indicator width.
  set indicatorWidth(int? v) {
    if (_indicatorWidth == v) return;
    _indicatorWidth = v;
    markNeedsLayout();
  }

  TextStyle? _cachedBgStyle;
  TextStyle? _cachedFillStyle;

  void _invalidateCache() {
    _cachedBgStyle = null;
    _cachedFillStyle = null;
    markNeedsPaint();
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final int w = indicatorWidth ?? boxConstraints.maxWidth;
    size = Size(w, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final int w = size!.width;
    _paintBackground(context, offset.x, offset.y, w);
    if (value != null) {
      _paintDeterminate(context, offset.x, offset.y, w);
    } else {
      _paintIndeterminate(context, offset.x, offset.y, w);
    }
  }

  void _ensureStylesCached() {
    if (_cachedBgStyle != null) return;
    _cachedBgStyle = TextStyle(color: _backgroundColor);
    _cachedFillStyle = TextStyle(color: _color);
  }

  void _paintBackground(PaintingContext context, int x, int y, int width) {
    if (width <= 0) return;
    context.writeString(x, y, '░' * width, _cachedBgStyle!);
  }

  void _paintDeterminate(PaintingContext context, int x, int y, int width) {
    final int filled = (value!.clamp(0.0, 1.0) * width).round();
    if (filled <= 0) return;
    context.writeString(x, y, '█' * filled, _cachedFillStyle!);
  }

  void _paintIndeterminate(PaintingContext context, int x, int y, int width) {
    final int blockWidth = (width * 0.3).round().clamp(1, width);
    final int maxStart = width - blockWidth;
    final int start = (animValue * maxStart).round().clamp(0, maxStart);
    context.writeString(x + start, y, '█' * blockWidth, _cachedFillStyle!);
  }
}
