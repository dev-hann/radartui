import '../../../radartui.dart';

class Radio<T> extends StatefulWidget {
  const Radio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.focusNode,
    this.activeColor,
    this.checkColor,
  });
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final FocusNode? focusNode;
  final Color? activeColor;
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
      _colorAnim = ColorTween(
        begin: Color.black,
        end: widget.activeColor ?? Color.blue,
      ).animate(_controller);
    }
  }

  void _onTap() {
    if (widget.onChanged == null) return;
    widget.onChanged!(widget.value);
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
    required this.checkColor,
    this.onTap,
  });
  final bool selected;
  final bool focused;
  final bool enabled;
  final Color activeColor;
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
    radio.checkColor = checkColor;
    radio.onTap = onTap;

    // Force repaint if selection state changed
    if (oldSelected != selected) {
      radio.markNeedsLayout();
    }
  }
}

class RenderRadio extends RenderBox {
  RenderRadio({
    required this.selected,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.checkColor,
    this.onTap,
  });
  bool selected;
  bool focused;
  bool enabled;
  Color activeColor;
  Color checkColor;
  VoidCallback? onTap;

  @override
  void performLayout(Constraints constraints) {
    // Radio is always 3x1 size
    size = const Size(3, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final backgroundColor = _getBackgroundColor();
    final foregroundColor = _getForegroundColor();
    final borderColor =
        focused ? activeColor : (enabled ? Color.white : Color.brightBlack);

    _paintBackground(context, offset, backgroundColor);
    _paintBorder(context, offset, borderColor, backgroundColor);

    final selectionChar = _getSelectionChar();
    if (selectionChar.isNotEmpty) {
      _paintIndicator(
          context, offset, selectionChar, foregroundColor, backgroundColor);
    }
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
    final borderStyle =
        TextStyle(color: borderColor, backgroundColor: backgroundColor);
    context.buffer.writeStyled(offset.x, offset.y, '(', borderStyle);
    context.buffer.writeStyled(offset.x + 2, offset.y, ')', borderStyle);
  }

  void _paintIndicator(
    PaintingContext context,
    Offset offset,
    String selectionChar,
    Color foregroundColor,
    Color backgroundColor,
  ) {
    context.buffer.writeStyled(
      offset.x + 1,
      offset.y,
      selectionChar,
      TextStyle(color: foregroundColor, backgroundColor: backgroundColor),
    );
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return Color.brightBlack;
    } else if (selected) {
      return activeColor;
    } else {
      return Color.black;
    }
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

  String _getSelectionChar() {
    if (!enabled) {
      return selected ? '×' : '';
    } else if (selected) {
      return '●';
    } else {
      return '';
    }
  }
}
