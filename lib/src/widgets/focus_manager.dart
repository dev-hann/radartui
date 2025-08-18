import 'dart:async';
import 'package:radartui/src/scheduler/binding.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/widgets/basic/focus.dart';
import 'package:radartui/src/widgets/navigation.dart';
import 'package:radartui/src/widgets/navigator_observer.dart';

class FocusManager extends NavigatorObserver {
  static FocusManager? _instance;
  static FocusManager get instance => _instance ??= FocusManager._();

  FocusManager._();

  FocusScope? _currentScope;
  FocusScope? get currentScope => _currentScope;
  StreamSubscription<KeyEvent>? _keySubscription;
  final List<FocusScope> _scopeStack = [];

  void initialize() {
    _keySubscription ??= SchedulerBinding.instance.keyboard.keyEvents.listen(
      _handleKeyEvent,
    );
  }

  void dispose() {
    _keySubscription?.cancel();
    _keySubscription = null;
    _currentScope = null;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _activateScope(FocusScope());
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _activateScope(FocusScope());
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _activateScope(FocusScope());
  }

  void _activateScope(FocusScope scope) {
    // Deactivate current scope
    _currentScope?.deactivate();
    
    // Set new current scope
    _currentScope = scope;
    
    // Activate the new scope
    scope.activate();
    
    // Trigger re-registration of all existing nodes
    _notifyNodesOfScopeChange();
    
    SchedulerBinding.instance.scheduleFrame();
  }

  void _notifyNodesOfScopeChange() {
    // This will trigger existing FocusNodes to re-register with the new scope
    // by calling ensureRegistered on all active widgets
    SchedulerBinding.instance.scheduleFrame();
  }

  void _handleKeyEvent(KeyEvent event) {
    final scope = _currentScope;
    if (scope == null) {
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
    _currentScope?.addNode(node);
  }

  void unregisterNode(FocusNode node) {
    _currentScope?.removeNode(node);
  }

  void requestFocus(FocusNode node) {
    _currentScope?.requestFocus(node);
  }

  void pushScope(FocusScope scope) {
    // Push current scope to stack before activating new one
    if (_currentScope != null) {
      _scopeStack.add(_currentScope!);
    }
    _activateScope(scope);
  }

  void popScope() {
    // Pop the most recent scope from stack and activate it
    if (_scopeStack.isNotEmpty) {
      final previousScope = _scopeStack.removeLast();
      _activateScope(previousScope);
    }
  }

  void activateScope(FocusScope scope) {
    _activateScope(scope);
  }

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}
