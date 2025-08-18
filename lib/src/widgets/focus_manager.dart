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
    // Re-register all existing focus nodes with the new current scope
    _reregisterAllNodes();
  }

  void _reregisterAllNodes() {
    // Force all widgets to rebuild and re-register their focus nodes
    // This simulates what happens during navigation
    SchedulerBinding.instance.scheduleFrame();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _rebuildAllFocusNodes();
    });
  }

  void _rebuildAllFocusNodes() {
    // This will be called after the frame to ensure all widgets are built
    // and can re-register their focus nodes with the current scope
    final currentScope = _currentScope;
    if (currentScope != null && currentScope.isActive) {
      // The widgets will automatically re-register during their next build cycle
      SchedulerBinding.instance.scheduleFrame();
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
      
      // Force all widgets to re-register with the restored scope
      _triggerWidgetReregistration();
    }
  }

  void _triggerWidgetReregistration() {
    // Navigation-style focus re-registration: re-register all existing nodes
    final allExistingNodes = <FocusNode>[];
    
    // Collect all nodes from all scopes in the stack + current scope
    for (final scope in _scopeStack) {
      allExistingNodes.addAll(scope.nodes);
    }
    if (_currentScope != null) {
      allExistingNodes.addAll(_currentScope!.nodes);
    }
    
    // Re-register all nodes with the current active scope
    if (_currentScope != null && _currentScope!.isActive) {
      for (final node in allExistingNodes) {
        node.ensureRegistered();
      }
    }
    
    // Schedule frame to ensure UI updates
    SchedulerBinding.instance.scheduleFrame();
  }

  void activateScope(FocusScope scope) {
    _activateScope(scope);
  }

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}
