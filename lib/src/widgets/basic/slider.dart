import '../../../radartui.dart';

class Slider extends StatefulWidget {
  const Slider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.divisions,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.label,
    this.focusNode,
  });

  final int value;
  final int min;
  final int max;
  final int? divisions;
  final ValueChanged<int>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String? label;
  final FocusNode? focusNode;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> with FocusableState<Slider> {
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    final int step = widget.divisions != null
        ? ((widget.max - widget.min) / widget.divisions!).round()
        : 1;

    if (event.code == KeyCode.arrowRight || event.code == KeyCode.arrowUp) {
      final int newValue = (widget.value + step).clamp(widget.min, widget.max);
      if (newValue != widget.value) {
        widget.onChanged!.call(newValue);
      }
    } else if (event.code == KeyCode.arrowLeft ||
        event.code == KeyCode.arrowDown) {
      final int newValue = (widget.value - step).clamp(widget.min, widget.max);
      if (newValue != widget.value) {
        widget.onChanged!.call(newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SliderRenderWidget(
      value: widget.value,
      min: widget.min,
      max: widget.max,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: widget.activeColor ?? Color.green,
      inactiveColor: widget.inactiveColor ?? Color.brightBlack,
      thumbColor: widget.thumbColor ?? Color.white,
      label: widget.label,
    );
  }
}

class _SliderRenderWidget extends RenderObjectWidget {
  const _SliderRenderWidget({
    required this.value,
    required this.min,
    required this.max,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbColor,
    this.label,
  });

  final int value;
  final int min;
  final int max;
  final bool focused;
  final bool enabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final String? label;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderSlider createRenderObject(BuildContext context) => RenderSlider(
        value: value,
        min: min,
        max: max,
        focused: focused,
        enabled: enabled,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        thumbColor: thumbColor,
        label: label,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderSlider;
    render.value = value;
    render.min = min;
    render.max = max;
    render.focused = focused;
    render.enabled = enabled;
    render.activeColor = activeColor;
    render.inactiveColor = inactiveColor;
    render.thumbColor = thumbColor;
    render.label = label;
  }
}

class RenderSlider extends RenderBox {
  RenderSlider({
    required int value,
    required int min,
    required int max,
    required bool focused,
    required bool enabled,
    required Color activeColor,
    required Color inactiveColor,
    required Color thumbColor,
    String? label,
  })  : _value = value,
        _min = min,
        _max = max,
        _focused = focused,
        _enabled = enabled,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor,
        _thumbColor = thumbColor,
        _label = label;

  int _value;
  int _min;
  int _max;
  bool _focused;
  bool _enabled;
  Color _activeColor;
  Color _inactiveColor;
  Color _thumbColor;
  String? _label;

  int get value => _value;
  set value(int v) {
    _value = v;
    _invalidateCache();
  }

  int get min => _min;
  set min(int v) {
    _min = v;
    _invalidateCache();
  }

  int get max => _max;
  set max(int v) {
    _max = v;
    _invalidateCache();
  }

  bool get focused => _focused;
  set focused(bool v) {
    _focused = v;
    _invalidateCache();
  }

  bool get enabled => _enabled;
  set enabled(bool v) {
    _enabled = v;
    _invalidateCache();
  }

  Color get activeColor => _activeColor;
  set activeColor(Color v) {
    _activeColor = v;
    _invalidateCache();
  }

  Color get inactiveColor => _inactiveColor;
  set inactiveColor(Color v) {
    _inactiveColor = v;
    _invalidateCache();
  }

  Color get thumbColor => _thumbColor;
  set thumbColor(Color v) {
    _thumbColor = v;
    _invalidateCache();
  }

  String? get label => _label;
  set label(String? v) {
    _label = v;
    _invalidateCache();
  }

  TextStyle? _cachedActiveTrackStyle;
  TextStyle? _cachedInactiveTrackStyle;
  TextStyle? _cachedThumbStyle;
  TextStyle? _cachedLabelStyle;

  void _invalidateCache() {
    _cachedActiveTrackStyle = null;
    _cachedInactiveTrackStyle = null;
    _cachedThumbStyle = null;
    _cachedLabelStyle = null;
  }

  int get _labelWidth =>
      (label != null && label!.isNotEmpty) ? 2 + stringWidth(label!) : 0;

  @override
  void performLayout(Constraints constraints) {
    size = Size(10 + _labelWidth, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final int w = size!.width;
    final int trackWidth = _trackWidth(w);
    final int thumbPos = _thumbPosition(trackWidth);
    _paintTrack(
        context, offset.x.toInt(), offset.y.toInt(), trackWidth, thumbPos);
    if (label != null && label!.isNotEmpty) {
      _paintLabel(context, offset.x.toInt() + trackWidth + 2, offset.y.toInt());
    }
  }

  void _ensureStylesCached() {
    if (_cachedActiveTrackStyle != null) return;
    final Color fg = enabled ? Color.white : Color.brightBlack;
    _cachedActiveTrackStyle = TextStyle(color: activeColor);
    _cachedInactiveTrackStyle = TextStyle(color: inactiveColor);
    _cachedThumbStyle = TextStyle(color: thumbColor);
    _cachedLabelStyle = TextStyle(color: fg);
  }

  int _trackWidth(int totalWidth) {
    return totalWidth - _labelWidth;
  }

  int _thumbPosition(int trackWidth) {
    final double ratio = max > min ? (value - min) / (max - min) : 0.0;
    return (ratio * (trackWidth - 1)).round().clamp(0, trackWidth - 1);
  }

  void _paintTrack(
      PaintingContext context, int x, int y, int trackWidth, int thumbPos) {
    for (int i = 0; i < trackWidth; i++) {
      final bool isThumb = i == thumbPos;
      final String ch = isThumb ? '●' : '─';
      final TextStyle style;
      if (isThumb) {
        style = _cachedThumbStyle!;
      } else if (i <= thumbPos) {
        style = _cachedActiveTrackStyle!;
      } else {
        style = _cachedInactiveTrackStyle!;
      }
      context.buffer.writeStyled(x + i, y, ch, style);
    }
  }

  void _paintLabel(PaintingContext context, int startX, int y) {
    final TextStyle style = _cachedLabelStyle!;
    int cx = startX;
    for (int i = 0; i < label!.length; i++) {
      final String ch = label![i];
      context.buffer.writeStyled(cx, y, ch, style);
      cx += charWidth(ch.codeUnitAt(0));
    }
  }
}
