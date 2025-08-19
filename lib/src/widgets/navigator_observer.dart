import 'navigation.dart';

abstract class NavigatorObserver {
  void didPush(Route route, Route? previousRoute);
  void didPop(Route route, Route? previousRoute);  
  void didReplace({Route? newRoute, Route? oldRoute});
  void didStartUserGesture(Route route, Route? previousRoute) {}
  void didStopUserGesture() {}
}

class RouteAware {
  void didPush() {}
  void didPushNext() {}
  void didPop() {}
  void didPopNext() {}
}

class RouteObserver<R extends Route> extends NavigatorObserver {
  final Map<RouteAware, R> _listeners = <RouteAware, R>{};

  void subscribe(RouteAware routeAware, R route) {
    _listeners[routeAware] = route;
  }

  void unsubscribe(RouteAware routeAware) {
    _listeners.remove(routeAware);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is R && previousRoute is R) {
      final previousRouteAware = _getRouteAware(previousRoute);
      previousRouteAware?.didPushNext();
      
      final routeAware = _getRouteAware(route);
      routeAware?.didPush();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is R && previousRoute is R) {
      final routeAware = _getRouteAware(route);
      routeAware?.didPop();
      
      final previousRouteAware = _getRouteAware(previousRoute);
      previousRouteAware?.didPopNext();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute is R) {
      final routeAware = _getRouteAware(newRoute);
      routeAware?.didPush();
    }
    if (oldRoute is R) {
      final routeAware = _getRouteAware(oldRoute);
      routeAware?.didPop();
    }
  }

  RouteAware? _getRouteAware(R route) {
    return _listeners.keys.where((k) => _listeners[k] == route).firstOrNull;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}