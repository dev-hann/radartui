import '../../../radartui.dart';

/// Controls the active tab index for [TabBar] and [TabBarView].
///
/// Notifies listeners when the index changes. Use [DefaultTabController] to
/// provide a [TabController] to the widget tree via inheritance.
class TabController extends ChangeNotifier {
  /// Creates a [TabController] with the given [length] and optional [initialIndex].
  TabController({
    int initialIndex = 0,
    required int length,
  })  : _index = initialIndex,
        _length = length;

  int _index;
  final int _length;

  /// The current active tab index.
  int get index => _index;

  /// The total number of tabs.
  int get length => _length;

  /// Animates to the given [newIndex], clamped to valid range.
  void animateTo(int newIndex) {
    final int clamped = newIndex.clamp(0, _length - 1);
    if (clamped == _index) return;
    _index = clamped;
    notifyListeners();
  }
}

/// Provides a [TabController] to descendant widgets via inheritance.
///
/// Wrap a [TabBar] and [TabBarView] pair in a [DefaultTabController] so they
/// share the same controller without passing it manually.
class DefaultTabController extends InheritedWidget {
  /// Creates a [DefaultTabController] that provides [controller] to descendants.
  const DefaultTabController({
    super.key,
    required this.controller,
    required super.child,
  });

  /// The [TabController] provided to descendant widgets.
  final TabController controller;

  /// Retrieves the nearest [TabController] from the widget tree.
  static TabController? of(BuildContext context) {
    final DefaultTabController? result =
        context.dependOnInheritedWidgetOfExactType<DefaultTabController>();
    return result?.controller;
  }

  @override
  bool updateShouldNotify(DefaultTabController oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// A single tab entry displayed in a [TabBar].
///
/// Provide either [text] or [icon] (or both) for the tab's appearance.
class Tab {
  /// Creates a [Tab] with optional [text] and [icon].
  const Tab({this.text, this.icon});

  /// The text label displayed on the tab.
  final String? text;

  /// The icon character displayed on the tab.
  final String? icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tab && other.text == text && other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(text, icon);
}

/// A horizontal row of [Tab] widgets that lets the user switch views.
///
/// Highlights the active tab and calls [onTap] when a new tab is selected.
/// Must be used with a [TabController] (typically via [DefaultTabController]).
class TabBar extends StatefulWidget {
  /// Creates a [TabBar] with the given [tabs].
  const TabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.onTap,
    this.focusNode,
  });

  /// The list of [Tab] widgets to display.
  final List<Tab> tabs;

  /// An optional external [TabController]; defaults to [DefaultTabController.of].
  final TabController? controller;

  /// The color of the active tab indicator line.
  final Color? indicatorColor;

  /// The text color of the selected tab.
  final Color? labelColor;

  /// The text color of unselected tabs.
  final Color? unselectedLabelColor;

  /// The text style of the selected tab label.
  final TextStyle? labelStyle;

  /// The text style of unselected tab labels.
  final TextStyle? unselectedLabelStyle;

  /// Padding around each tab label.
  final EdgeInsets? labelPadding;

  /// Called when the user taps a tab, receiving the new index.
  final ValueChanged<int>? onTap;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> with FocusableState<TabBar> {
  TabController? _internalController;
  TabController get _controller =>
      widget.controller ??
      DefaultTabController.of(context) ??
      _internalController!;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = _createInternalController();
    }
    _controller.addListener(_onControllerChange);
  }

  TabController _createInternalController() {
    final controller = TabController(
      initialIndex: 0,
      length: widget.tabs.length,
    );
    controller.addListener(_onControllerChange);
    return controller;
  }

  @override
  void didUpdateWidget(TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChange);
      if (oldWidget.controller == null) {
        _internalController?.dispose();
      }
      if (widget.controller == null) {
        _internalController = _createInternalController();
      } else {
        widget.controller!.addListener(_onControllerChange);
      }
    }
    if (widget.tabs.length != oldWidget.tabs.length) {
      if (widget.controller == null && _internalController != null) {
        _internalController!.removeListener(_onControllerChange);
        _internalController!.dispose();
        _internalController = _createInternalController();
      }
    }
  }

  void _onControllerChange() {
    setState(() {});
  }

  @override
  void onKeyEvent(KeyEvent event) {
    final TabController controller = _controller;
    if (event.code == KeyCode.arrowLeft) {
      _moveTab(controller, -1);
    } else if (event.code == KeyCode.arrowRight) {
      _moveTab(controller, 1);
    }
  }

  void _moveTab(TabController controller, int delta) {
    final int newIndex =
        (controller.index + delta).clamp(0, widget.tabs.length - 1);
    if (newIndex != controller.index) {
      controller.animateTo(newIndex);
      widget.onTap?.call(newIndex);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChange);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TabController controller = _controller;
    return _TabBarRenderWidget(
      tabs: widget.tabs,
      currentIndex: controller.index,
      focused: hasFocus,
      indicatorColor: widget.indicatorColor ?? Color.cyan,
      labelColor: widget.labelColor ?? Color.white,
      unselectedLabelColor: widget.unselectedLabelColor ?? Color.brightBlack,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      labelPadding: widget.labelPadding ?? EdgeInsets.horizontalOne,
    );
  }
}

