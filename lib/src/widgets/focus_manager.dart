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
    _createNewScope();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _createNewScope();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _createNewScope();
  }

  void createNewScope() {
    // Create completely new scope (like page navigation)
    _clearCurrentScope();
    _currentScope = FocusScope();
    _currentScope!.activate();
    SchedulerBinding.instance.scheduleFrame();
  }

  void _createNewScope() => createNewScope();

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

  // Dialog-specific methods: clean navigation-style approach
  void pushDialogScope() {
    // Save current scope to stack
    if (_currentScope != null) {
      _currentScope!.deactivate(); // Deactivate but don't dispose yet
      _scopeStack.add(_currentScope!);
    }

    // Create completely new scope for dialog (clean slate)
    _currentScope = FocusScope();
    _currentScope!.activate();
    
    // Schedule frame to trigger widget rebuilds
    SchedulerBinding.instance.scheduleFrame();
  }

  void popDialogScope() {
    // Completely dispose current dialog scope
    if (_currentScope != null) {
      _currentScope!.dispose();
      _currentScope = null;
    }

    // Restore previous scope if exists
    if (_scopeStack.isNotEmpty) {
      _currentScope = _scopeStack.removeLast();
      _currentScope!.activate();
    } else {
      // No previous scope, create new one
      _currentScope = FocusScope();
      _currentScope!.activate();
    }

    // Force complete UI rebuild (like navigation)
    SchedulerBinding.instance.scheduleFrame();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Trigger another frame to ensure widgets re-register their focus nodes
      SchedulerBinding.instance.scheduleFrame();
    });
  }

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}