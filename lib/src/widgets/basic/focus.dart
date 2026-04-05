import '../../../radartui.dart';

class FocusNode extends ChangeNotifier {
  FocusNode({this.canRequestFocus = true});

  bool _hasFocus = false;
  FocusScope? _scope;
  Function(KeyEvent)? onKeyEvent;
  bool canRequestFocus;
  bool trapFocus = false;

  bool get hasFocus => _hasFocus;

  void requestFocus() {
    _scope?.setFocus(this);
  }

  void unfocus() {
    if (_hasFocus) {
      _hasFocus = false;
      notifyListeners();
    }
  }

  void _setFocus(bool value) {
    if (_hasFocus != value) {
      _hasFocus = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    FocusManager.instance.unregisterNode(this);
    super.dispose();
  }
}

class FocusScope {
  final List<FocusNode> _nodes = [];
  int _currentIndex = 0;
  bool _isActive = false;
  FocusNode? _focusedChild;

  FocusNode? get focusedChild => _focusedChild;

  List<FocusNode> get _focusableNodes {
    return _nodes.where((FocusNode n) => n.canRequestFocus).toList();
  }

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

  void removeNode(FocusNode node) {
    final index = _nodes.indexOf(node);
    if (index != -1) {
      node._setFocus(false);
      _nodes.removeAt(index);
      node._scope = null;

      // Adjust current index if needed
      if (index <= _currentIndex && _nodes.isNotEmpty) {
        _currentIndex = _currentIndex.clamp(0, _nodes.length - 1);
        if (_isActive) {
          _nodes[_currentIndex]._setFocus(true);
        }
      }
    }
  }

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

  FocusNode? get currentFocus {
    return _nodes.isNotEmpty ? _nodes[_currentIndex] : null;
  }

  List<FocusNode> get nodes => _nodes;

  void requestFocus(FocusNode node) {
    setFocus(node);
  }

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

  void deactivate() {
    _isActive = false;
    for (final node in _nodes) {
      node._setFocus(false);
    }
  }

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

  bool get isActive => _isActive;

  void dispose() {
    deactivate();
    // Clear all nodes
    for (final node in _nodes) {
      node._scope = null;
    }
    _nodes.clear();
  }
}

class Focus extends StatefulWidget {
  const Focus({
    super.key,
    this.focusNode,
    this.onKeyEvent,
    required this.child,
  });
  final FocusNode? focusNode;
  final Function(KeyEvent)? onKeyEvent;
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
