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
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      final newValue = !widget.value;
      widget.onChanged!(newValue);
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _CheckboxRenderWidget(
      value: widget.value,
      tristate: widget.tristate,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: widget.activeColor ?? Color.blue,
      checkColor: widget.checkColor ?? Color.white,
    );
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
    required this.value,
    required this.tristate,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.checkColor,
  });
  bool value;
  bool tristate;
  bool focused;
  bool enabled;
  Color activeColor;
  Color checkColor;

  @override
  void performLayout(Constraints constraints) {
    // Checkbox is always 3x1 size
    size = const Size(3, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final backgroundColor = _getBackgroundColor();
    final foregroundColor = _getForegroundColor();
    final borderColor =
        focused ? activeColor : (enabled ? Color.white : Color.brightBlack);

    // Draw checkbox background
    for (int x = 0; x < 3; x++) {
      context.buffer.writeStyled(
        offset.x + x,
        offset.y,
        ' ',
        TextStyle(backgroundColor: backgroundColor),
      );
    }

    // Draw border
    context.buffer.writeStyled(
      offset.x,
      offset.y,
      '[',
      TextStyle(color: borderColor, backgroundColor: backgroundColor),
    );
    context.buffer.writeStyled(
      offset.x + 2,
      offset.y,
      ']',
      TextStyle(color: borderColor, backgroundColor: backgroundColor),
    );

    // Draw check mark
    final checkChar = _getCheckChar();
    if (checkChar.isNotEmpty) {
      context.buffer.writeStyled(
        offset.x + 1,
        offset.y,
        checkChar,
        TextStyle(color: foregroundColor, backgroundColor: backgroundColor),
      );
    }
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
