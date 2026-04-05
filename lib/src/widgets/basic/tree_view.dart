import '../../../radartui.dart';

/// Manages the expand/collapse state of a [TreeView].
///
/// Each node is identified by an [Object] key. Use [toggleExpansion] to expand
/// or collapse, and [isExpanded] to query state.
class TreeController extends ChangeNotifier {
  /// Creates a [TreeController] with optional [initialExpandedKeys].
  TreeController({Set<Object>? initialExpandedKeys})
      : _expandedKeys = Set<Object>.from(initialExpandedKeys ?? <Object>{});

  Set<Object> _expandedKeys;

  /// The set of currently expanded node keys.
  Set<Object> get expandedKeys => Set<Object>.from(_expandedKeys);

  /// Returns `true` if the node identified by [key] is expanded.
  bool isExpanded(Object key) => _expandedKeys.contains(key);

  /// Toggles the expansion state of the node identified by [key].
  void toggleExpansion(Object key) {
    if (_expandedKeys.contains(key)) {
      _expandedKeys.remove(key);
    } else {
      _expandedKeys.add(key);
    }
    notifyListeners();
  }

  /// Expands the node identified by [key].
  void expand(Object key) {
    if (_expandedKeys.add(key)) {
      notifyListeners();
    }
  }

  /// Collapses the node identified by [key].
  void collapse(Object key) {
    if (_expandedKeys.remove(key)) {
      notifyListeners();
    }
  }

  /// Expands all nodes whose keys are in [allKeys].
  void expandAll(List<Object> allKeys) {
    _expandedKeys = Set<Object>.from(allKeys);
    notifyListeners();
  }

  /// Collapses all nodes.
  void collapseAll() {
    _expandedKeys.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _expandedKeys.clear();
    super.dispose();
  }
}

class _FlatNode<T> {
  const _FlatNode({required this.node, required this.depth});
  final T node;
  final int depth;
}

/// A collapsible tree view that renders hierarchical data.
///
/// Uses [roots] as the top-level nodes and [getChildren] to traverse deeper.
/// Each node is built by [builder]. The [TreeController] manages expand/collapse state.
class TreeView<T> extends StatefulWidget {
  /// Creates a [TreeView] with the given [roots], [builder], and traversal callbacks.
  const TreeView({
    super.key,
    required this.roots,
    required this.builder,
    required this.getChildren,
    required this.nodeKey,
    this.isExpandable,
    this.controller,
    this.focusNode,
    this.onNodeSelected,
  });

  /// The top-level tree nodes.
  final List<T> roots;

  /// Builds the visual representation for each node at the given [depth].
  final Widget Function(T node, int depth, bool isExpanded) builder;

  /// Returns the child nodes of the given [node].
  final List<T> Function(T node) getChildren;

  /// Returns a unique key identifying [node].
  final Object Function(T node) nodeKey;

  /// An optional predicate that returns whether [node] can be expanded.
  final bool Function(T node)? isExpandable;

  /// An optional external controller for expand/collapse state.
  final TreeController? controller;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Called when the user activates a node.
  final void Function(T node)? onNodeSelected;

  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();
}

class _TreeViewState<T> extends State<TreeView<T>>
    with FocusableState<TreeView<T>> {
  late TreeController _controller;
  bool _ownsController = false;
  int _selectedIndex = 0;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TreeController();
      _ownsController = true;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(TreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _initController();
    }
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  void onKeyEvent(KeyEvent event) {
    final flatNodes = _buildFlatNodes();
    if (flatNodes.isEmpty) return;

    if (event.code == KeyCode.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, flatNodes.length - 1);
      });
    } else if (event.code == KeyCode.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, flatNodes.length - 1);
      });
    } else if (event.isActivationKey) {
      _handleActivate(flatNodes);
    }
  }

  void _handleActivate(List<_FlatNode<T>> flatNodes) {
    if (_selectedIndex < 0 || _selectedIndex >= flatNodes.length) return;
    final flat = flatNodes[_selectedIndex];
    final key = widget.nodeKey(flat.node);
    final canExpand = widget.isExpandable?.call(flat.node) ??
        widget.getChildren(flat.node).isNotEmpty;
    if (canExpand) {
      _controller.toggleExpansion(key);
    }
    widget.onNodeSelected?.call(flat.node);
  }

  List<_FlatNode<T>> _buildFlatNodes() {
    final result = <_FlatNode<T>>[];
    for (final root in widget.roots) {
      _flattenNode(root, 0, result);
    }
    return result;
  }

  void _flattenNode(T node, int depth, List<_FlatNode<T>> result) {
    result.add(_FlatNode<T>(node: node, depth: depth));
    final key = widget.nodeKey(node);
    if (_controller.isExpanded(key)) {
      for (final child in widget.getChildren(node)) {
        _flattenNode(child, depth + 1, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final flatNodes = _buildFlatNodes();
    if (flatNodes.isEmpty) {
      return const SizedBox();
    }

    _selectedIndex = _selectedIndex.clamp(0, flatNodes.length - 1);

    final children = <Widget>[];
    for (int i = 0; i < flatNodes.length; i++) {
      final flat = flatNodes[i];
      final key = widget.nodeKey(flat.node);
      final expanded = _controller.isExpanded(key);
      children.add(widget.builder(flat.node, flat.depth, expanded));
    }

    return Column(children: children);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }
}
