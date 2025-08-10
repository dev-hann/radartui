import '../../services/key_parser.dart';
import '../focus_manager.dart';

class FocusNode {
  bool _hasFocus = false;
  FocusScope? _scope;
  Function(KeyEvent)? onKeyEvent;

  FocusNode() {
    // Automatically register with the currently active FocusScope
    _autoRegister();
  }

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

  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _autoRegister() {
    final currentScope = FocusManager.instance.currentScope;
    if (currentScope != null) {
      // 이미 다른 scope에 등록되어 있다면 제거
      if (_scope != null && _scope != currentScope) {
        _scope!._removeNode(this);
      }
      currentScope.addNode(this);
    }
  }

  void ensureRegistered() {
    final currentScope = FocusManager.instance.currentScope;
    if (currentScope != null && _scope != currentScope) {
      _autoRegister();
      // 등록 후 바로 포커스 요청
      requestFocus();
    }
  }

  void dispose() {
    _listeners.clear();
    _scope?._removeNode(this);
  }
}

class FocusScope {
  final List<FocusNode> _nodes = [];
  int _currentIndex = 0;

  void addNode(FocusNode node) {
    if (!_nodes.contains(node)) {
      _nodes.add(node);
      node._scope = this;

      // Automatically set focus to the first node
      if (_nodes.length == 1) {
        node._setFocus(true);
      }
    }
  }

  void _removeNode(FocusNode node) {
    final index = _nodes.indexOf(node);
    if (index != -1) {
      _nodes.removeAt(index);
      node._scope = null;

      // 현재 포커스된 노드가 제거되면 다음 노드로 이동
      if (index <= _currentIndex && _nodes.isNotEmpty) {
        _currentIndex = _currentIndex.clamp(0, _nodes.length - 1);
        _nodes[_currentIndex]._setFocus(true);
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
    if (index >= 0 && index < _nodes.length) {
      // 이전 포커스 해제
      if (_currentIndex < _nodes.length) {
        _nodes[_currentIndex]._setFocus(false);
      }

      // 새로운 포커스 설정
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

  void removeNode(FocusNode node) {
    _removeNode(node);
  }

  void requestFocus(FocusNode node) {
    setFocus(node);
  }

  void notifyAllNodes() {
    // When reactivating the scope, first set all nodes to false
    for (final node in _nodes) {
      if (node._hasFocus) {
        node._setFocus(false);
      }
    }
    // Then set focus only to the node at the current index
    if (_nodes.isNotEmpty) {
      final index = _currentIndex.clamp(0, _nodes.length - 1);
      _nodes[index]._setFocus(true);
      _currentIndex = index;
    }
  }

  void dispose() {
    for (final node in _nodes) {
      node._scope = null;
    }
    _nodes.clear();
  }
}

// FocusManager is imported from focus_manager.dart
// This file only manages the basic FocusScope
