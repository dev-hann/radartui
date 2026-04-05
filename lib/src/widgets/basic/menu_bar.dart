import '../../../radartui.dart';

/// A top-level menu entry containing a [label] and a list of [MenuItem] children.
///
/// Each [MenuBarItem] appears as a button in the menu bar. Activating it opens
/// a dropdown showing its [children].
class MenuBarItem {
  /// Creates a [MenuBarItem] with the given [label] and [children].
  const MenuBarItem({
    required this.label,
    required this.children,
  });

  /// The text label displayed on the menu bar.
  final String label;

  /// The dropdown menu entries for this bar item.
  final List<MenuItem> children;
}

/// A single entry inside a [MenuBarItem] dropdown.
///
/// Has a [label], an optional [onSelected] callback, an optional [shortcut] label,
/// and an [enabled] flag. When [enabled] is false, the item appears dimmed.
class MenuItem {
  /// Creates a [MenuItem] with the given [label].
  const MenuItem({
    required this.label,
    this.onSelected,
    this.shortcut,
    this.enabled = true,
  });

  /// The text label displayed for this menu entry.
  final String label;

  /// Called when the user selects this menu entry.
  final VoidCallback? onSelected;

  /// An optional shortcut hint displayed alongside the label (e.g. "Ctrl+S").
  final String? shortcut;

  /// Whether this item can be selected.
  final bool enabled;
}

