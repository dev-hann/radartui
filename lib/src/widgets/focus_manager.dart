import 'dart:async';
import '../binding.dart';
import '../services.dart';
import 'basic/focus.dart';
import 'navigation.dart';
import 'navigator_observer.dart';

class _SavedScope {
  _SavedScope(this.scope, this.focusedNode);
  final FocusScope scope;
  final FocusNode? focusedNode;
}

class FocusManager extends NavigatorObserver {
  FocusManager._();
  static FocusManager? _instance;
  static FocusManager get instance => _instance ??= FocusManager._();

  FocusScope? _currentScope;
  final List<_SavedScope> _savedScopes = [];
  FocusScope? get currentScope => _currentScope;
  StreamSubscription<KeyEvent>? _keySubscription;
  Stream<KeyEvent>? _testKeyEvents;

  void setTestKeyEvents(Stream<KeyEvent> stream) {
    _testKeyEvents = stream;
  }

  void initialize() {
    _keySubscription?.cancel();
    Stream<KeyEvent> stream;
    if (_testKeyEvents != null) {
      stream = _testKeyEvents!;
    } else {
      stream = WidgetsBinding.instance.keyboard.keyEvents;
    }
    _keySubscription = stream.listen(_handleKeyEvent);
  }

  void dispose() {
    _keySubscription?.cancel();
    _keySubscription = null;
    _currentScope?.dispose();
    _currentScope = null;
    for (final saved in _savedScopes) {
      saved.scope.dispose();
    }
    _savedScopes.clear();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _pushScope();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _popScope();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _pushScope();
  }

  void _pushScope() {
    if (_currentScope != null) {
      _savedScopes.add(
        _SavedScope(_currentScope!, _currentScope!.currentFocus),
      );
      _currentScope!.deactivate();
    }
    _currentScope = FocusScope();
    _currentScope!.activate();
    WidgetsBinding.instance.scheduleFrame();
  }

  void _popScope() {
    _currentScope?.dispose();
    if (_savedScopes.isNotEmpty) {
      final saved = _savedScopes.removeLast();
      _currentScope = saved.scope;
      _currentScope!.activate();
      if (saved.focusedNode != null &&
          _currentScope!.nodes.contains(saved.focusedNode) &&
          saved.focusedNode!.canRequestFocus) {
        _currentScope!.setFocus(saved.focusedNode!);
      }
    } else {
      _currentScope = null;
    }
    WidgetsBinding.instance.scheduleFrame();
  }

  void _handleKeyEvent(KeyEvent event) {
    final scope = _currentScope;
    if (scope == null) {
      return;
    }

    final current = scope.currentFocus;
    if (current != null && current.trapFocus && event.code == KeyCode.tab) {
      current.onKeyEvent?.call(event);
      return;
    }

    if (event.code == KeyCode.tab) {
      if (event.isShiftPressed) {
        scope.previousFocus();
      } else {
        scope.nextFocus();
      }
    } else {
      scope.currentFocus?.onKeyEvent?.call(event);
    }
  }

  void registerNode(FocusNode node) {
    if (_currentScope == null) {
      _currentScope = FocusScope();
      _currentScope!.activate();
    }
    _currentScope!.addNode(node);
  }

  void unregisterNode(FocusNode node) {
    _currentScope?.removeNode(node);
  }

  void requestFocus(FocusNode node) {
    _currentScope?.requestFocus(node);
  }

  void pushDialogScope() {
    _pushScope();
  }

  void popDialogScope() {
    _popScope();
  }

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}
