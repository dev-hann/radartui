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
      // 🔧 FIX: 기존 스코프를 복원 (새로 생성하지 않음)
      final previousScope = _routeScopes[previousRoute];
      if (previousScope != null) {
        // 다음 프레임에서 포커스 복원
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _activateScope(previousScope);
          
          // 위젯들이 rebuild되기를 기다린 후 한번 더 시도
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // 모든 노드들이 올바른 스코프에 재등록되었는지 확인
            _ensureNodesRegistered(previousScope);
            previousScope.notifyAllNodes();
          });
        });
      } else {
        // 기존 스코프가 없다면 새로 생성 (fallback)
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
    // 스코프 재활성화 시 즉시 UI 업데이트를 위해 프레임 스케줄링
    SchedulerBinding.instance.scheduleFrame();
    // 모든 노드에 포커스 상태 변경을 알림 (동기적으로)
    scope.notifyAllNodes();
  }

  void _ensureNodesRegistered(FocusScope scope) {
    // 모든 FocusNode가 현재 활성화된 스코프에 등록되도록 보장
    // 이는 Navigator.pop() 후 노드들이 올바른 스코프에 연결되도록 함
    for (final node in List<FocusNode>.from(scope.nodes)) {
      node.ensureRegistered();
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    final scope = _currentScope;
    AppLogger.log('🔑 FocusManager._handleKeyEvent() - key: "${event.toString()}", scope: ${scope?.hashCode}, currentFocus: ${scope?.currentFocus?.hashCode}');
    if (scope == null) {
      AppLogger.log('❌ No current scope for key event');
      return;
    }

    if (event.code == KeyCode.tab) {
      if (event.isShiftPressed) {
        AppLogger.log('🔄 Shift+Tab: previousFocus()');
        scope.previousFocus();
      } else {
        AppLogger.log('🔄 Tab: nextFocus()');
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
