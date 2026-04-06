import 'dart:math' as math;

import '../../../radartui.dart';
import '../../foundation/drawing_constants.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MenuBarItem) return false;
    if (label != other.label) return false;
    if (children.length != other.children.length) return false;
    return List.generate(
      children.length,
      (i) => children[i] == other.children[i],
    ).every((equal) => equal);
  }

  @override
  int get hashCode => Object.hash(label, children);
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem &&
        other.label == label &&
        other.shortcut == shortcut &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(label, shortcut, enabled);
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
    if (event.isActivationKey) {
      setState(() {
        _openMenuIndex = 0;
        _selectedItemIndex = 0;
        focusNode.trapFocus = true;
      });
    } else if (event.code == KeyCode.arrowLeft ||
        event.code == KeyCode.arrowRight) {
      setState(() {
        _openMenuIndex = widget.items.isNotEmpty ? 0 : -1;
        if (_openMenuIndex >= 0) focusNode.trapFocus = true;
      });
    }
  }

  void _handleOpenKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowLeft) {
      setState(() {
        _openMenuIndex =
            (_openMenuIndex - 1 + widget.items.length) % widget.items.length;
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
    required List<MenuBarItem> items,
    required bool focused,
    required int openMenuIndex,
    required int selectedItemIndex,
    required Color backgroundColor,
  })  : _items = items,
        _focused = focused,
        _openMenuIndex = openMenuIndex,
        _selectedItemIndex = selectedItemIndex,
        _backgroundColor = backgroundColor;

  static const TextStyle _menuOpenBgStyle =
      TextStyle(backgroundColor: Color.white);
  static const TextStyle _menuOpenFgStyle =
      TextStyle(color: Color.black, backgroundColor: Color.white);
  static const TextStyle _dropdownSelectedBgStyle =
      TextStyle(backgroundColor: Color.cyan);
  static const TextStyle _dropdownSelectedFgStyle =
      TextStyle(color: Color.white, backgroundColor: Color.cyan);
  static const TextStyle _dropdownNormalBgStyle =
      TextStyle(backgroundColor: Color.black);
  static const TextStyle _dropdownNormalEnabledFgStyle =
      TextStyle(color: Color.white, backgroundColor: Color.black);
  static const TextStyle _dropdownNormalDisabledFgStyle =
      TextStyle(color: Color.brightBlack, backgroundColor: Color.black);
  static const TextStyle _dropdownShortcutSelectedStyle =
      TextStyle(color: Color.brightBlack, backgroundColor: Color.cyan);
  static const TextStyle _dropdownShortcutNormalStyle =
      TextStyle(color: Color.brightBlack, backgroundColor: Color.black);

  List<MenuBarItem> _items;
  bool _focused;
  int _openMenuIndex;
  int _selectedItemIndex;
  Color _backgroundColor;

  /// The top-level menu bar items.
  List<MenuBarItem> get items => _items;

  /// Sets the menu bar items and invalidates cached styles.
  set items(List<MenuBarItem> v) {
    if (identical(_items, v)) return;
    _items = v;
    _invalidateCache();
    markNeedsLayout();
  }

  /// Whether the menu bar currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates cached styles.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The index of the currently open dropdown, or -1 if none is open.
  int get openMenuIndex => _openMenuIndex;

  /// Sets the open menu index and invalidates cached styles.
  set openMenuIndex(int v) {
    if (_openMenuIndex == v) return;
    _openMenuIndex = v;
    _invalidateCache();
    markNeedsLayout();
  }

  /// The index of the highlighted item in the open dropdown.
  int get selectedItemIndex => _selectedItemIndex;

  /// Sets the selected item index.
  set selectedItemIndex(int v) {
    if (_selectedItemIndex == v) return;
    _selectedItemIndex = v;
    markNeedsPaint();
  }

  /// The background color of the menu bar.
  Color get backgroundColor => _backgroundColor;

  /// Sets the background color and invalidates cached styles.
  set backgroundColor(Color v) {
    if (_backgroundColor == v) return;
    _backgroundColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _cachedMenuClosedBgStyle;
  TextStyle? _cachedMenuClosedFgStyle;
  Color? _cachedBgColor;
  List<int> _cachedItemWidths = const [];
  List<MenuBarItem>? _cachedItemsIdentity;
  int _cachedDropdownWidth = 0;
  int _cachedOpenMenuIndex = -2;
  Map<String, int> _cachedShortcutWidths = const {};
  int _cachedDropdownX = 0;

  void _invalidateCache() {
    _cachedMenuClosedBgStyle = null;
    _cachedMenuClosedFgStyle = null;
    _cachedItemsIdentity = null;
  }

  void _ensureMenuBarStylesCached() {
    if (_cachedBgColor == backgroundColor && _cachedMenuClosedBgStyle != null) {
      return;
    }
    _cachedMenuClosedBgStyle = TextStyle(backgroundColor: backgroundColor);
    _cachedMenuClosedFgStyle =
        TextStyle(color: Color.white, backgroundColor: backgroundColor);
    _cachedBgColor = backgroundColor;
  }

  void _ensureItemWidthsCached() {
    if (identical(_items, _cachedItemsIdentity)) return;
    final widths = <int>[];
    for (final item in _items) {
      widths.add(stringWidth(item.label) + 2);
    }
    _cachedItemWidths = widths;
    _cachedItemsIdentity = _items;
  }

  void _ensureDropdownCached() {
    if (_cachedOpenMenuIndex == openMenuIndex &&
        identical(_items, _cachedItemsIdentity)) {
      return;
    }
    _cachedShortcutWidths = const {};
    _cachedDropdownWidth = 0;
    _cachedDropdownX = 0;
    if (openMenuIndex >= 0 && openMenuIndex < _items.length) {
      _cachedDropdownWidth = _computeMaxDropdownWidth(_items[openMenuIndex]);
      _cachedDropdownX = _computeDropdownX();
    }
    _cachedOpenMenuIndex = openMenuIndex;
  }

  @override
  void performLayout(Constraints constraints) {
    _ensureItemWidthsCached();
    int totalWidth = 0;
    for (final w in _cachedItemWidths) {
      totalWidth += w;
    }
    _ensureDropdownCached();
    int maxDropdownHeight = 1;
    if (openMenuIndex >= 0 && openMenuIndex < _items.length) {
      maxDropdownHeight += _items[openMenuIndex].children.length;
    }
    size = Size(totalWidth, maxDropdownHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final int x = offset.x;
    final int y = offset.y;
    _paintMenuBarItems(context, x, y);
    if (openMenuIndex >= 0 && openMenuIndex < items.length) {
      _paintDropdownMenu(context, x, y);
    }
  }

  void _paintMenuBarItems(PaintingContext context, int startX, int y) {
    _ensureMenuBarStylesCached();
    int x = startX;
    for (int i = 0; i < items.length; i++) {
      final MenuBarItem item = items[i];
      final bool isOpen = i == openMenuIndex;
      final int itemWidth = _cachedItemWidths[i];
      final TextStyle bgStyle =
          isOpen ? _menuOpenBgStyle : _cachedMenuClosedBgStyle!;
      final TextStyle fgBgStyle =
          isOpen ? _menuOpenFgStyle : _cachedMenuClosedFgStyle!;
      context.fillBackground(x, y, itemWidth, bgStyle);
      context.writeString(x + 1, y, item.label, fgBgStyle);
      x += itemWidth;
    }
  }

  int _computeDropdownX() {
    int menuX = 0;
    for (int i = 0; i < openMenuIndex; i++) {
      menuX += _cachedItemWidths[i];
    }
    return menuX;
  }

  int _computeMaxDropdownWidth(MenuBarItem item) {
    final shortcutWidths = <String, int>{};
    int maxWidth = 0;
    for (final child in item.children) {
      int w = stringWidth(child.label);
      if (child.shortcut != null) {
        final int sw = stringWidth(child.shortcut!);
        shortcutWidths[child.shortcut!] = sw;
        w += 2 + sw;
      }
      maxWidth = math.max(maxWidth, w);
    }
    _cachedShortcutWidths = shortcutWidths;
    return maxWidth + 2;
  }

  void _paintDropdownMenu(PaintingContext context, int baseX, int y) {
    final int menuX = baseX + _cachedDropdownX;
    final MenuBarItem openItem = items[openMenuIndex];
    final int maxWidth = _cachedDropdownWidth;
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
    final TextStyle bgStyle =
        isSelected ? _dropdownSelectedBgStyle : _dropdownNormalBgStyle;
    final TextStyle fgBgStyle = isSelected
        ? _dropdownSelectedFgStyle
        : (item.enabled
            ? _dropdownNormalEnabledFgStyle
            : _dropdownNormalDisabledFgStyle);
    context.fillBackground(x, y, maxWidth, bgStyle);
    final String prefix = isSelected
        ? BoxDrawingConstants.checkmark
        : BoxDrawingConstants.spacePrefix;
    context.writeString(x, y, prefix, fgBgStyle);
    context.writeString(x + 2, y, item.label, fgBgStyle);
    if (item.shortcut != null) {
      final int sw =
          _cachedShortcutWidths[item.shortcut!] ?? stringWidth(item.shortcut!);
      final int shortcutX = x + maxWidth - sw;
      final TextStyle shortcutStyle = isSelected
          ? _dropdownShortcutSelectedStyle
          : _dropdownShortcutNormalStyle;
      context.writeString(shortcutX, y, item.shortcut!, shortcutStyle);
    }
  }
}
