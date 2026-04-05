import '../../../radartui.dart';

/// A data model for a single option in a [DropdownButton].
///
/// Each item has a [value] of type [T], a display [label], and an [enabled] flag.
class DropdownMenuItem<T> {
  /// Creates a [DropdownMenuItem] with the given [value] and [label].
  const DropdownMenuItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  /// The value represented by this menu item.
  final T value;

  /// The text displayed for this item.
  final String label;

  /// Whether this item can be selected.
  final bool enabled;
}

/// A dropdown selector that lets the user choose one item from a list.
///
/// Displays the currently selected [value] and opens a popup menu when activated.
/// Use [hint] to show placeholder text when no value is selected.
class DropdownButton<T> extends StatefulWidget {
  /// Creates a [DropdownButton] with the given [items] and [onChanged] callback.
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

  /// The list of menu items to choose from.
  final List<DropdownMenuItem<T>> items;

  /// The currently selected value, or `null` if nothing is selected.
  final T? value;

  /// Called when the user selects a new item.
  final ValueChanged<T?>? onChanged;

  /// Placeholder text shown when no value is selected.
  final String? hint;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// The border color when the button has focus.
  final Color? focusColor;

  /// The background color of the closed button.
  final Color? backgroundColor;

  /// The background color of the dropdown menu popup.
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
    if (event.isActivationKey) {
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
        _buildButtonWidget(displayText),
        if (_isOpen) _buildMenuWidget(),
      ],
    );
  }

  Widget _buildButtonWidget(String displayText) {
    return _DropdownButtonRenderWidget(
      text: displayText,
      focused: hasFocus,
      isOpen: _isOpen,
      enabled: widget.onChanged != null,
      focusColor: widget.focusColor ?? Color.cyan,
      backgroundColor: widget.backgroundColor ?? Color.brightBlack,
    );
  }

  Widget _buildMenuWidget() {
    return _DropdownMenuRenderWidget(
      items: widget.items,
      selectedIndex: _selectedIndex,
      dropdownColor: widget.dropdownColor ?? Color.black,
      focusColor: widget.focusColor ?? Color.cyan,
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

/// Render object that paints the closed dropdown button with text and arrow.
class RenderDropdownButton extends RenderBox {
  /// Creates a [RenderDropdownButton] with the given display configuration.
  RenderDropdownButton({
    required String text,
    required bool focused,
    required bool isOpen,
    required bool enabled,
    required Color focusColor,
    required Color backgroundColor,
  })  : _text = text,
        _focused = focused,
        _isOpen = isOpen,
        _enabled = enabled,
        _focusColor = focusColor,
        _backgroundColor = backgroundColor;

  String _text;
  bool _focused;
  bool _isOpen;
  bool _enabled;
  Color _focusColor;
  Color _backgroundColor;

  /// The text label displayed on the button.
  String get text => _text;

  /// Sets the text label.
  set text(String v) {
    if (_text == v) return;
    _text = v;
    _invalidateCache();
    markNeedsLayout();
  }

  /// Whether the button currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// Whether the dropdown menu is currently open.
  bool get isOpen => _isOpen;

  /// Sets the open state.
  set isOpen(bool v) {
    if (_isOpen == v) return;
    _isOpen = v;
    markNeedsPaint();
  }

  /// Whether the button is interactive.
  bool get enabled => _enabled;

  /// Sets the enabled state.
  set enabled(bool v) {
    if (_enabled == v) return;
    _enabled = v;
    _invalidateCache();
    markNeedsPaint();
  }

  Color get focusColor => _focusColor;

  set focusColor(Color v) {
    if (_focusColor == v) return;
    _focusColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color v) {
    if (_backgroundColor == v) return;
    _backgroundColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _cachedBgStyle;
  TextStyle? _cachedFgBgStyle;
  Color? _cachedBgColor;
  Color? _cachedFgColor;
  int? _cachedTextWidth;
  String? _cachedTextIdentity;

  void _invalidateCache() {
    _cachedBgStyle = null;
    _cachedFgBgStyle = null;
    _cachedBgColor = null;
    _cachedFgColor = null;
  }

  void _ensureStylesCached() {
    final Color bgColor = focused ? focusColor : backgroundColor;
    final Color fgColor = enabled ? Color.white : Color.brightBlack;
    if (_cachedBgColor == bgColor &&
        _cachedFgColor == fgColor &&
        _cachedBgStyle != null) {
      return;
    }
    _cachedBgStyle = TextStyle(backgroundColor: bgColor);
    _cachedFgBgStyle = TextStyle(color: fgColor, backgroundColor: bgColor);
    _cachedBgColor = bgColor;
    _cachedFgColor = fgColor;
  }

  int get _textWidth {
    if (!identical(_text, _cachedTextIdentity)) {
      _cachedTextWidth = stringWidth(_text);
      _cachedTextIdentity = _text;
    }
    return _cachedTextWidth!;
  }

  @override
  void performLayout(Constraints constraints) {
    size = Size(_textWidth + 4, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final TextStyle bgStyle = _cachedBgStyle!;
    final TextStyle fgBgStyle = _cachedFgBgStyle!;
    final int textW = _textWidth;
    final int x = offset.x.toInt();
    final int y = offset.y.toInt();
    context.fillBackground(x, y, textW + 3, bgStyle);
    final int cx = context.writeString(x + 1, y, _text, fgBgStyle);
    final String arrow = _isOpen ? ' ▲' : ' ▼';
    context.writeString(cx, y, arrow, fgBgStyle);
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

/// Render object that paints the open dropdown menu popup with selectable items.
class RenderDropdownMenu extends RenderBox {
  /// Creates a [RenderDropdownMenu] with the given items and visual configuration.
  RenderDropdownMenu({
    required List<DropdownMenuItem> items,
    required int selectedIndex,
    required Color dropdownColor,
    required Color focusColor,
  })  : _items = items,
        _selectedIndex = selectedIndex,
        _dropdownColor = dropdownColor,
        _focusColor = focusColor;

  List<DropdownMenuItem> _items;
  int _selectedIndex;
  Color _dropdownColor;
  Color _focusColor;

  /// The list of menu items to display.
  List<DropdownMenuItem> get items => _items;

  /// Sets the menu items and invalidates cached styles.
  set items(List<DropdownMenuItem> v) {
    if (identical(_items, v)) return;
    _items = v;
    _invalidateCache();
  }

  /// The index of the currently highlighted item.
  int get selectedIndex => _selectedIndex;

  /// Sets the selected index.
  set selectedIndex(int v) {
    if (_selectedIndex == v) return;
    _selectedIndex = v;
    markNeedsPaint();
  }

  /// The background color of unselected items.
  Color get dropdownColor => _dropdownColor;

  /// Sets the dropdown color and invalidates cached styles.
  set dropdownColor(Color v) {
    if (_dropdownColor == v) return;
    _dropdownColor = v;
    _invalidateCache();
  }

  /// The background color of the selected item.
  Color get focusColor => _focusColor;

  /// Sets the focus color and invalidates cached styles.
  set focusColor(Color v) {
    if (_focusColor == v) return;
    _focusColor = v;
    _invalidateCache();
  }

  TextStyle? _cachedSelectedBg;
  TextStyle? _cachedNormalBg;
  TextStyle? _cachedSelectedEnabledFg;
  TextStyle? _cachedSelectedDisabledFg;
  TextStyle? _cachedNormalEnabledFg;
  TextStyle? _cachedNormalDisabledFg;
  Color? _cachedFocusColor;
  Color? _cachedDropdownColor;
  int _cachedMaxItemWidth = 0;
  List<DropdownMenuItem>? _cachedItemsIdentity;

  void _invalidateCache() {
    _cachedSelectedBg = null;
    _cachedNormalBg = null;
    _cachedSelectedEnabledFg = null;
    _cachedSelectedDisabledFg = null;
    _cachedNormalEnabledFg = null;
    _cachedNormalDisabledFg = null;
    _cachedItemsIdentity = null;
  }

  void _ensureStylesCached() {
    if (_cachedFocusColor == focusColor &&
        _cachedDropdownColor == dropdownColor &&
        _cachedSelectedBg != null) {
      return;
    }
    _cachedSelectedBg = TextStyle(backgroundColor: focusColor);
    _cachedNormalBg = TextStyle(backgroundColor: dropdownColor);
    _cachedSelectedEnabledFg =
        TextStyle(color: Color.white, backgroundColor: focusColor);
    _cachedSelectedDisabledFg =
        TextStyle(color: Color.brightBlack, backgroundColor: focusColor);
    _cachedNormalEnabledFg =
        TextStyle(color: Color.white, backgroundColor: dropdownColor);
    _cachedNormalDisabledFg =
        TextStyle(color: Color.brightBlack, backgroundColor: dropdownColor);
    _cachedFocusColor = focusColor;
    _cachedDropdownColor = dropdownColor;
  }

  @override
  void performLayout(Constraints constraints) {
    if (!identical(_items, _cachedItemsIdentity)) {
      _cachedMaxItemWidth = _computeMaxItemWidth();
      _cachedItemsIdentity = _items;
    }
    size = Size(_cachedMaxItemWidth + 2, _items.length);
  }

  int _computeMaxItemWidth() {
    int maxWidth = 0;
    for (final item in _items) {
      final int w = stringWidth(item.label);
      if (w > maxWidth) maxWidth = w;
    }
    return maxWidth;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final int x = offset.x.toInt();
    final int y = offset.y.toInt();
    final int w = size!.width.toInt();
    final TextStyle selectedBg = _cachedSelectedBg!;
    final TextStyle normalBg = _cachedNormalBg!;
    final TextStyle selectedEnabled = _cachedSelectedEnabledFg!;
    final TextStyle selectedDisabled = _cachedSelectedDisabledFg!;
    final TextStyle normalEnabled = _cachedNormalEnabledFg!;
    final TextStyle normalDisabled = _cachedNormalDisabledFg!;
    for (int i = 0; i < _items.length; i++) {
      final DropdownMenuItem item = _items[i];
      final bool isSelected = i == _selectedIndex;
      final TextStyle bgStyle = isSelected ? selectedBg : normalBg;
      final TextStyle fgBgStyle = isSelected
          ? (item.enabled ? selectedEnabled : selectedDisabled)
          : (item.enabled ? normalEnabled : normalDisabled);
      context.fillBackground(x, y + i, w, bgStyle);
      final String prefix = isSelected ? '> ' : '  ';
      context.writeString(x, y + i, prefix, fgBgStyle);
      context.writeString(x + 2, y + i, item.label, fgBgStyle);
    }
  }
}
