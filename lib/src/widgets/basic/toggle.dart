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
    required this.value,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.inactiveColor,
    this.label,
  });

  bool value;
  bool focused;
  bool enabled;
  Color activeColor;
  Color inactiveColor;
  String? label;

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
    final backgroundColor = _getBackgroundColor();
    final indicatorColor = _getIndicatorColor();
    final borderColor = _getBorderColor();

    _paintBackground(context, offset, backgroundColor);
    _paintBorder(context, offset, borderColor, backgroundColor);
    _paintIndicator(context, offset, indicatorColor, backgroundColor);
    _paintLabel(context, offset);
  }

  void _paintBackground(
    PaintingContext context,
    Offset offset,
    Color backgroundColor,
  ) {
    for (int x = 0; x < 3; x++) {
      context.buffer.writeStyled(
        offset.x + x,
        offset.y,
        ' ',
        TextStyle(backgroundColor: backgroundColor),
      );
    }
  }

  void _paintBorder(
    PaintingContext context,
    Offset offset,
    Color borderColor,
    Color backgroundColor,
  ) {
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
  }

  void _paintIndicator(
    PaintingContext context,
    Offset offset,
    Color indicatorColor,
    Color backgroundColor,
  ) {
    final indicatorChar = value ? '●' : '○';
    context.buffer.writeStyled(
      offset.x + 1,
      offset.y,
      indicatorChar,
      TextStyle(color: indicatorColor, backgroundColor: backgroundColor),
    );
  }

  void _paintLabel(PaintingContext context, Offset offset) {
    if (label == null || label!.isEmpty) return;
    final int labelX = offset.x + 4;
    final labelColor = enabled ? Color.white : Color.brightBlack;
    for (int i = 0; i < label!.length; i++) {
      context.buffer.writeStyled(
        labelX + i,
        offset.y,
        label![i],
        TextStyle(color: labelColor),
      );
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
