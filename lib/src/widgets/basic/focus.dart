import '../../../radartui.dart';

class FocusNode extends ChangeNotifier {
  FocusNode() {
    // Automatically register with current scope when created
    _autoRegister();
  }

  bool _hasFocus = false;
  FocusScope? _scope;
  Function(KeyEvent)? onKeyEvent;

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

  void _autoRegister() {
    // Simple auto-registration with current scope
    FocusManager.instance.registerNode(this);
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

  void addNode(FocusNode node) {
    if (!_nodes.contains(node)) {
      _nodes.add(node);
      node._scope = this;

      // Set focus to first node if this is the first one
      if (_nodes.length == 1 && _isActive) {
        node._setFocus(true);
      }
    }
  }

  void removeNode(FocusNode node) {
    final index = _nodes.indexOf(node);
    if (index != -1) {
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
      // Clear previous focus
      if (_currentIndex < _nodes.length) {
        _nodes[_currentIndex]._setFocus(false);
      }

      // Set new focus
      _currentIndex = index;
      _nodes[_currentIndex]._setFocus(true);
    }
  }

  void nextFocus() {
    if (_nodes.isNotEmpty) {
      final nextIndex = (_currentIndex + 1) % _nodes.length;
      _setFocusAtIndex(nextIndex);
    }
  }

  void previousFocus() {
    if (_nodes.isNotEmpty) {
      final prevIndex = (_currentIndex - 1) % _nodes.length;
      final index = prevIndex < 0 ? _nodes.length - 1 : prevIndex;
      _setFocusAtIndex(index);
    }
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

    // Set focus to first node when activating
    if (_nodes.isNotEmpty) {
      _currentIndex = 0;
      _nodes[_currentIndex]._setFocus(true);
    }
  }

  void deactivate() {
    _isActive = false;
    // Clear focus from all nodes
    for (final node in _nodes) {
      node._setFocus(false);
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
  final FocusNode? focusNode;
  final Function(KeyEvent)? onKeyEvent;
  final Widget child;

  const Focus({this.focusNode, this.onKeyEvent, required this.child});

  @override
  State<Focus> createState() => _FocusState();
}

class _FocusState extends State<Focus> {
  late FocusNode _focusNode;
  bool _isNodeOwned = false;

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isNodeOwned = true;
    }
    _focusNode.onKeyEvent = widget.onKeyEvent;
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(Focus oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      if (_isNodeOwned) {
        _focusNode.dispose();
      }

      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _isNodeOwned = false;
      } else {
        _focusNode = FocusNode();
        _isNodeOwned = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isNodeOwned) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
