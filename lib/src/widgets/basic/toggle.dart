import '../../../radartui.dart';

/// A boolean toggle switch (on/off).
///
/// Displays as a labeled indicator that flips between active and inactive
/// states. Calls [onChanged] with the new value when activated.
class Toggle extends StatefulWidget {
  /// Creates a [Toggle] with the given [value] and optional [onChanged].
  const Toggle({
    super.key,
    required this.value,
    this.onChanged,
    this.focusNode,
    this.activeColor,
    this.inactiveColor,
    this.label,
  });

  /// Whether the toggle is currently in the active (on) state.
  final bool value;

  /// Called when the user toggles the value.
  final ValueChanged<bool>? onChanged;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// The color of the toggle when in the active state.
  final Color? activeColor;

  /// The color of the indicator when in the inactive state.
  final Color? inactiveColor;

  /// An optional text label displayed beside the toggle.
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

/// Render object that paints a toggle switch with border, indicator, and optional label.
class RenderToggle extends RenderBox {
  /// Creates a [RenderToggle] with the given value and visual configuration.
  RenderToggle({
    required bool value,
    required bool focused,
    required bool enabled,
    required Color activeColor,
    required Color inactiveColor,
    String? label,
  })  : _value = value,
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

  /// Whether the toggle is in the active (on) state.
  bool get value => _value;

  /// Sets the toggle value and invalidates the paint cache.
  set value(bool v) {
    _value = v;
    _invalidateCache();
  }

  /// Whether the toggle currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates the paint cache.
  set focused(bool v) {
    _focused = v;
    _invalidateCache();
  }

  /// Whether the toggle is interactive.
  bool get enabled => _enabled;

  /// Sets the enabled state and invalidates the paint cache.
  set enabled(bool v) {
    _enabled = v;
    _invalidateCache();
  }

  /// The color when the toggle is active.
  Color get activeColor => _activeColor;

  /// Sets the active color and invalidates the paint cache.
  set activeColor(Color v) {
    _activeColor = v;
    _invalidateCache();
  }

  /// The color of the indicator when inactive.
  Color get inactiveColor => _inactiveColor;

  /// Sets the inactive color and invalidates the paint cache.
  set inactiveColor(Color v) {
    _inactiveColor = v;
    _invalidateCache();
  }

  /// An optional text label displayed beside the toggle.
  String? get label => _label;

  /// Sets the label and invalidates the paint cache.
  set label(String? v) {
    _label = v;
    _invalidateCache();
  }

  TextStyle? _cachedBackgroundStyle;
  TextStyle? _cachedBorderStyle;
  TextStyle? _cachedIndicatorStyle;
  TextStyle? _cachedLabelStyle;
  int _cachedLabelWidth = 0;
  String? _cachedLabelIdentity;

  void _invalidateCache() {
    _cachedBackgroundStyle = null;
    _cachedBorderStyle = null;
    _cachedIndicatorStyle = null;
    _cachedLabelStyle = null;
    _cachedLabelWidth = _computeLabelWidth();
    _cachedLabelIdentity = _label;
  }

  int _computeLabelWidth() {
    if (_label != null && _label!.isNotEmpty) {
      return stringWidth(_label!);
    }
    return 0;
  }

  int get _labelWidth {
    if (!identical(_label, _cachedLabelIdentity)) {
      _cachedLabelWidth = _computeLabelWidth();
      _cachedLabelIdentity = _label;
    }
    return _cachedLabelWidth;
  }

  int _calculateWidth() {
    const int toggleWidth = 3;
    if (label != null && label!.isNotEmpty) {
      return toggleWidth + 1 + _labelWidth;
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
    context.fillBackground(offset.x, offset.y, 3, style);
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
    context.writeString(offset.x + 4, offset.y, label!, _cachedLabelStyle!);
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
