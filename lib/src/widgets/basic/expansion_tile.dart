import 'dart:math' as math;

import '../../../radartui.dart';

/// Controls the expanded/collapsed state of an [ExpansionTile].
///
/// Obtain via [ExpansionTile.of] and call [toggle], [expand], or [collapse].
class ExpansionTileController extends ChangeNotifier {
  bool _isExpanded = false;

  /// Whether the tile is currently expanded.
  bool get isExpanded => _isExpanded;

  /// Expands the tile if currently collapsed.
  void expand() {
    if (_isExpanded) return;
    _isExpanded = true;
    notifyListeners();
  }

  /// Collapses the tile if currently expanded.
  void collapse() {
    if (!_isExpanded) return;
    _isExpanded = false;
    notifyListeners();
  }

  /// Toggles between expanded and collapsed states.
  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}

/// A widget that expands or collapses to reveal [children] below a [title].
///
/// Press Enter or Space to toggle. Use [ExpansionTileController] for
/// programmatic control over the expanded state.
class ExpansionTile extends StatefulWidget {
  /// Creates an [ExpansionTile] with the given [title] and optional [children].
  const ExpansionTile({
    super.key,
    required this.title,
    this.children = const [],
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.controller,
    this.expandedColor,
    this.collapsedColor,
    this.iconColor,
    this.focusNode,
  });

  /// The title text displayed in the header row.
  final String title;

  /// The child widgets revealed when expanded.
  final List<Widget> children;

  /// Whether the tile starts in the expanded state.
  final bool initiallyExpanded;

  /// Called when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// An optional external controller for the expansion state.
  final ExpansionTileController? controller;

  /// The color of the title text when expanded.
  final Color? expandedColor;

  /// The color of the title text when collapsed.
  final Color? collapsedColor;

  /// The color of the expand/collapse arrow icon.
  final Color? iconColor;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  @override
  State<ExpansionTile> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile>
    with FocusableState<ExpansionTile> {
  late ExpansionTileController _controller;
  bool _isControllerOwned = false;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = ExpansionTileController();
      _isControllerOwned = true;
    }
    if (widget.initiallyExpanded) {
      _controller._isExpanded = true;
    }
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    setState(() {});
    widget.onExpansionChanged?.call(_controller.isExpanded);
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (event.isActivationKey) {
      _controller.toggle();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    if (_isControllerOwned) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expanded = _controller.isExpanded;
    return _ExpansionTileRenderWidget(
      title: widget.title,
      expanded: expanded,
      focused: hasFocus,
      expandedColor: widget.expandedColor ?? Color.cyan,
      collapsedColor: widget.collapsedColor ?? Color.white,
      iconColor: widget.iconColor ?? Color.white,
      children: expanded ? widget.children : const [],
    );
  }
}

class _ExpansionTileRenderWidget extends MultiChildRenderObjectWidget {
  const _ExpansionTileRenderWidget({
    required this.title,
    required this.expanded,
    required this.focused,
    required this.expandedColor,
    required this.collapsedColor,
    required this.iconColor,
    required super.children,
  });

  final String title;
  final bool expanded;
  final bool focused;
  final Color expandedColor;
  final Color collapsedColor;
  final Color iconColor;

  @override
  MultiChildRenderObjectElement createElement() =>
      MultiChildRenderObjectElement(this);

  @override
  RenderExpansionTile createRenderObject(BuildContext context) =>
      RenderExpansionTile(
        title: title,
        expanded: expanded,
        focused: focused,
        expandedColor: expandedColor,
        collapsedColor: collapsedColor,
        iconColor: iconColor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final render = renderObject as RenderExpansionTile;
    final bool needsLayout =
        render.title != title || render.expanded != expanded;
    render.title = title;
    render.expanded = expanded;
    render.focused = focused;
    render.expandedColor = expandedColor;
    render.collapsedColor = collapsedColor;
    render.iconColor = iconColor;
    if (needsLayout) {
      render.markNeedsLayout();
    }
  }
}

/// Parent data for children of [RenderExpansionTile], storing their offset.
class ExpansionTileParentData extends ParentData {
  /// The offset at which this child is painted.
  Offset offset = Offset.zero;
}

