import '../../services/key_parser.dart';
import '../focus_manager.dart';

class FocusNode {
  bool _hasFocus = false;
  FocusScope? _scope;
  Function(KeyEvent)? onKeyEvent;

  FocusNode() {
    // 자동으로 현재 활성화된 FocusScope에 등록
    _autoRegister();
  }

  bool get hasFocus => _hasFocus;

  void requestFocus() {
    _scope?.setFocus(this);
  }

  void unfocus() {
    if (_hasFocus) {
      _hasFocus = false;
      _notifyListeners();
    }
  }

  void _setFocus(bool value) {
    if (_hasFocus != value) {
      _hasFocus = value;
      _notifyListeners();
    }
  }

  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _autoRegister() {
    final currentScope = FocusManager.instance.currentScope;
    currentScope?.addNode(this);
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

      // 첫 번째 노드에 자동으로 포커스 설정
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

  void removeNode(FocusNode node) {
    _removeNode(node);
  }

  void requestFocus(FocusNode node) {
    setFocus(node);
  }

  void dispose() {
    for (final node in _nodes) {
      node._scope = null;
    }
    _nodes.clear();
  }
}

// FocusManager는 focus_manager.dart에서 import됨
// 이 파일에서는 기본적인 FocusScope만 관리
