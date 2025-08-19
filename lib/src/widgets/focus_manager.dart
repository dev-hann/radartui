import 'dart:async';
import '../scheduler.dart';
import '../services.dart';
import 'basic/focus.dart';
import 'navigation.dart';
import 'navigator_observer.dart';

class FocusManager extends NavigatorObserver {
  static FocusManager? _instance;
  static FocusManager get instance => _instance ??= FocusManager._();

  FocusManager._();

  FocusScope? _currentScope;
  FocusScope? get currentScope => _currentScope;
  StreamSubscription<KeyEvent>? _keySubscription;

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
    createNewScope();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    createNewScope();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    createNewScope();
  }

  void createNewScope() {
    _clearCurrentScope();
    _currentScope = FocusScope();
    _currentScope!.activate();
    SchedulerBinding.instance.scheduleFrame();
  }

  void _clearCurrentScope() {
    if (_currentScope != null) {
      _currentScope!.dispose();
      _currentScope = null;
    }
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

  void pushDialogScope() {
    createNewScope();
  }

  void popDialogScope() {
    _clearCurrentScope();
  }

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}