class _TabBarRenderWidget extends RenderObjectWidget {
  const _TabBarRenderWidget({
    required this.tabs,
    required this.currentIndex,
    required this.focused,
    required this.indicatorColor,
    required this.labelColor,
    required this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding = const EdgeInsets.symmetric(horizontal: 1),
  });

  final List<Tab> tabs;
  final int currentIndex;
  final bool focused;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsets labelPadding;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderTabBar createRenderObject(BuildContext context) => RenderTabBar(
        tabs: tabs,
        currentIndex: currentIndex,
        focused: focused,
        indicatorColor: indicatorColor,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        labelPadding: labelPadding,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderTabBar;
    final bool needsLayout = render.tabs != tabs ||
        render.currentIndex != currentIndex ||
        render.labelPadding != labelPadding;

    render.tabs = tabs;
    render.currentIndex = currentIndex;
    render.focused = focused;
    render.indicatorColor = indicatorColor;
    render.labelColor = labelColor;
    render.unselectedLabelColor = unselectedLabelColor;
    render.labelStyle = labelStyle;
    render.unselectedLabelStyle = unselectedLabelStyle;
    render.labelPadding = labelPadding;

    if (needsLayout) {
      render.markNeedsLayout();
    }
  }
}

/// Render object that paints a horizontal row of tabs with an active indicator.
class RenderTabBar extends RenderBox {
  /// Creates a [RenderTabBar] with the given tab configuration.
  RenderTabBar({
    required List<Tab> tabs,
    required int currentIndex,
    required bool focused,
    required Color indicatorColor,
    required Color labelColor,
    required Color unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    required EdgeInsets labelPadding,
  })  : _tabs = tabs,
        _currentIndex = currentIndex,
        _focused = focused,
        _indicatorColor = indicatorColor,
        _labelColor = labelColor,
        _unselectedLabelColor = unselectedLabelColor,
        _labelStyle = labelStyle,
        _unselectedLabelStyle = unselectedLabelStyle,
        _labelPadding = labelPadding;

  List<Tab> _tabs;

  /// The list of tabs to display.
  List<Tab> get tabs => _tabs;

  /// Sets the list of tabs and invalidates the paint cache.
  set tabs(List<Tab> value) {
    if (identical(_tabs, value)) return;
    _tabs = value;
    _cachedTabsIdentity = null;
    _invalidateCache();
    markNeedsLayout();
  }

  int _currentIndex;

  /// The index of the currently active tab.
  int get currentIndex => _currentIndex;

  /// Sets the active tab index and invalidates the paint cache.
  set currentIndex(int v) {
    if (_currentIndex == v) return;
    _currentIndex = v;
    _invalidateCache();
    markNeedsPaint();
  }

  bool _focused;

  /// Whether the tab bar currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates the paint cache.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  Color _indicatorColor;

  /// The color of the active tab indicator line.
  Color get indicatorColor => _indicatorColor;

