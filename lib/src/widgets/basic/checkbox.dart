import '../../../radartui.dart';

class Checkbox extends StatefulWidget {
  const Checkbox({
    super.key,
    required this.value,
    this.onChanged,
    this.tristate = false,
    this.focusNode,
    this.activeColor,
    this.checkColor,
  });
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final FocusNode? focusNode;
  final Color? activeColor;
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

    if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
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

    // Force repaint if value changed
    if (oldValue != value) {
      checkbox.markNeedsLayout();
    }
  }
}

class RenderCheckbox extends RenderBox {
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

  bool get value => _value;
  set value(bool v) {
    _value = v;
    _invalidateCache();
  }

  bool get tristate => _tristate;
  set tristate(bool v) {
    _tristate = v;
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

  Color get checkColor => _checkColor;
  set checkColor(Color v) {
    _checkColor = v;
    _invalidateCache();
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
    // Checkbox is always 3x1 size
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
    for (int x = 0; x < 3; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, ' ', style);
    }
  }

  void _paintBorder(PaintingContext context, Offset offset) {
    final TextStyle style = _cachedBorderStyle!;
    context.buffer.writeStyled(offset.x, offset.y, '[', style);
    context.buffer.writeStyled(offset.x + 2, offset.y, ']', style);
  }

  void _paintIndicator(
      PaintingContext context, Offset offset, String checkChar) {
    context.buffer
        .writeStyled(offset.x + 1, offset.y, checkChar, _cachedIndicatorStyle!);
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return Color.brightBlack;
    } else if (value) {
      return activeColor;
    } else {
      return Color.black;
    }
  }

  Color _getForegroundColor() {
    if (!enabled) {
      return Color.brightBlack;
    } else if (value) {
      return checkColor;
    } else {
      return Color.white;
    }
  }

  String _getCheckChar() {
    if (!enabled) {
      return value ? '×' : '';
    } else if (value) {
      return '✓';
    } else {
      return '';
    }
  }
}
