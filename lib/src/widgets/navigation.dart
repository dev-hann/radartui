import 'dart:async';

import '../binding.dart';
import '../foundation.dart';
import 'basic/sized_box.dart';
import 'focus_manager.dart';
import 'framework.dart';
import 'navigator_observer.dart';

/// Signature for a function that builds a route's widget.
typedef RouteBuilder = Widget Function(BuildContext context);

/// Signature for a predicate that determines whether a route meets criteria.
typedef RoutePredicate = bool Function(Route route);

/// Exception thrown when a [Navigator] method is called after disposal.
class NavigatorDisposedException implements Exception {
  /// Creates a [NavigatorDisposedException].
  NavigatorDisposedException([this.message = 'Navigator has been disposed']);

  /// The error message.
  final String message;

  @override
  String toString() => 'NavigatorDisposedException: $message';
}

/// An abstract route in the navigation stack, analogous to Flutter's [Route].
abstract class Route<T> {
  /// Creates a [Route].
  Route({this.settings});

  /// Optional configuration for this route.
  final RouteSettings? settings;

  /// Builds the widget for this route's page.
  Widget buildPage(BuildContext context);

  /// Whether this route is the first (root) route.
  bool get isFirst => settings?.name == '/';

  /// Whether this route renders as a full screen overlay.
  bool get fullScreenRender => true;

  /// Whether this route can be popped.
  bool get canPop => true;

  bool _isCurrent = false;

  /// Whether this route is the top-most route in the navigator.
  bool get isCurrent => _isCurrent;

  /// Called when the route is first added to the navigator.
  void install() {}

  /// Called when this route has been pushed onto the navigator.
  void didPush() {}

  /// Called when this route has been popped off the navigator.
  void didPop(T? result) {}

  /// Called when this route has been replaced by another route.
  void didReplace(Route? oldRoute) {}

  /// Called when this route has been removed from the navigator.
  void dispose() {}
}

/// Configuration data for a [Route], analogous to Flutter's [RouteSettings].
class RouteSettings {
  /// Creates a [RouteSettings].
  const RouteSettings({this.name, this.arguments});

  /// The name of the route (e.g., '/home').
  final String? name;

  /// Optional arguments passed to the route.
  final Object? arguments;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteSettings &&
        name == other.name &&
        arguments == other.arguments;
  }

  @override
  int get hashCode => Object.hash(name, arguments);
}

/// A route backed by a builder function, analogous to Flutter's [PageRoute].
class PageRoute<T> extends Route<T> {
  /// Creates a [PageRoute].
  PageRoute({required this.builder, super.settings});

  /// The builder that creates this route's widget.
  final RouteBuilder builder;

  @override
  Widget buildPage(BuildContext context) => builder(context);
}

/// The mutable state for a [Navigator] widget.
class NavigatorState extends State<Navigator> {
  final List<Route> _history = [];
  final List<Completer<Object?>> _completers = [];
  final List<NavigatorObserver> _observers = [];

  /// An unmodifiable view of the route history.
  List<Route> get history => List.unmodifiable(_history);

  /// The current (top-most) route, or null if the history is empty.
  Route? get currentRoute => _history.isNotEmpty ? _history.last : null;

  @override
  void initState() {
    super.initState();

    FocusManager.instance.initialize();
    _observers.add(FocusManager.instance);

    if (widget.observers != null) {
      _observers.addAll(widget.observers!);
    }

    if (widget.initialRoute != null && widget.routes != null) {
      final initialBuilder = widget.routes![widget.initialRoute!];
      if (initialBuilder != null) {
        final route = PageRoute(
          builder: initialBuilder,
          settings: RouteSettings(name: widget.initialRoute!),
        );
        _addRoute(route, null);
        _notifyObservers((observer) => observer.didPush(route, null));
      }
    }
  }

  @override
  void dispose() {
    for (final route in _history.reversed) {
      route._isCurrent = false;
      route.dispose();
    }
    _history.clear();

    final disposeError = NavigatorDisposedException();
    for (final completer in _completers) {
      if (!completer.isCompleted) {
        completer.completeError(disposeError);
      }
    }
    _completers.clear();
    FocusManager.instance.dispose();
    super.dispose();
  }

  void _addRoute(Route route, Completer<Object?>? completer) {
    if (_history.isNotEmpty) {
      _history.last._isCurrent = false;
    }
    _history.add(route);
    _completers.add(completer ?? Completer<Object?>());
    route._isCurrent = true;
    route.install();
    route.didPush();
  }

  void _removeLast([Object? result]) {
    final removedRoute = _history.removeLast();
    removedRoute._isCurrent = false;
    removedRoute.didPop(result);

    final completer = _completers.removeLast();
    if (!completer.isCompleted) {
      completer.complete(result);
    }

    final previousRoute = _history.isNotEmpty ? _history.last : null;
    if (previousRoute != null) {
      previousRoute._isCurrent = true;
    }

    _notifyObservers(
      (observer) => observer.didPop(removedRoute, previousRoute),
    );
    removedRoute.dispose();
  }

  void _notifyObservers(void Function(NavigatorObserver observer) callback) {
    for (final observer in _observers) {
      callback(observer);
    }
  }

  void _scheduleFrameForRoute(Route route) {
    if (route.fullScreenRender) {
      WidgetsBinding.instance.scheduleFrameWithClear();
    } else {
      WidgetsBinding.instance.scheduleFrame();
    }
  }

