import '../../../radartui.dart';
import '../../foundation/drawing_constants.dart';

/// A material-design checkbox that toggles between checked (✓) and unchecked states.
///
/// Responds to [KeyCode.space] and [KeyCode.enter] to toggle. Wrap in
/// [Focus] to enable keyboard navigation.
class Checkbox extends StatefulWidget {
  /// Creates a [Checkbox] with the given [value] and optional [onChanged].
  const Checkbox({
    super.key,
    required this.value,
    this.onChanged,
    this.tristate = false,
    this.focusNode,
    this.activeColor,
    this.checkColor,
  });

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called when the user toggles the checkbox.
  final ValueChanged<bool?>? onChanged;

  /// Whether the checkbox supports a third "null" state.
  final bool tristate;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// The color of the filled checkbox when checked.
  final Color? activeColor;

  /// The color of the check mark inside the box.
  final Color? checkColor;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> with FocusableState<Checkbox> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      initialValue: widget.value ? 1.0 : 0.0,
    );
    _colorAnim = ColorTween(
      begin: Color.black,
      end: widget.activeColor ?? Color.blue,
    ).animate(_controller);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.isActivationKey) {
      final newValue = !widget.value;
      widget.onChanged!(newValue);
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    if (oldWidget.activeColor != widget.activeColor) {
      _colorAnim = ColorTween(
        begin: Color.black,
        end: widget.activeColor ?? Color.blue,
      ).animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBackgroundColor = _colorAnim.value;

    return _CheckboxRenderWidget(
      value: widget.value,
      tristate: widget.tristate,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: currentBackgroundColor,
      checkColor: widget.checkColor ?? Color.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CheckboxRenderWidget extends RenderObjectWidget {
  const _CheckboxRenderWidget({
    required this.value,
    required this.tristate,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.checkColor,
  });
  final bool value;
  final bool tristate;
  final bool focused;
  final bool enabled;
  final Color activeColor;
  final Color checkColor;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderCheckbox createRenderObject(BuildContext context) => RenderCheckbox(
        value: value,
        tristate: tristate,
        focused: focused,
        enabled: enabled,
        activeColor: activeColor,
        checkColor: checkColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final checkbox = renderObject as RenderCheckbox;
    final oldValue = checkbox.value;

    checkbox.value = value;
    checkbox.tristate = tristate;
    checkbox.focused = focused;
    checkbox.enabled = enabled;
    checkbox.activeColor = activeColor;
    checkbox.checkColor = checkColor;

    if (oldValue != value) {
      checkbox.markNeedsLayout();
    }
  }
}

/// Render object that paints a checkbox with border, fill, and check indicator.
class RenderCheckbox extends RenderBox {
  /// Creates a [RenderCheckbox] with the given value and visual state.
  RenderCheckbox({
    required bool value,
    required bool tristate,
    required bool focused,
    required bool enabled,
    required Color activeColor,
    required Color checkColor,
  })  : _value = value,
        _tristate = tristate,
        _focused = focused,
        _enabled = enabled,
        _activeColor = activeColor,
        _checkColor = checkColor;

  bool _value;
  bool _tristate;
  bool _focused;
  bool _enabled;
  Color _activeColor;
  Color _checkColor;

  /// Whether the checkbox is currently checked.
  bool get value => _value;

  /// Sets the checked state and invalidates the paint cache.
  set value(bool v) {
    if (_value == v) return;
    _value = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether the checkbox supports a tri-state (null) value.
  bool get tristate => _tristate;

  /// Sets the tristate flag and invalidates the paint cache.
  set tristate(bool v) {
    if (_tristate == v) return;
    _tristate = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether the checkbox currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates the paint cache.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether the checkbox is interactive.
  bool get enabled => _enabled;

  /// Sets the enabled state and invalidates the paint cache.
  set enabled(bool v) {
    if (_enabled == v) return;
    _enabled = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the filled background when checked.
  Color get activeColor => _activeColor;

  /// Sets the active color and invalidates the paint cache.
  set activeColor(Color v) {
    if (_activeColor == v) return;
    _activeColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the check mark character.
  Color get checkColor => _checkColor;

  /// Sets the check color and invalidates the paint cache.
  set checkColor(Color v) {
    if (_checkColor == v) return;
    _checkColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _cachedBackgroundStyle;
  TextStyle? _cachedBorderStyle;
  TextStyle? _cachedIndicatorStyle;

  void _invalidateCache() {
    _cachedBackgroundStyle = null;
    _cachedBorderStyle = null;
    _cachedIndicatorStyle = null;
  }

  @override
  void performLayout(Constraints constraints) {
    size = const Size(3, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    _paintBackground(context, offset);
    _paintBorder(context, offset);
    final String checkChar = _getCheckChar();
    if (checkChar.isNotEmpty) {
      _paintIndicator(context, offset, checkChar);
    }
  }

  void _ensureStylesCached() {
    if (_cachedBackgroundStyle != null) return;
    final Color bg = _getBackgroundColor();
    final Color fg = _getForegroundColor();
    final Color border =
        focused ? activeColor : (enabled ? Color.white : Color.brightBlack);
    _cachedBackgroundStyle = TextStyle(backgroundColor: bg);
    _cachedBorderStyle = TextStyle(color: border, backgroundColor: bg);
    _cachedIndicatorStyle = TextStyle(color: fg, backgroundColor: bg);
  }

  void _paintBackground(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBackgroundStyle!;
    context.fillBackground(offset.x, offset.y, 3, style);
  }

  void _paintBorder(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBorderStyle!;
    const String borderChars =
        '${BoxDrawingConstants.leftTee}${BoxDrawingConstants.rightTee}';
    context.writeString(offset.x, offset.y, borderChars, style);
  }

  void _paintIndicator(
      PaintingContext context, Offset offset, String checkChar) {
    context.buffer
        .writeStyled(offset.x + 1, offset.y, checkChar, _cachedIndicatorStyle!);
  }

  Color _getBackgroundColor() {
    if (!enabled) return Color.brightBlack;
    if (value) return activeColor;
    return Color.black;
  }

  Color _getForegroundColor() {
    if (!enabled) return Color.brightBlack;
    if (value) return checkColor;
    return Color.white;
  }

  String _getCheckChar() {
    if (!enabled) return value ? '×' : '';
    if (value) return '✓';
    return '';
  }
}
