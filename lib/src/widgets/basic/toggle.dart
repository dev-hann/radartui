import '../../../radartui.dart';

class Toggle extends StatefulWidget {
  const Toggle({
    super.key,
    required this.value,
    this.onChanged,
    this.focusNode,
    this.activeColor,
    this.inactiveColor,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final FocusNode? focusNode;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? label;

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> with FocusableState<Toggle> {
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ToggleRenderWidget(
      value: widget.value,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: widget.activeColor ?? Color.green,
      inactiveColor: widget.inactiveColor ?? Color.brightBlack,
      label: widget.label,
    );
  }
}

class _ToggleRenderWidget extends RenderObjectWidget {
  const _ToggleRenderWidget({
    required this.value,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.inactiveColor,
    this.label,
  });

  final bool value;
  final bool focused;
  final bool enabled;
  final Color activeColor;
  final Color inactiveColor;
  final String? label;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderToggle createRenderObject(BuildContext context) => RenderToggle(
    value: value,
    focused: focused,
    enabled: enabled,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    label: label,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final toggle = renderObject as RenderToggle;
    final oldValue = toggle.value;

    toggle.value = value;
    toggle.focused = focused;
    toggle.enabled = enabled;
    toggle.activeColor = activeColor;
    toggle.inactiveColor = inactiveColor;
    toggle.label = label;

    if (oldValue != value) {
      toggle.markNeedsLayout();
    }
  }
}

class RenderToggle extends RenderBox {
  RenderToggle({
    required bool value,
    required bool focused,
    required bool enabled,
    required Color activeColor,
    required Color inactiveColor,
    String? label,
  }) : _value = value,
       _focused = focused,
       _enabled = enabled,
       _activeColor = activeColor,
       _inactiveColor = inactiveColor,
       _label = label;

  bool _value;
  bool _focused;
  bool _enabled;
  Color _activeColor;
  Color _inactiveColor;
  String? _label;

  bool get value => _value;
  set value(bool v) {
    _value = v;
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

  String? get label => _label;
  set label(String? v) {
    _label = v;
    _invalidateCache();
  }

  TextStyle? _cachedBackgroundStyle;
  TextStyle? _cachedBorderStyle;
  TextStyle? _cachedIndicatorStyle;
  TextStyle? _cachedLabelStyle;

  void _invalidateCache() {
    _cachedBackgroundStyle = null;
    _cachedBorderStyle = null;
    _cachedIndicatorStyle = null;
    _cachedLabelStyle = null;
  }

  int _calculateWidth() {
    const int toggleWidth = 3;
    if (label != null && label!.isNotEmpty) {
      return toggleWidth + 1 + label!.length;
    }
    return toggleWidth;
  }

  @override
  void performLayout(Constraints constraints) {
    size = Size(_calculateWidth(), 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    _paintBackground(context, offset);
    _paintBorder(context, offset);
    _paintIndicator(context, offset);
    _paintLabel(context, offset);
  }

  void _ensureStylesCached() {
    if (_cachedBackgroundStyle != null) return;
    final Color bg = _getBackgroundColor();
    final Color indicator = _getIndicatorColor();
    final Color border = _getBorderColor();
    final Color labelColor = enabled ? Color.white : Color.brightBlack;
    _cachedBackgroundStyle = TextStyle(backgroundColor: bg);
    _cachedBorderStyle = TextStyle(color: border, backgroundColor: bg);
    _cachedIndicatorStyle = TextStyle(color: indicator, backgroundColor: bg);
    _cachedLabelStyle = TextStyle(color: labelColor);
  }

  void _paintBackground(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBackgroundStyle!;
    for (int x = 0; x < 3; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, ' ', style);
    }
  }

  void _paintBorder(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBorderStyle!;
    context.buffer.writeStyled(offset.x, offset.y, '[', style);
    context.buffer.writeStyled(offset.x + 2, offset.y, ']', style);
  }

  void _paintIndicator(PaintingContext context, Offset offset) {
    final String indicatorChar = value ? '●' : '○';
    context.buffer.writeStyled(
      offset.x + 1,
      offset.y,
      indicatorChar,
      _cachedIndicatorStyle!,
    );
  }

  void _paintLabel(PaintingContext context, Offset offset) {
    if (label == null || label!.isEmpty) return;
    final int labelX = offset.x + 4;
    final TextStyle style = _cachedLabelStyle!;
    for (int i = 0; i < label!.length; i++) {
      context.buffer.writeStyled(labelX + i, offset.y, label![i], style);
    }
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return Color.black;
    } else if (value) {
      return activeColor;
    } else {
      return Color.black;
    }
  }

  Color _getIndicatorColor() {
    if (!enabled) {
      return Color.brightBlack;
    } else if (value) {
      return Color.white;
    } else {
      return inactiveColor;
    }
  }

  Color _getBorderColor() {
    if (focused) {
      return activeColor;
    } else if (!enabled) {
      return Color.brightBlack;
    } else {
      return Color.white;
    }
  }
}