  /// Pushes the given [route] onto the navigator stack.
  ///
  /// Returns a future that completes with the pop result when the route is popped.
  Future<T?> push<T>(Route route) {
    final completer = Completer<T?>();
    final previousRoute = currentRoute;
    setState(() {
      _addRoute(route, completer);
    });
    _scheduleFrameForRoute(route);
    _notifyObservers((observer) => observer.didPush(route, previousRoute));
    return completer.future;
  }

  /// Pops the top route off the navigator stack.
  ///
  /// Returns true if the route was successfully popped.
  bool pop([Object? result]) {
    if (_history.length > 1) {
      if (!_history.last.canPop) {
        return false;
      }
      final currentRoute = _history.last;
      setState(() {
        _removeLast(result);
      });
      _scheduleFrameForRoute(currentRoute);
      return true;
    }
    return false;
  }

  /// Calls [pop] repeatedly until [predicate] returns true for the current route.
  void popUntil(RoutePredicate predicate, [Object? result]) {
    setState(() {
      while (_history.length > 1 && !predicate(_history.last)) {
        _removeLast(result);
      }
    });
  }

  /// Replaces the top route with the given [route], then pushes it.
  ///
  /// Returns a future that completes with the pop result.
  Future<T?> pushReplacement<T>(Route route, [Object? result]) {
    final completer = Completer<T?>();
    final oldRoute = currentRoute;
    setState(() {
      if (_history.isNotEmpty) {
        _removeLast(result);
      }
      _addRoute(route, completer);
    });
    _scheduleFrameForRoute(route);
    _notifyObservers(
      (observer) => observer.didReplace(newRoute: route, oldRoute: oldRoute),
    );
    return completer.future;
  }

  /// Pushes a named route onto the navigator stack using the configured [routes] map.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      return push<T>(
        PageRoute(
          builder: routeBuilder,
          settings: RouteSettings(name: routeName, arguments: arguments),
        ),
      );
    }
    return Future.value();
  }

  /// Replaces the current route with a named route.
  Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
    Object? result,
  }) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      return pushReplacement<T>(
        PageRoute(
          builder: routeBuilder,
          settings: RouteSettings(name: routeName, arguments: arguments),
        ),
        result,
      );
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      return widget.home ?? const SizedBox.shrink();
    }

    return _NavigatorScope(
      navigator: this,
      child: currentRoute!.buildPage(context),
    );
  }
}

/// A widget that manages a stack of routes, analogous to Flutter's [Navigator].
class Navigator extends StatefulWidget {
  /// Creates a [Navigator].
  const Navigator({
    super.key,
    this.home,
    this.routes,
    this.initialRoute,
    this.observers,
  });

  /// The widget displayed when the route history is empty.
  final Widget? home;

  /// A map of route names to builder functions.
  final Map<String, RouteBuilder>? routes;

  /// The name of the initial route to display.
  final String? initialRoute;

  /// Observers notified of route transitions.
  final List<NavigatorObserver>? observers;

  @override
  NavigatorState createState() => NavigatorState();

  /// Returns the [NavigatorState] of the nearest [Navigator] ancestor.
  static NavigatorState of(BuildContext context) {
    final scope = context.findAncestorWidgetOfExactType<_NavigatorScope>();
    if (scope == null) {
      throw RadartuiError(
        'Navigator operation requested with a context that does not include a Navigator.\n'
        'The context used to push or pop routes from the Navigator must be that of a '
        'widget that is a descendant of a Navigator widget.',
      );
    }
    return scope.navigator;
  }

  /// Returns the singleton [FocusManager] instance.
  static FocusManager get focusManager => FocusManager.instance;

  /// Pushes the given [route] onto the navigator nearest to [context].
  static Future<T?> push<T>(BuildContext context, Route route) {
    return of(context).push(route);
  }

  /// Pops the top route off the navigator nearest to [context].
  static bool pop(BuildContext context, [Object? result]) {
    return of(context).pop(result);
  }

  /// Calls [pop] repeatedly on the navigator nearest to [context] until [predicate] returns true.
  static void popUntil(
    BuildContext context,
    RoutePredicate predicate, [
    Object? result,
  ]) {
    of(context).popUntil(predicate, result);
  }

  /// Replaces the current route on the navigator nearest to [context].
  static Future<T?> pushReplacement<T>(
    BuildContext context,
    Route route, [
    Object? result,
  ]) {
    return of(context).pushReplacement<T>(route, result);
  }

  /// Pushes a named route onto the navigator nearest to [context].
  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replaces the current route with a named route on the navigator nearest to [context].
  static Future<T?> pushReplacementNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    Object? result,
  }) {
    return of(
      context,
    ).pushReplacementNamed<T>(routeName, arguments: arguments, result: result);
  }
}

class _NavigatorScope extends StatelessWidget {
  const _NavigatorScope({required this.navigator, required this.child});

  final NavigatorState navigator;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Extension on [BuildContext] providing convenient access to navigation.
extension BuildContextNavigation on BuildContext {
  /// Returns the [NavigatorState] of the nearest [Navigator] ancestor.
  NavigatorState get navigator => Navigator.of(this);

  /// Returns the singleton [FocusManager] instance.
  FocusManager get focusManager => Navigator.focusManager;
}
