import '../../../radartui.dart';

class MenuBarItem {
  const MenuBarItem({
    required this.label,
    required this.children,
  });

  final String label;
  final List<MenuItem> children;
}

class MenuItem {
  const MenuItem({
    required this.label,
    this.onSelected,
    this.shortcut,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onSelected;
  final String? shortcut;
  final bool enabled;
}

class MenuBar extends StatefulWidget {
  const MenuBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.focusNode,
  });

  final List<MenuBarItem> items;
  final Color? backgroundColor;
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

class RenderMenuBar extends RenderBox {
  RenderMenuBar({
    required this.items,
    required this.focused,
    required this.openMenuIndex,
    required this.selectedItemIndex,
    required this.backgroundColor,
  });

  List<MenuBarItem> items;
  bool focused;
  int openMenuIndex;
  int selectedItemIndex;
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
      for (int j = 0; j < itemWidth; j++) {
        context.buffer
            .writeStyled(x + j, y, ' ', TextStyle(backgroundColor: bg));
      }
      final Color fg = isOpen ? Color.black : Color.white;
      context.buffer.writeStyled(
          x + 1, y, item.label, TextStyle(color: fg, backgroundColor: bg));
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
    for (int cx = 0; cx < maxWidth; cx++) {
      context.buffer
          .writeStyled(x + cx, y, ' ', TextStyle(backgroundColor: bg));
    }
    final String prefix = isSelected ? '> ' : '  ';
    context.buffer
        .writeStyled(x, y, prefix, TextStyle(color: fg, backgroundColor: bg));
    context.buffer.writeStyled(
        x + 2, y, item.label, TextStyle(color: fg, backgroundColor: bg));
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
