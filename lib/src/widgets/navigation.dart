import 'dart:async';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/widgets/basic/empty_widget.dart';
import 'package:radartui/src/widgets/focus_manager.dart';
import 'package:radartui/src/widgets/navigator_observer.dart';

typedef RouteBuilder = Widget Function(BuildContext context);
typedef RoutePredicate = bool Function(Route route);

abstract class Route {
  const Route({this.settings});

  final RouteSettings? settings;

  Widget buildPage(BuildContext context);

  bool get isFirst => settings?.name == '/';
}

class RouteSettings {
  const RouteSettings({this.name, this.arguments});

  final String? name;
  final Object? arguments;
}

class PageRoute extends Route {
  const PageRoute({required this.builder, super.settings});

  final RouteBuilder builder;

  @override
  Widget buildPage(BuildContext context) => builder(context);
}

class NavigatorState extends State<Navigator> {
  final List<Route> _history = [];
  final List<Completer<Object?>> _completers = [];
  final List<NavigatorObserver> _observers = [];

  List<Route> get history => List.unmodifiable(_history);

  Route? get currentRoute => _history.isNotEmpty ? _history.last : null;

  @override
  void initState() {
    super.initState();

    // Initialize FocusManager and add it as observer
    FocusManager.instance.initialize();
    _observers.add(FocusManager.instance);

    // Add observers from widget
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
    for (final completer in _completers) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _completers.clear();
    FocusManager.instance.dispose();
    super.dispose();
  }

  void _addRoute(Route route, Completer<Object?>? completer) {
    _history.add(route);
    _completers.add(completer ?? Completer<Object?>());
  }

  void _removeLast([Object? result]) {
    final removedRoute = _history.removeLast();
    final completer = _completers.removeLast();
    if (!completer.isCompleted) {
      completer.complete(result);
    }

    final previousRoute = _history.isNotEmpty ? _history.last : null;
    _notifyObservers(
      (observer) => observer.didPop(removedRoute, previousRoute),
    );
  }

  void _notifyObservers(void Function(NavigatorObserver observer) callback) {
    for (final observer in _observers) {
      callback(observer);
    }
  }

  Future<Object?> push(Route route) {
    final completer = Completer<Object?>();
    final previousRoute = currentRoute;
    setState(() {
      _addRoute(route, completer);
    });
    _notifyObservers((observer) => observer.didPush(route, previousRoute));
    return completer.future;
  }

  void pop([Object? result]) {
    if (_history.length > 1) {
      setState(() {
        _removeLast(result);
      });
    }
  }

  void popUntil(RoutePredicate predicate, [Object? result]) {
    setState(() {
      while (_history.length > 1 && !predicate(_history.last)) {
        _removeLast(result);
      }
    });
  }

  Future<Object?> pushReplacement(Route route, [Object? result]) {
    final completer = Completer<Object?>();
    final oldRoute = currentRoute;
    setState(() {
      if (_history.isNotEmpty) {
        _removeLast(result);
      }
      _addRoute(route, completer);
    });
    _notifyObservers(
      (observer) => observer.didReplace(newRoute: route, oldRoute: oldRoute),
    );
    return completer.future;
  }

  Future<Object?> pushNamed(String routeName, {Object? arguments}) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      return push(
        PageRoute(
          builder: routeBuilder,
          settings: RouteSettings(name: routeName, arguments: arguments),
        ),
      );
    }
    return Future.value();
  }

  Future<Object?> pushReplacementNamed(
    String routeName, {
    Object? arguments,
    Object? result,
  }) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      return pushReplacement(
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
      return widget.home ?? const EmptyWidget();
    }

    return _NavigatorScope(
      navigator: this,
      child: currentRoute!.buildPage(context),
    );
  }
}

class Navigator extends StatefulWidget {
  const Navigator({this.home, this.routes, this.initialRoute, this.observers});

  final Widget? home;
  final Map<String, RouteBuilder>? routes;
  final String? initialRoute;
  final List<NavigatorObserver>? observers;

  @override
  NavigatorState createState() => NavigatorState();

  static NavigatorState of(BuildContext context) {
    final scope = context.findAncestorWidgetOfExactType<_NavigatorScope>();
    if (scope == null) {
      throw FlutterError(
        'Navigator operation requested with a context that does not include a Navigator.\n'
        'The context used to push or pop routes from the Navigator must be that of a '
        'widget that is a descendant of a Navigator widget.',
      );
    }
    return scope.navigator;
  }

  static FocusManager get focusManager => FocusManager.instance;

  static Future<Object?> push(BuildContext context, Route route) {
    return of(context).push(route);
  }

  static void pop(BuildContext context, [Object? result]) {
    of(context).pop(result);
  }

  static void popUntil(
    BuildContext context,
    RoutePredicate predicate, [
    Object? result,
  ]) {
    of(context).popUntil(predicate, result);
  }

  static Future<Object?> pushReplacement(
    BuildContext context,
    Route route, [
    Object? result,
  ]) {
    return of(context).pushReplacement(route, result);
  }

  static Future<Object?> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return of(context).pushNamed(routeName, arguments: arguments);
  }

  static Future<Object?> pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
    Object? result,
  }) {
    return of(
      context,
    ).pushReplacementNamed(routeName, arguments: arguments, result: result);
  }
}

class _NavigatorScope extends StatelessWidget {
  const _NavigatorScope({required this.navigator, required this.child});

  final NavigatorState navigator;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class FlutterError extends Error {
  FlutterError(this.message);
  final String message;

  @override
  String toString() => 'FlutterError: $message';
}

extension BuildContextNavigation on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
  FocusManager get focusManager => Navigator.focusManager;
}
