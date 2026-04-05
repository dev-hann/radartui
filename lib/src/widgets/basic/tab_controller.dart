import '../../../radartui.dart';

class TabController extends ChangeNotifier {
  TabController({
    int initialIndex = 0,
    required int length,
  })  : _index = initialIndex,
        _length = length;

  int _index;
  final int _length;

  int get index => _index;

  int get length => _length;

  void animateTo(int newIndex) {
    final int clamped = newIndex.clamp(0, _length - 1);
    if (clamped == _index) return;
    _index = clamped;
    notifyListeners();
  }
}

class DefaultTabController extends InheritedWidget {
  const DefaultTabController({
    super.key,
    required this.controller,
    required super.child,
  });

  final TabController controller;

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

class Tab {
  const Tab({this.text, this.icon});

  final String? text;
  final String? icon;
}

class TabBar extends StatefulWidget {
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

  final List<Tab> tabs;
  final TabController? controller;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsets? labelPadding;
  final ValueChanged<int>? onTap;
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
      _internalController = TabController(
        initialIndex: 0,
        length: widget.tabs.length,
      );
    }
    _controller.addListener(_onControllerChange);
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
        _internalController = TabController(
          initialIndex: 0,
          length: widget.tabs.length,
        );
      }
      widget.controller?.addListener(_onControllerChange);
    }
    if (widget.tabs.length != oldWidget.tabs.length) {
      if (widget.controller == null && _internalController != null) {
        _internalController!.dispose();
        _internalController = TabController(
          initialIndex: 0,
          length: widget.tabs.length,
        );
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
      final int newIndex =
          (controller.index - 1).clamp(0, widget.tabs.length - 1);
      if (newIndex != controller.index) {
        controller.animateTo(newIndex);
        widget.onTap?.call(newIndex);
      }
    } else if (event.code == KeyCode.arrowRight) {
      final int newIndex =
          (controller.index + 1).clamp(0, widget.tabs.length - 1);
      if (newIndex != controller.index) {
        controller.animateTo(newIndex);
        widget.onTap?.call(newIndex);
      }
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
      labelPadding:
          widget.labelPadding ?? const EdgeInsets.symmetric(horizontal: 1),
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

class RenderTabBar extends RenderBox {
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
  List<Tab> get tabs => _tabs;
  set tabs(List<Tab> value) {
    _tabs = value;
    _invalidateCache();
  }

  int _currentIndex;
  int get currentIndex => _currentIndex;
  set currentIndex(int v) {
    _currentIndex = v;
    _invalidateCache();
  }

  bool _focused;
  bool get focused => _focused;
  set focused(bool v) {
    _focused = v;
    _invalidateCache();
  }

  Color _indicatorColor;
  Color get indicatorColor => _indicatorColor;
  set indicatorColor(Color v) {
    _indicatorColor = v;
    _invalidateCache();
  }

  Color _labelColor;
  Color get labelColor => _labelColor;
  set labelColor(Color v) {
    _labelColor = v;
    _invalidateCache();
  }

  Color _unselectedLabelColor;
  Color get unselectedLabelColor => _unselectedLabelColor;
  set unselectedLabelColor(Color v) {
    _unselectedLabelColor = v;
    _invalidateCache();
  }

  TextStyle? _labelStyle;
  TextStyle? get labelStyle => _labelStyle;
  set labelStyle(TextStyle? v) {
    _labelStyle = v;
    _invalidateCache();
  }

  TextStyle? _unselectedLabelStyle;
  TextStyle? get unselectedLabelStyle => _unselectedLabelStyle;
  set unselectedLabelStyle(TextStyle? v) {
    _unselectedLabelStyle = v;
    _invalidateCache();
  }

  EdgeInsets _labelPadding;
  EdgeInsets get labelPadding => _labelPadding;
  set labelPadding(EdgeInsets v) {
    _labelPadding = v;
  }

  TextStyle? _cachedSelectedStyle;
  TextStyle? _cachedUnselectedStyle;
  TextStyle? _cachedIndicatorStyle;

  void _invalidateCache() {
    _cachedSelectedStyle = null;
    _cachedUnselectedStyle = null;
    _cachedIndicatorStyle = null;
  }

  @override
  void performLayout(Constraints constraints) {
    int totalWidth = 0;
    for (final tab in _tabs) {
      final int textLen = stringWidth(tab.text ?? '');
      final int iconLen =
          (tab.icon != null) ? charWidth(tab.icon!.codeUnitAt(0)) : 0;
      final int contentLen = textLen + iconLen;
      totalWidth += labelPadding.left + contentLen + labelPadding.right;
    }
    if (_tabs.isNotEmpty && _tabs.length > 1) {
      totalWidth += _tabs.length - 1;
    }
    size = Size(totalWidth, 2);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _ensureStylesCached();
    final int y = offset.y.toInt();
    int x = offset.x.toInt();
    for (int i = 0; i < _tabs.length; i++) {
      final Tab tab = _tabs[i];
      final bool isSelected = i == currentIndex;
      final TextStyle style =
          isSelected ? _cachedSelectedStyle! : _cachedUnselectedStyle!;
      x += labelPadding.left;
      x += _paintTabContent(context, x, y, tab, style);
      final int contentWidth = _tabContentWidth(tab);
      x += labelPadding.right;
      if (isSelected) {
        _paintSelectedIndicator(context, y,
            x - labelPadding.right - contentWidth, x - labelPadding.right);
      }
      if (i < _tabs.length - 1) x += 1;
    }
  }

  int _paintTabContent(
      PaintingContext context, int x, int y, Tab tab, TextStyle style) {
    int dx = 0;
    if (tab.icon != null) {
      context.buffer.writeStyled(x, y, tab.icon!, style);
      dx += charWidth(tab.icon!.codeUnitAt(0));
    }
    if (tab.text != null) {
      for (int j = 0; j < tab.text!.length; j++) {
        final String ch = tab.text![j];
        context.buffer.writeStyled(x + dx, y, ch, style);
        dx += charWidth(ch.codeUnitAt(0));
      }
    }
    return dx;
  }

  void _paintSelectedIndicator(
      PaintingContext context, int y, int start, int end) {
    final TextStyle style = _cachedIndicatorStyle!;
    for (int ix = start; ix < end; ix++) {
      context.buffer.writeStyled(ix, y + 1, '─', style);
    }
  }

  void _ensureStylesCached() {
    if (_cachedSelectedStyle != null) return;
    _cachedSelectedStyle =
        labelStyle ?? TextStyle(color: labelColor, bold: true);
    _cachedUnselectedStyle =
        unselectedLabelStyle ?? TextStyle(color: unselectedLabelColor);
    _cachedIndicatorStyle = TextStyle(color: indicatorColor);
  }

  int _tabContentWidth(Tab tab) {
    return stringWidth(tab.text ?? '') +
        (tab.icon != null ? charWidth(tab.icon!.codeUnitAt(0)) : 0);
  }
}

class TabBarView extends StatefulWidget {
  const TabBarView({
    super.key,
    required this.controller,
    required this.children,
  });

  final TabController controller;
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