/// A horizontal menu bar containing [MenuBarItem] entries.
///
/// Renders a top bar with menu labels. Pressing Enter or the activation key
/// opens a dropdown for the focused menu item.
class MenuBar extends StatefulWidget {
  /// Creates a [MenuBar] with the given [items].
  const MenuBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.focusNode,
  });

  /// The top-level menu entries displayed in the bar.
  final List<MenuBarItem> items;

  /// The background color of the menu bar.
  final Color? backgroundColor;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> with FocusableState<MenuBar> {
  int _openMenuIndex = -1;
  int _selectedItemIndex = 0;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    if (_openMenuIndex == -1) {
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
        _openMenuIndex = 0;
        _selectedItemIndex = 0;
        focusNode.trapFocus = true;
      });
    } else if (event.code == KeyCode.arrowLeft) {
      setState(() {
        _openMenuIndex = widget.items.isNotEmpty ? 0 : -1;
        if (_openMenuIndex >= 0) focusNode.trapFocus = true;
      });
    } else if (event.code == KeyCode.arrowRight) {
      setState(() {
        _openMenuIndex = widget.items.isNotEmpty ? 0 : -1;
        if (_openMenuIndex >= 0) focusNode.trapFocus = true;
      });
    }
  }

  void _handleOpenKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowLeft) {
      setState(() {
        _openMenuIndex = (_openMenuIndex - 1) % widget.items.length;
        _selectedItemIndex = 0;
      });
    } else if (event.code == KeyCode.arrowRight) {
      setState(() {
        _openMenuIndex = (_openMenuIndex + 1) % widget.items.length;
        _selectedItemIndex = 0;
      });
    } else if (event.code == KeyCode.arrowUp) {
      final int itemCount = widget.items[_openMenuIndex].children.length;
      setState(() {
        _selectedItemIndex = (_selectedItemIndex - 1).clamp(0, itemCount - 1);
      });
    } else if (event.code == KeyCode.arrowDown) {
      final int itemCount = widget.items[_openMenuIndex].children.length;
      setState(() {
        _selectedItemIndex = (_selectedItemIndex + 1).clamp(0, itemCount - 1);
      });
    } else if (event.code == KeyCode.enter) {
      _activateSelectedItem();
    } else if (event.code == KeyCode.escape) {
      _closeMenu();
    }
  }

  void _activateSelectedItem() {
    final MenuItem item =
        widget.items[_openMenuIndex].children[_selectedItemIndex];
    if (item.enabled && item.onSelected != null) {
      item.onSelected!();
    }
    _closeMenu();
  }

  void _closeMenu() {
    setState(() {
      _openMenuIndex = -1;
      focusNode.trapFocus = false;
    });
  }

  @override
  void onFocusChange(bool focused) {
    super.onFocusChange(focused);
    if (!focused) {
      setState(() {
        _openMenuIndex = -1;
        focusNode.trapFocus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _MenuBarRenderWidget(
      items: widget.items,
      focused: hasFocus,
      openMenuIndex: _openMenuIndex,
      selectedItemIndex: _selectedItemIndex,
      backgroundColor: widget.backgroundColor ?? Color.blue,
    );
  }
}

class _MenuBarRenderWidget extends RenderObjectWidget {
  const _MenuBarRenderWidget({
    required this.items,
    required this.focused,
    required this.openMenuIndex,
    required this.selectedItemIndex,
    required this.backgroundColor,
  });

  final List<MenuBarItem> items;
  final bool focused;
  final int openMenuIndex;
  final int selectedItemIndex;
  final Color backgroundColor;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderMenuBar createRenderObject(BuildContext context) => RenderMenuBar(
        items: items,
        focused: focused,
        openMenuIndex: openMenuIndex,
        selectedItemIndex: selectedItemIndex,
        backgroundColor: backgroundColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderMenuBar;
    render.items = items;
    render.focused = focused;
    render.openMenuIndex = openMenuIndex;
    render.selectedItemIndex = selectedItemIndex;
    render.backgroundColor = backgroundColor;
  }
}

/// Render object that paints a horizontal menu bar with optional dropdown menus.
class RenderMenuBar extends RenderBox {
  /// Creates a [RenderMenuBar] with the given items and state.
  RenderMenuBar({
    required this.items,
    required this.focused,
    required this.openMenuIndex,
    required this.selectedItemIndex,
    required this.backgroundColor,
  });

  /// The top-level menu bar items.
  List<MenuBarItem> items;

  /// Whether the menu bar currently has keyboard focus.
  bool focused;

  /// The index of the currently open dropdown, or -1 if none is open.
  int openMenuIndex;

  /// The index of the highlighted item in the open dropdown.
  int selectedItemIndex;

  /// The background color of the menu bar.
  Color backgroundColor;

  @override
  void performLayout(Constraints constraints) {
    int totalWidth = 0;
    for (final item in items) {
      totalWidth += stringWidth(item.label) + 2;
    }
    int maxDropdownHeight = 1;
    if (openMenuIndex >= 0 && openMenuIndex < items.length) {
      maxDropdownHeight += items[openMenuIndex].children.length;
    }
    size = Size(totalWidth, maxDropdownHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final int x = offset.x.toInt();
    final int y = offset.y.toInt();
    _paintMenuBarItems(context, x, y);
    if (openMenuIndex >= 0 && openMenuIndex < items.length) {
      _paintDropdownMenu(context, x, y);
    }
  }

  void _paintMenuBarItems(PaintingContext context, int startX, int y) {
    int x = startX;
    for (int i = 0; i < items.length; i++) {
      final MenuBarItem item = items[i];
      final bool isOpen = i == openMenuIndex;
      final int itemWidth = stringWidth(item.label) + 2;
      final Color bg = isOpen ? Color.white : backgroundColor;
      final Color fg = isOpen ? Color.black : Color.white;
      final TextStyle bgStyle = TextStyle(backgroundColor: bg);
      final TextStyle fgBgStyle = TextStyle(color: fg, backgroundColor: bg);
      for (int j = 0; j < itemWidth; j++) {
        context.buffer.writeStyled(x + j, y, ' ', bgStyle);
      }
      context.buffer.writeStyled(x + 1, y, item.label, fgBgStyle);
      x += itemWidth;
    }
  }

  int _calculateDropdownX(int baseX) {
    int menuX = baseX;
    for (int i = 0; i < openMenuIndex; i++) {
      menuX += stringWidth(items[i].label) + 2;
    }
    return menuX;
  }

  int _calculateMaxDropdownWidth(MenuBarItem item) {
    int maxWidth = 0;
    for (final child in item.children) {
      int w = stringWidth(child.label);
      if (child.shortcut != null) {
        w += 2 + stringWidth(child.shortcut!);
      }
      if (w > maxWidth) maxWidth = w;
    }
    return maxWidth + 2;
  }

  void _paintDropdownMenu(PaintingContext context, int baseX, int y) {
    final int menuX = _calculateDropdownX(baseX);
    final MenuBarItem openItem = items[openMenuIndex];
    final int maxWidth = _calculateMaxDropdownWidth(openItem);
    for (int row = 0; row < openItem.children.length; row++) {
      _paintDropdownRow(
        context,
        menuX,
        y + 1 + row,
        openItem.children[row],
        row == selectedItemIndex,
        maxWidth,
      );
    }
  }

  void _paintDropdownRow(
    PaintingContext context,
    int x,
    int y,
    MenuItem item,
    bool isSelected,
    int maxWidth,
  ) {
    final Color bg = isSelected ? Color.cyan : Color.black;
    final Color fg = item.enabled ? Color.white : Color.brightBlack;
    final TextStyle bgStyle = TextStyle(backgroundColor: bg);
    final TextStyle fgBgStyle = TextStyle(color: fg, backgroundColor: bg);
    for (int cx = 0; cx < maxWidth; cx++) {
      context.buffer.writeStyled(x + cx, y, ' ', bgStyle);
    }
    final String prefix = isSelected ? '> ' : '  ';
    context.buffer.writeStyled(x, y, prefix, fgBgStyle);
    context.buffer.writeStyled(x + 2, y, item.label, fgBgStyle);
    if (item.shortcut != null) {
      final int shortcutX = x + maxWidth - stringWidth(item.shortcut!);
      context.buffer.writeStyled(
        shortcutX,
        y,
        item.shortcut!,
        TextStyle(color: Color.brightBlack, backgroundColor: bg),
      );
    }
  }
}
