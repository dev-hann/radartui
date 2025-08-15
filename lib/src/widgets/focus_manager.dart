import 'dart:async';
import 'package:radartui/src/scheduler/binding.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/services/logger.dart';
import 'package:radartui/src/widgets/basic/focus.dart';
import 'package:radartui/src/widgets/navigation.dart';
import 'package:radartui/src/widgets/navigator_observer.dart';

class FocusManager extends NavigatorObserver {
  static FocusManager? _instance;
  static FocusManager get instance => _instance ??= FocusManager._();

  FocusManager._();

  final Map<Route, FocusScope> _routeScopes = {};
  FocusScope? _currentScope;
  StreamSubscription<KeyEvent>? _keySubscription;

  FocusScope? get currentScope => _currentScope;

  void initialize() {
    _keySubscription ??= SchedulerBinding.instance.keyboard.keyEvents.listen(
      _handleKeyEvent,
    );
  }

  void dispose() {
    _keySubscription?.cancel();
    _keySubscription = null;
    for (final scope in _routeScopes.values) {
      scope.dispose();
    }
    _routeScopes.clear();
    _currentScope = null;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final newScope = _getOrCreateScope(route);
    _activateScope(newScope);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeScopes.remove(route)?.dispose();

    if (previousRoute != null) {
      final previousScope = _routeScopes[previousRoute];
      if (previousScope != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _activateScope(previousScope);
          
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _ensureNodesRegistered(previousScope);
            previousScope.notifyAllNodes();
          });
        });
      } else {
        final newScope = _getOrCreateScope(previousRoute);
        _activateScope(newScope);
      }
    } else {
      _currentScope = null;
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) {
      _routeScopes.remove(oldRoute)?.dispose();
    }

    if (newRoute != null) {
      final newScope = _getOrCreateScope(newRoute);
      _activateScope(newScope);
    }
  }

  FocusScope _getOrCreateScope(Route route) {
    return _routeScopes.putIfAbsent(route, () => FocusScope());
  }

  void _activateScope(FocusScope scope) {
    _currentScope = scope;
    SchedulerBinding.instance.scheduleFrame();
    scope.notifyAllNodes();
  }

  void _ensureNodesRegistered(FocusScope scope) {
    for (final node in List<FocusNode>.from(scope.nodes)) {
      node.ensureRegistered();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    final scope = _currentScope;
    if (scope == null) {
      AppLogger.log('❌ No current scope for key event');
      return;
    }

    if (event.code == KeyCode.tab) {
      if (event.isShiftPressed) {
        AppLogger.log('🔄 Shift+Tab: previousFocus()');
        scope.previousFocus();
      } else {
        scope.nextFocus();
      }
    } else {
      AppLogger.log('🎯 Forwarding key to currentFocus: ${scope.currentFocus?.hashCode}');
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

  FocusNode? get currentFocus => _currentScope?.currentFocus;
}
