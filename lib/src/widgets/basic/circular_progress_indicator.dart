import '../../../radartui.dart';

class CircularProgressIndicator extends StatefulWidget {
  const CircularProgressIndicator({
    super.key,
    this.color,
    this.backgroundColor,
    this.label,
    this.speed = const Duration(milliseconds: 80),
    this.frames,
  });

  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final Duration speed;
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

class RenderCircularProgressIndicator extends RenderBox {
  RenderCircularProgressIndicator({
    required this.frame,
    required this.color,
    this.backgroundColor,
    this.label,
  });

  String frame;
  Color color;
  Color? backgroundColor;
  String? label;

  @override
  void performLayout(Constraints constraints) {
    final int labelLen =
        (label != null && label!.isNotEmpty) ? 1 + label!.length : 0;
    size = Size(1 + labelLen, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final TextStyle style = TextStyle(
      color: color,
      backgroundColor: backgroundColor,
    );
    context.buffer.writeStyled(offset.x, offset.y, frame, style);

    if (label != null && label!.isNotEmpty) {
      int cx = offset.x + 2;
      for (int i = 0; i < label!.length; i++) {
        final String ch = label![i];
        context.buffer.writeStyled(cx, offset.y, ch, style);
        cx += charWidth(ch.codeUnitAt(0));
      }
    }
  }
}
