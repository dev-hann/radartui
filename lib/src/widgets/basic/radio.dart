import '../../../radartui.dart';
import '../../foundation/drawing_constants.dart';

/// A single radio button that selects one value from a mutually exclusive group.
///
/// Use [groupValue] to identify the currently selected value for the group.
/// When the user activates this radio, [onChanged] is called with [value].
class Radio<T> extends StatefulWidget {
  /// Creates a [Radio] with the given [value] and [groupValue].
  const Radio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.focusNode,
    this.activeColor,
    this.checkColor,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value in the radio group.
  final T? groupValue;

  /// Called when the user selects this radio button.
  final ValueChanged<T?>? onChanged;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// The color of the filled indicator when selected.
  final Color? activeColor;

  /// The color of the check dot inside the indicator.
  final Color? checkColor;

  @override
  State<Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<Radio<T>> with FocusableState<Radio<T>> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    final isSelected = widget.value == widget.groupValue;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      initialValue: isSelected ? 1.0 : 0.0,
    );
    _colorAnim = _createColorAnimation(_controller);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.isActivationKey) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasSelected = oldWidget.value == oldWidget.groupValue;
    final isSelected = widget.value == widget.groupValue;

    if (wasSelected != isSelected) {
      if (isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    if (oldWidget.activeColor != widget.activeColor) {
      _colorAnim = _createColorAnimation(_controller);
    }
  }

  void _onTap() {
    if (widget.onChanged == null) return;
    widget.onChanged!(widget.value);
  }

  Animation<Color> _createColorAnimation(AnimationController controller) {
    return ColorTween(
      begin: Color.black,
      end: widget.activeColor ?? Color.blue,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;
    final currentBackgroundColor = _colorAnim.value;

    return _RadioRenderWidget(
      selected: isSelected,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: currentBackgroundColor,
      focusColor: widget.activeColor ?? Color.blue,
      checkColor: widget.checkColor ?? Color.white,
      onTap: _onTap,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _RadioRenderWidget extends RenderObjectWidget {
  const _RadioRenderWidget({
    required this.selected,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.focusColor,
    required this.checkColor,
    this.onTap,
  });
  final bool selected;
  final bool focused;
  final bool enabled;
  final Color activeColor;
  final Color focusColor;
  final Color checkColor;
  final VoidCallback? onTap;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderRadio createRenderObject(BuildContext context) => RenderRadio(
        selected: selected,
        focused: focused,
        enabled: enabled,
        activeColor: activeColor,
        focusColor: focusColor,
        checkColor: checkColor,
        onTap: onTap,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final radio = renderObject as RenderRadio;
    final oldSelected = radio.selected;

    radio.selected = selected;
    radio.focused = focused;
    radio.enabled = enabled;
    radio.activeColor = activeColor;
    radio.focusColor = focusColor;
    radio.checkColor = checkColor;
    radio.onTap = onTap;

    if (oldSelected != selected) {
      radio.markNeedsLayout();
    }
  }
}

/// Render object that paints a radio button with border, fill, and indicator.
class RenderRadio extends RenderBox {
  /// Creates a [RenderRadio] with the given selection and visual state.
  RenderRadio({
    required bool selected,
    required bool focused,
    required bool enabled,
    required Color activeColor,
    required Color focusColor,
    required Color checkColor,
    VoidCallback? onTap,
  })  : _selected = selected,
        _focused = focused,
        _enabled = enabled,
        _activeColor = activeColor,
        _focusColor = focusColor,
        _checkColor = checkColor,
        _onTap = onTap;

  bool _selected;
  bool _focused;
  bool _enabled;
  Color _activeColor;
  Color _focusColor;
  Color _checkColor;
  VoidCallback? _onTap;

  /// Whether this radio is currently selected.
  bool get selected => _selected;

  /// Sets the selection state and invalidates the paint cache.
  set selected(bool v) {
    if (_selected == v) return;
    _selected = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether this radio currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates the paint cache.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether this radio is interactive.
  bool get enabled => _enabled;

  /// Sets the enabled state and invalidates the paint cache.
  set enabled(bool v) {
    if (_enabled == v) return;
    _enabled = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the filled indicator when selected.
  Color get activeColor => _activeColor;

  /// Sets the active color and invalidates the paint cache.
  set activeColor(Color v) {
    if (_activeColor == v) return;
    _activeColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The border color when focused.
  Color get focusColor => _focusColor;

  /// Sets the focus color and invalidates the paint cache.
  set focusColor(Color v) {
    if (_focusColor == v) return;
    _focusColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the check dot.
  Color get checkColor => _checkColor;

  /// Sets the check color and invalidates the paint cache.
  set checkColor(Color v) {
    if (_checkColor == v) return;
    _checkColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// An optional tap callback.
  VoidCallback? get onTap => _onTap;

  /// Sets the tap callback.
  set onTap(VoidCallback? v) {
    _onTap = v;
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
    final String selectionChar = _getSelectionChar();
    if (selectionChar.isNotEmpty) {
      _paintIndicator(context, offset, selectionChar);
    }
  }

  void _ensureStylesCached() {
    if (_cachedBackgroundStyle != null) return;
    final Color bg = _getBackgroundColor();
    final Color fg = _getForegroundColor();
    final Color border =
        focused ? focusColor : (enabled ? Color.white : Color.brightBlack);
    _cachedBackgroundStyle = TextStyle(backgroundColor: bg);
    _cachedBorderStyle = TextStyle(color: border, backgroundColor: bg);
    _cachedIndicatorStyle = TextStyle(color: fg, backgroundColor: bg);
  }

  void _paintBackground(PaintingContext context, Offset offset) {
    context.fillBackground(
      offset.x,
      offset.y,
      3,
      _cachedBackgroundStyle!,
    );
  }

  void _paintBorder(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBorderStyle!;
    const String borderChars =
        '${BoxDrawingConstants.leftTee}${BoxDrawingConstants.rightTee}';
    context.writeString(offset.x, offset.y, borderChars, style);
  }

  void _paintIndicator(
      PaintingContext context, Offset offset, String selectionChar) {
    context.buffer.writeStyled(
        offset.x + 1, offset.y, selectionChar, _cachedIndicatorStyle!);
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return Color.brightBlack;
    }
    return activeColor;
  }

  Color _getForegroundColor() {
    if (!enabled) {
      return Color.brightBlack;
    } else if (selected) {
      return checkColor;
    } else {
      return Color.white;
    }
  }

  String _getSelectionChar() =>
      !enabled ? (selected ? '×' : '') : (selected ? '●' : '');
}
