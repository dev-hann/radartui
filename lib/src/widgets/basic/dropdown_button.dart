import '../../../radartui.dart';

/// A data model for a single option in a [DropdownButton].
///
/// Each item has a [value] of type [T], a display [label], and an [enabled] flag.
class DropdownMenuItem<T> {
  const DropdownMenuItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// A dropdown selector that lets the user choose one item from a list.
///
/// Displays the currently selected [value] and opens a popup menu when activated.
/// Use [hint] to show placeholder text when no value is selected.
class DropdownButton<T> extends StatefulWidget {
  const DropdownButton({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint,
    this.focusNode,
    this.focusColor,
    this.backgroundColor,
    this.dropdownColor,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final FocusNode? focusNode;
  final Color? focusColor;
  final Color? backgroundColor;
  final Color? dropdownColor;

  @override
  State<DropdownButton<T>> createState() => _DropdownButtonState<T>();
}

class _DropdownButtonState<T> extends State<DropdownButton<T>>
    with FocusableState<DropdownButton<T>> {
  bool _isOpen = false;
  int _selectedIndex = 0;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  int get _currentValueIndex {
    if (widget.value == null) return -1;
    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].value == widget.value) return i;
    }
    return -1;
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;
    if (!_isOpen) {
      _handleClosedKeyEvent(event);
    } else {
      _handleOpenKeyEvent(event);
    }
  }

  void _handleClosedKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
      setState(() {
        _isOpen = true;
        focusNode.trapFocus = true;
        _selectedIndex = _currentValueIndex >= 0 ? _currentValueIndex : 0;
      });
    }
  }

  void _handleOpenKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, widget.items.length - 1);
      });
    } else if (event.code == KeyCode.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, widget.items.length - 1);
      });
    } else if (event.code == KeyCode.enter) {
      _activateSelectedItem();
    } else if (event.code == KeyCode.escape) {
      _closeDropdown();
    }
  }

  void _activateSelectedItem() {
    final DropdownMenuItem<T> item = widget.items[_selectedIndex];
    if (item.enabled) {
      widget.onChanged?.call(item.value);
      _closeDropdown();
    }
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
      focusNode.trapFocus = false;
    });
  }

  @override
  void onFocusChange(bool focused) {
    super.onFocusChange(focused);
    if (!focused && _isOpen) _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    final int currentIdx = _currentValueIndex;
    final String displayText =
        currentIdx >= 0 ? widget.items[currentIdx].label : (widget.hint ?? '');

    return Column(
      children: [
        _DropdownButtonRenderWidget(
          text: displayText,
          focused: hasFocus,
          isOpen: _isOpen,
          enabled: widget.onChanged != null,
          focusColor: widget.focusColor ?? Color.cyan,
          backgroundColor: widget.backgroundColor ?? Color.brightBlack,
        ),
        if (_isOpen)
          _DropdownMenuRenderWidget(
            items: widget.items,
            selectedIndex: _selectedIndex,
            dropdownColor: widget.dropdownColor ?? Color.black,
            focusColor: widget.focusColor ?? Color.cyan,
          ),
      ],
    );
  }
}

class _DropdownButtonRenderWidget extends RenderObjectWidget {
  const _DropdownButtonRenderWidget({
    required this.text,
    required this.focused,
    required this.isOpen,
    required this.enabled,
    required this.focusColor,
    required this.backgroundColor,
  });

  final String text;
  final bool focused;
  final bool isOpen;
  final bool enabled;
  final Color focusColor;
  final Color backgroundColor;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderDropdownButton createRenderObject(BuildContext context) =>
      RenderDropdownButton(
        text: text,
        focused: focused,
        isOpen: isOpen,
        enabled: enabled,
        focusColor: focusColor,
        backgroundColor: backgroundColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderDropdownButton;
    render.text = text;
    render.focused = focused;
    render.isOpen = isOpen;
    render.enabled = enabled;
    render.focusColor = focusColor;
    render.backgroundColor = backgroundColor;
  }
}

class RenderDropdownButton extends RenderBox {
  RenderDropdownButton({
    required this.text,
    required this.focused,
    required this.isOpen,
    required this.enabled,
    required this.focusColor,
    required this.backgroundColor,
  });

  String text;
  bool focused;
  bool isOpen;
  bool enabled;
  Color focusColor;
  Color backgroundColor;

  int get _textWidth => stringWidth(text);

