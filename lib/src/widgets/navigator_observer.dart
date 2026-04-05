import 'navigation.dart';

/// An observer that receives notifications about route transitions, analogous
/// to Flutter's [NavigatorObserver].
abstract class NavigatorObserver {
  /// Called when a route has been pushed onto the navigator.
  void didPush(Route route, Route? previousRoute);

  /// Called when a route has been popped off the navigator.
  void didPop(Route route, Route? previousRoute);

  /// Called when a route has been replaced by another route.
  void didReplace({Route? newRoute, Route? oldRoute});

  /// Called when the user starts a gesture to navigate.
  void didStartUserGesture(Route route, Route? previousRoute) {}

  /// Called when the user stops a navigation gesture.
  void didStopUserGesture() {}
}

/// An interface for objects that need to be notified about route changes,
/// analogous to Flutter's [RouteAware].
class RouteAware {
  /// Called when this object's route has been pushed onto the navigator.
  void didPush() {}

  /// Called when a new route has been pushed on top of this object's route.
  void didPushNext() {}

  /// Called when this object's route has been popped off the navigator.
  void didPop() {}

  /// Called when the top route has been popped, exposing this object's route.
  void didPopNext() {}
}

/// A [NavigatorObserver] that notifies [RouteAware] subscribers of route
/// transitions, analogous to Flutter's [RouteObserver].
class RouteObserver<R extends Route> extends NavigatorObserver {
  final Map<RouteAware, R> _listeners = <RouteAware, R>{};

  /// Subscribes [routeAware] to receive notifications about [route].
  void subscribe(RouteAware routeAware, R route) {
    _listeners[routeAware] = route;
  }

  /// Unsubscribes [routeAware] from receiving route notifications.
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
