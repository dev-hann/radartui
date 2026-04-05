import '../../../radartui.dart';

/// A circular (ring) progress indicator.
///
/// Displays a rotating arc or static fill to represent progress [value] (0.0–1.0).
/// Use [CircularProgressIndicator.adaptive] for platform-specific styling.
class CircularProgressIndicator extends StatefulWidget {
  /// Creates a [CircularProgressIndicator].
  ///
  /// The [speed] controls how fast the spinner rotates. Override [frames] to
  /// provide custom animation frames (defaults to Braille spinner characters).
  const CircularProgressIndicator({
    super.key,
    this.color,
    this.backgroundColor,
    this.label,
    this.speed = const Duration(milliseconds: 80),
    this.frames,
  });

  /// The color of the spinner character.
  final Color? color;

  /// The background color behind the spinner.
  final Color? backgroundColor;

  /// An optional label displayed to the right of the spinner.
  final String? label;

  /// The duration each frame is displayed before advancing.
  final Duration speed;

  /// Custom animation frames; defaults to a Braille-dot spinner sequence.
  final List<String>? frames;

  @override
  State<CircularProgressIndicator> createState() =>
      _CircularProgressIndicatorState();
}

class _CircularProgressIndicatorState extends State<CircularProgressIndicator> {
  static const List<String> _defaultFrames = [
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  ];

  int _frameIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.speed,
    );
    _controller.addStatusListener(_onStatusChanged);
    _controller.addListener(_onFrame);
    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speed != oldWidget.speed) {
      _controller.dispose();
      _controller = AnimationController(duration: widget.speed);
      _controller.addStatusListener(_onStatusChanged);
      _controller.addListener(_onFrame);
      _controller.forward();
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _frameIndex =
          (_frameIndex + 1) % (widget.frames ?? _defaultFrames).length;
      _controller.forward(from: 0.0);
    }
  }

  void _onFrame() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onFrame);
    _controller.removeStatusListener(_onStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = widget.frames ?? _defaultFrames;
    final currentFrame = frames[_frameIndex];

    return _CircularProgressIndicatorRenderWidget(
      frame: currentFrame,
      color: widget.color ?? Color.green,
      backgroundColor: widget.backgroundColor,
      label: widget.label,
    );
  }
}

class _CircularProgressIndicatorRenderWidget extends RenderObjectWidget {
  const _CircularProgressIndicatorRenderWidget({
    required this.frame,
    required this.color,
    this.backgroundColor,
    this.label,
  });

  final String frame;
  final Color color;
  final Color? backgroundColor;
  final String? label;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderCircularProgressIndicator createRenderObject(BuildContext context) =>
      RenderCircularProgressIndicator(
        frame: frame,
        color: color,
        backgroundColor: backgroundColor,
        label: label,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderCircularProgressIndicator;
    render.frame = frame;
    render.color = color;
    render.backgroundColor = backgroundColor;
    render.label = label;
  }
}

/// The render object for [CircularProgressIndicator], which paints a single
/// animation frame character and optional label.
class RenderCircularProgressIndicator extends RenderBox {
  /// Creates a [RenderCircularProgressIndicator].
  RenderCircularProgressIndicator({
    required String frame,
    required Color color,
    Color? backgroundColor,
    String? label,
  })  : _frame = frame,
        _color = color,
        _backgroundColor = backgroundColor,
        _label = label;

  String _frame;

  /// The current animation frame character to display.
  String get frame => _frame;

  /// Sets the animation frame and marks layout as needed.
  set frame(String value) {
    if (_frame == value) return;
    _frame = value;
    markNeedsLayout();
  }

  Color _color;

  /// The color of the spinner character.
  Color get color => _color;

  /// Sets the spinner color and invalidates the cached style.
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    _cachedStyle = null;
    markNeedsPaint();
  }

  Color? _backgroundColor;

  /// The background color behind the spinner.
  Color? get backgroundColor => _backgroundColor;

  /// Sets the background color and invalidates the cached style.
  set backgroundColor(Color? value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    _cachedStyle = null;
    markNeedsPaint();
  }

  String? _label;

  /// An optional label rendered to the right of the spinner.
  String? get label => _label;

  /// Sets the label and marks layout as needed.
  set label(String? value) {
    if (_label == value) return;
    _label = value;
    markNeedsLayout();
  }

  TextStyle? _cachedStyle;

  @override
  void performLayout(Constraints constraints) {
    final int labelLen =
        (label != null && label!.isNotEmpty) ? 1 + stringWidth(label!) : 0;
    size = Size(1 + labelLen, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _cachedStyle ??=
        TextStyle(color: _color, backgroundColor: _backgroundColor);
    final TextStyle style = _cachedStyle!;
    context.buffer.writeStyled(offset.x, offset.y, frame, style);

    if (label != null && label!.isNotEmpty) {
      context.writeString(offset.x + 2, offset.y, label!, style);
    }
  }
}
