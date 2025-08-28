import '../../../radartui.dart';

class Radio<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final FocusNode? focusNode;
  final Color? activeColor;
  final Color? checkColor;

  const Radio({
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.focusNode,
    this.activeColor,
    this.checkColor,
  });

  @override
  State<Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<Radio<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void didUpdateWidget(Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Force rebuild if selection state changed
    if (oldWidget.groupValue != widget.groupValue || 
        oldWidget.value != widget.value) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.code == KeyCode.enter || 
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onChanged!(widget.value);
    }
  }

  void _onTap() {
    if (widget.onChanged == null) return;
    widget.onChanged!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;
    
    return _RadioRenderWidget(
      selected: isSelected,
      focused: _focusNode.hasFocus,
      enabled: widget.onChanged != null,
      activeColor: widget.activeColor ?? Color.blue,
      checkColor: widget.checkColor ?? Color.white,
      onTap: _onTap,
    );
  }
}

class _RadioRenderWidget extends RenderObjectWidget {
  final bool selected;
  final bool focused;
  final bool enabled;
  final Color activeColor;
  final Color checkColor;
  final VoidCallback? onTap;

  const _RadioRenderWidget({
    required this.selected,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.checkColor,
    this.onTap,
  });

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
  bool selected;
  bool focused;
  bool enabled;
  Color activeColor;
  Color checkColor;
  VoidCallback? onTap;

  RenderRadio({
    required this.selected,
    required this.focused,
    required this.enabled,
    required this.activeColor,
    required this.checkColor,
    this.onTap,
  });

  @override
  void performLayout(Constraints constraints) {
    // Radio is always 3x1 size
    size = const Size(3, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final backgroundColor = _getBackgroundColor();
    final foregroundColor = _getForegroundColor();
    final borderColor = focused ? activeColor : (enabled ? Color.white : Color.brightBlack);

    // Draw radio background
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
      '(',
      TextStyle(color: borderColor, backgroundColor: backgroundColor),
    );
    context.buffer.writeStyled(
      offset.x + 2,
      offset.y,
      ')',
      TextStyle(color: borderColor, backgroundColor: backgroundColor),
    );

    // Draw selection indicator
    final selectionChar = _getSelectionChar();
    if (selectionChar.isNotEmpty) {
      context.buffer.writeStyled(
        offset.x + 1,
        offset.y,
        selectionChar,
        TextStyle(color: foregroundColor, backgroundColor: backgroundColor),
      );
    }
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