/// Render object that paints an expandable tile with a header and children.
class RenderExpansionTile extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ExpansionTileParentData> {
  /// Creates a [RenderExpansionTile] with the given title and visual configuration.
  RenderExpansionTile({
    required String title,
    required bool expanded,
    required bool focused,
    required Color expandedColor,
    required Color collapsedColor,
    required Color iconColor,
  })  : _title = title,
        _expanded = expanded,
        _focused = focused,
        _expandedColor = expandedColor,
        _collapsedColor = collapsedColor,
        _iconColor = iconColor;

  String _title;
  bool _expanded;
  bool _focused;
  Color _expandedColor;
  Color _collapsedColor;
  Color _iconColor;

  /// The title text displayed in the header.
  String get title => _title;

  /// Sets the title text and invalidates the paint cache.
  set title(String v) {
    if (_title == v) return;
    _title = v;
    _invalidateCache();
    markNeedsLayout();
  }

  /// Whether the tile is currently expanded.
  bool get expanded => _expanded;

  /// Sets the expanded state and invalidates the paint cache.
  set expanded(bool v) {
    if (_expanded == v) return;
    _expanded = v;
    _invalidateCache();
    markNeedsLayout();
  }

  /// Whether the tile currently has keyboard focus.
  bool get focused => _focused;

  /// Sets the focus state and invalidates the paint cache.
  set focused(bool v) {
    if (_focused == v) return;
    _focused = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the title when expanded.
  Color get expandedColor => _expandedColor;

  /// Sets the expanded title color and invalidates the paint cache.
  set expandedColor(Color v) {
    if (_expandedColor == v) return;
    _expandedColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the title when collapsed.
  Color get collapsedColor => _collapsedColor;

  /// Sets the collapsed title color and invalidates the paint cache.
  set collapsedColor(Color v) {
    if (_collapsedColor == v) return;
    _collapsedColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  /// The color of the expand/collapse arrow icon.
  Color get iconColor => _iconColor;

  /// Sets the icon color and invalidates the paint cache.
  set iconColor(Color v) {
    if (_iconColor == v) return;
    _iconColor = v;
    _invalidateCache();
    markNeedsPaint();
  }

  TextStyle? _cachedIconStyle;
  TextStyle? _cachedTitleStyle;
  TextStyle? _cachedTitleBoldStyle;
  int? _cachedTitleWidth;

  void _invalidateCache() {
    _cachedIconStyle = null;
    _cachedTitleStyle = null;
    _cachedTitleBoldStyle = null;
    _cachedTitleWidth = null;
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ExpansionTileParentData) {
      child.parentData = ExpansionTileParentData();
    }
  }

  @override
  void performLayout(Constraints constraints) {
    _cachedTitleWidth ??= stringWidth(title);
    final int headerWidth = 2 + _cachedTitleWidth!;
    const int headerH = 1;

    int maxChildWidth = headerWidth;
    int totalChildHeight = 0;

    if (expanded) {
      for (final child in children) {
        child.layout(constraints);
        final ExpansionTileParentData childData =
            child.parentData as ExpansionTileParentData;
        childData.offset = Offset(2, headerH + totalChildHeight);
        maxChildWidth = math.max(maxChildWidth, child.size!.width);
        totalChildHeight += child.size!.height;
      }
    }

    final int childAndBorder = maxChildWidth + 2;
    final int totalWidth = math.max(childAndBorder, headerWidth);
    final int totalHeight = headerH + totalChildHeight;
    size = Size(totalWidth, totalHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paintHeader(context, offset.x, offset.y);
    if (expanded) {
      for (final child in children) {
        final ExpansionTileParentData childData =
            child.parentData as ExpansionTileParentData;
        context.paintChild(child, offset + childData.offset);
      }
    }
  }

  void _paintHeader(PaintingContext context, int x, int y) {
    _ensureStylesCached();
    final String arrow = expanded ? '▼' : '▶';
    context.buffer.writeStyled(x, y, arrow, _cachedIconStyle!);
    context.buffer.writeStyled(x + 1, y, ' ', _cachedTitleStyle!);
    context.writeString(x + 2, y, title, _cachedTitleBoldStyle!);
  }

  void _ensureStylesCached() {
    if (_cachedIconStyle != null) return;
    final Color titleColor = expanded ? expandedColor : collapsedColor;
    _cachedIconStyle = TextStyle(color: iconColor);
    _cachedTitleStyle = TextStyle(color: titleColor);
    _cachedTitleBoldStyle = TextStyle(color: titleColor, bold: focused);
  }
}