  @override
  void performLayout(Constraints constraints) {
    size = Size(_textWidth + 4, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Color bgColor = focused ? focusColor : backgroundColor;
    final Color fgColor = enabled ? Color.white : Color.brightBlack;
    final TextStyle bgStyle = TextStyle(backgroundColor: bgColor);
    final TextStyle fgBgStyle =
        TextStyle(color: fgColor, backgroundColor: bgColor);
    final int textW = _textWidth;
    _fillBackground(
        context, offset.x.toInt(), offset.y.toInt(), textW + 3, bgStyle);
    final int cx = _paintChars(
        context, offset.x.toInt() + 1, offset.y.toInt(), text, fgBgStyle);
    final String arrow = isOpen ? ' ▲' : ' ▼';
    _paintChars(context, cx, offset.y.toInt(), arrow, fgBgStyle);
  }

  void _fillBackground(
      PaintingContext context, int x, int y, int width, TextStyle style) {
    for (int i = 0; i < width; i++) {
      context.buffer.writeStyled(x + i, y, ' ', style);
    }
  }

  int _paintChars(PaintingContext context, int startX, int y, String text,
      TextStyle style) {
    int cx = startX;
    for (int i = 0; i < text.length; i++) {
      final String ch = text[i];
      context.buffer.writeStyled(cx, y, ch, style);
      cx += charWidth(ch.codeUnitAt(0));
    }
    return cx;
  }
}

class _DropdownMenuRenderWidget extends RenderObjectWidget {
  const _DropdownMenuRenderWidget({
    required this.items,
    required this.selectedIndex,
    required this.dropdownColor,
    required this.focusColor,
  });

  final List<DropdownMenuItem> items;
  final int selectedIndex;
  final Color dropdownColor;
  final Color focusColor;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderDropdownMenu createRenderObject(BuildContext context) =>
      RenderDropdownMenu(
        items: items,
        selectedIndex: selectedIndex,
        dropdownColor: dropdownColor,
        focusColor: focusColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderDropdownMenu;
    render.items = items;
    render.selectedIndex = selectedIndex;
    render.dropdownColor = dropdownColor;
    render.focusColor = focusColor;
  }
}

class RenderDropdownMenu extends RenderBox {
  RenderDropdownMenu({
    required this.items,
    required this.selectedIndex,
    required this.dropdownColor,
    required this.focusColor,
  });

  List<DropdownMenuItem> items;
  int selectedIndex;
  Color dropdownColor;
  Color focusColor;

  @override
  void performLayout(Constraints constraints) {
    int maxWidth = 0;
    for (final item in items) {
      final int w = stringWidth(item.label);
      if (w > maxWidth) {
        maxWidth = w;
      }
    }
    size = Size(maxWidth + 2, items.length);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < items.length; i++) {
      final DropdownMenuItem item = items[i];
      final bool isSelected = i == selectedIndex;
      final Color bgColor = isSelected ? focusColor : dropdownColor;
      final Color fg = item.enabled ? Color.white : Color.brightBlack;
      final TextStyle bgStyle = TextStyle(backgroundColor: bgColor);
      final TextStyle fgBgStyle =
          TextStyle(color: fg, backgroundColor: bgColor);
      _fillRow(context, offset.x.toInt(), offset.y.toInt() + i,
          size!.width.toInt(), bgStyle);
      final String prefix = isSelected ? '> ' : '  ';
      _paintChars(
          context, offset.x.toInt(), offset.y.toInt() + i, prefix, fgBgStyle);
      _paintLabel(context, offset.x.toInt() + 2, offset.y.toInt() + i,
          item.label, fgBgStyle);
    }
  }

  void _fillRow(
      PaintingContext context, int x, int y, int width, TextStyle style) {
    for (int i = 0; i < width; i++) {
      context.buffer.writeStyled(x + i, y, ' ', style);
    }
  }

  void _paintChars(
      PaintingContext context, int x, int y, String str, TextStyle style) {
    for (int i = 0; i < str.length; i++) {
      context.buffer.writeStyled(x + i, y, str[i], style);
    }
  }

  void _paintLabel(PaintingContext context, int startX, int y, String label,
      TextStyle style) {
    int cx = startX;
    for (int i = 0; i < label.length; i++) {
      final String ch = label[i];
      context.buffer.writeStyled(cx, y, ch, style);
      cx += charWidth(ch.codeUnitAt(0));
    }
  }
}