  /// Sets the indicator color and invalidates the paint cache.
  set indicatorColor(Color v) {
    if (_indicatorColor == v) return;
    _indicatorColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  Color _labelColor;

  /// The text color of the selected tab label.
  Color get labelColor => _labelColor;

  /// Sets the selected label color and invalidates the paint cache.
  set labelColor(Color v) {
    if (_labelColor == v) return;
    _labelColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  Color _unselectedLabelColor;

  /// The text color of unselected tab labels.
  Color get unselectedLabelColor => _unselectedLabelColor;

  /// Sets the unselected label color and invalidates the paint cache.
  set unselectedLabelColor(Color v) {
    if (_unselectedLabelColor == v) return;
    _unselectedLabelColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _labelStyle;

  /// The text style of the selected tab label.
  TextStyle? get labelStyle => _labelStyle;

  /// Sets the selected label style and invalidates the paint cache.
  set labelStyle(TextStyle? v) {
    if (_labelStyle == v) return;
    _labelStyle = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _unselectedLabelStyle;

  /// The text style of unselected tab labels.
  TextStyle? get unselectedLabelStyle => _unselectedLabelStyle;

  /// Sets the unselected label style and invalidates the paint cache.
  set unselectedLabelStyle(TextStyle? v) {
    if (_unselectedLabelStyle == v) return;
    _unselectedLabelStyle = v;
    _invalidateCache();
    markNeedsPaint();
  }

  EdgeInsets _labelPadding;

  /// Padding applied around each tab label.
  EdgeInsets get labelPadding => _labelPadding;

  /// Sets the label padding.
  set labelPadding(EdgeInsets v) {
    if (_labelPadding == v) return;
    _labelPadding = v;
    _invalidateCache();
    markNeedsLayout();
  }

  TextStyle? _cachedSelectedStyle;
  TextStyle? _cachedUnselectedStyle;
  TextStyle? _cachedIndicatorStyle;
  List<int> _cachedTabWidths = [];
  List<Tab>? _cachedTabsIdentity;

  void _invalidateCache() {
    _cachedSelectedStyle = null;
    _cachedUnselectedStyle = null;
    _cachedIndicatorStyle = null;
  }

  void _ensureTabWidthsCached() {
    if (identical(_tabs, _cachedTabsIdentity)) return;
    final widths = <int>[];
    for (final tab in _tabs) {
      final int textLen = stringWidth(tab.text ?? '');
      final int iconLen =
          (tab.icon != null) ? charWidth(tab.icon!.codeUnitAt(0)) : 0;
      widths.add(textLen + iconLen);
    }
    _cachedTabWidths = widths;
    _cachedTabsIdentity = _tabs;
  }

  @override
  void performLayout(Constraints constraints) {
    _ensureTabWidthsCached();
    int totalWidth = 0;
    for (final w in _cachedTabWidths) {
      totalWidth += w + labelPadding.horizontal;
    }
    if (_tabs.isNotEmpty && _tabs.length > 1) {
      totalWidth += _tabs.length - 1;
    }
    size = Size(totalWidth, 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final int y = offset.y;
    int x = offset.x;
    final int tabsLength = _tabs.length;
    for (int i = 0; i < tabsLength; i++) {
      final Tab tab = _tabs[i];
      final bool isSelected = i == currentIndex;
      final TextStyle style =
          isSelected ? _cachedSelectedStyle! : _cachedUnselectedStyle!;
      x += labelPadding.left;
      x += _paintTabContent(context, x, y, tab, style);
      final int contentWidth = _tabContentWidth(i);
      x += labelPadding.right;
      if (isSelected) {
        _paintSelectedIndicator(context, y,
            x - labelPadding.right - contentWidth, x - labelPadding.right);
      }
      if (i < tabsLength - 1) x += 1;
    }
  }

  int _paintTabContent(
      PaintingContext context, int x, int y, Tab tab, TextStyle style) {
    if (tab.icon != null) {
      context.buffer.writeStyled(x, y, tab.icon!, style);
      final int iconW = charWidth(tab.icon!.codeUnitAt(0));
      return context.writeString(x + iconW, y, tab.text ?? '', style);
    }
    return context.writeString(x, y, tab.text ?? '', style);
  }

  void _paintSelectedIndicator(
      PaintingContext context, int y, int start, int end) {
    final int width = end - start;
    if (width <= 0) return;
    context.writeString(start, y + 1, '─' * width, _cachedIndicatorStyle!);
  }

  void _ensureStylesCached() {
    if (_cachedSelectedStyle != null) return;
    _cachedSelectedStyle =
        labelStyle ?? TextStyle(color: labelColor, bold: true);
    _cachedUnselectedStyle =
        unselectedLabelStyle ?? TextStyle(color: unselectedLabelColor);
    _cachedIndicatorStyle = TextStyle(color: indicatorColor);
  }

  int _tabContentWidth(int tabIndex) {
    return _cachedTabWidths[tabIndex];
  }
}

/// Displays the content corresponding to the active tab in a [TabBar].
///
/// Shows one child at a time based on the [TabController.index]. Must receive
/// the same [controller] as the paired [TabBar].
class TabBarView extends StatefulWidget {
  /// Creates a [TabBarView] with the given [controller] and [children].
  const TabBarView({
    super.key,
    required this.controller,
    required this.children,
  });

  /// The controller that determines which child is visible.
  final TabController controller;

  /// The list of child widgets, one per tab.
  final List<Widget> children;

  @override
  State<TabBarView> createState() => _TabBarViewState();
}

class _TabBarViewState extends State<TabBarView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void didUpdateWidget(TabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChange);
      widget.controller.addListener(_onControllerChange);
    }
  }

  void _onControllerChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int index =
        widget.controller.index.clamp(0, widget.children.length - 1);
    return widget.children[index];
  }
}
