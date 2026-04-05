import '../../../radartui.dart';

/// Represents a focus scope node in the focus tree.
///
/// Each [FocusNode] can receive or relinquish keyboard focus. Use [Focus]
/// widget to attach a [FocusNode] to the tree, and [FocusScopeNode] to
/// create focus boundaries.
class FocusNode extends ChangeNotifier {
  /// Creates a [FocusNode] with an optional [canRequestFocus] flag.
  FocusNode({this.canRequestFocus = true});

  bool _hasFocus = false;
  FocusScope? _scope;

  /// An optional callback invoked when a key event reaches this node.
  Function(KeyEvent)? onKeyEvent;

  /// Whether this node is allowed to request focus.
  bool canRequestFocus;

  /// When `true`, focus is trapped within this node's subtree.
  bool trapFocus = false;

  /// Whether this node currently has keyboard focus.
  bool get hasFocus => _hasFocus;

  /// Requests keyboard focus for this node.
  void requestFocus() {
    _scope?.setFocus(this);
  }

  /// Removes focus from this node.
  void unfocus() {
    if (_hasFocus) {
      _hasFocus = false;
      notifyListeners();
    }
  }

  void _setFocus(bool value) {
    if (_hasFocus == value) return;
    _hasFocus = value;
    notifyListeners();
  }

  @override
  void dispose() {
    FocusManager.instance.unregisterNode(this);
    super.dispose();
  }
}

/// Manages a group of [FocusNode]s within a focus scope.
///
/// Handles focus traversal (next/previous), activation, and deactivation
/// of all registered nodes.
class FocusScope {
  final List<FocusNode> _nodes = [];
  int _currentIndex = 0;
  bool _isActive = false;
  FocusNode? _focusedChild;

  /// The [FocusNode] that currently has focus within this scope.
  FocusNode? get focusedChild => _focusedChild;

  List<FocusNode> get _focusableNodes {
    return _nodes.where((FocusNode n) => n.canRequestFocus).toList();
  }

  /// Registers [node] with this scope.
  void addNode(FocusNode node) {
    if (!_nodes.contains(node)) {
      _nodes.add(node);
      node._scope = this;

      if (_nodes.length == 1 && _isActive) {
        node._setFocus(true);
        _focusedChild = node;
      }
    }
  }

  /// Removes [node] from this scope and transfers focus if needed.
  void removeNode(FocusNode node) {
    final index = _nodes.indexOf(node);
    if (index != -1) {
      _removeNodeAtIndex(node, index);
    }
  }

  void _removeNodeAtIndex(FocusNode node, int index) {
    node._setFocus(false);
    _nodes.removeAt(index);
    node._scope = null;
    if (index <= _currentIndex && _nodes.isNotEmpty) {
      _currentIndex = _currentIndex.clamp(0, _nodes.length - 1);
      if (_isActive) {
        _nodes[_currentIndex]._setFocus(true);
      }
    }
  }

  /// Gives focus to [node] within this scope.
  void setFocus(FocusNode node) {
    final index = _nodes.indexOf(node);
    if (index != -1) {
      _setFocusAtIndex(index);
    }
  }

  void _setFocusAtIndex(int index) {
    if (index >= 0 && index < _nodes.length && _isActive) {
      if (_currentIndex < _nodes.length) {
        _nodes[_currentIndex]._setFocus(false);
      }

      _currentIndex = index;
      _nodes[_currentIndex]._setFocus(true);
      _focusedChild = _nodes[_currentIndex];
    }
  }

  /// Moves focus to the next focusable node in the scope.
  void nextFocus() {
    final chain = _focusableNodes;
    if (chain.isEmpty) return;
    final current = _nodes[_currentIndex];
    final chainIndex = chain.indexOf(current);
    final nextChainIndex = (chainIndex + 1) % chain.length;
    final target = chain[nextChainIndex];
    final targetIndex = _nodes.indexOf(target);
    _setFocusAtIndex(targetIndex);
  }

  /// Moves focus to the previous focusable node in the scope.
  void previousFocus() {
    final chain = _focusableNodes;
    if (chain.isEmpty) return;
    final current = _nodes[_currentIndex];
    final chainIndex = chain.indexOf(current);
    final prevChainIndex = (chainIndex - 1 + chain.length) % chain.length;
    final target = chain[prevChainIndex];
    final targetIndex = _nodes.indexOf(target);
    _setFocusAtIndex(targetIndex);
  }

  /// The currently focused node, or `null` if no nodes exist.
  FocusNode? get currentFocus {
    return _nodes.isNotEmpty ? _nodes[_currentIndex] : null;
  }

  /// The list of all registered nodes in this scope.
  List<FocusNode> get nodes => _nodes;

  /// Requests focus for [node] (alias for [setFocus]).
  void requestFocus(FocusNode node) {
    setFocus(node);
  }

  /// Activates this scope, restoring focus to the last focused child.
  void activate() {
    _isActive = true;

    if (_focusedChild != null && _nodes.contains(_focusedChild)) {
      final index = _nodes.indexOf(_focusedChild!);
      _currentIndex = index;
      _nodes[_currentIndex]._setFocus(true);
    } else if (_nodes.isNotEmpty) {
      final focusable = _focusableNodes;
      if (focusable.isNotEmpty) {
        final first = focusable.first;
        _currentIndex = _nodes.indexOf(first);
        first._setFocus(true);
        _focusedChild = first;
      }
    }
  }

  /// Deactivates this scope, removing focus from all nodes.
  void deactivate() {
    _isActive = false;
    for (final node in _nodes) {
      node._setFocus(false);
    }
  }

  /// Restores focus to the previously focused child or the first focusable node.
  void restoreFocus() {
    if (_focusedChild != null &&
        _nodes.contains(_focusedChild) &&
        _focusedChild!.canRequestFocus) {
      setFocus(_focusedChild!);
    } else if (_nodes.isNotEmpty) {
      final focusable = _focusableNodes;
      if (focusable.isNotEmpty) {
        setFocus(focusable.first);
      }
    }
  }

  /// Whether this scope is currently active.
  bool get isActive => _isActive;

  /// Deactivates the scope and clears all registered nodes.
  void dispose() {
    deactivate();
    for (final node in _nodes) {
      node._scope = null;
    }
    _nodes.clear();
  }
}

/// A widget that attaches a [FocusNode] to the widget tree and forwards key events.
///
/// Wrap a child widget with [Focus] to make it part of the focus traversal
/// and receive keyboard events via [onKeyEvent].
class Focus extends StatefulWidget {
  /// Creates a [Focus] widget with an optional [focusNode] and [onKeyEvent].
  const Focus({
    super.key,
    this.focusNode,
    this.onKeyEvent,
    required this.child,
  });

  /// An optional external focus node.
  final FocusNode? focusNode;

  /// A callback invoked when a key event reaches this node.
  final Function(KeyEvent)? onKeyEvent;

  /// The child widget that receives focus.
  final Widget child;

  @override
  State<Focus> createState() => _FocusState();
}

class _FocusState extends State<Focus> with FocusableState<Focus> {
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    widget.onKeyEvent?.call(event);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
