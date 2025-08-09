import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/widgets/basic/empty_widget.dart';

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
  const PageRoute({
    required this.builder,
    super.settings,
  });
  
  final RouteBuilder builder;
  
  @override
  Widget buildPage(BuildContext context) => builder(context);
}

class NavigatorState extends State<Navigator> {
  final List<Route> _history = [];
  
  List<Route> get history => List.unmodifiable(_history);
  
  Route? get currentRoute => _history.isNotEmpty ? _history.last : null;
  
  void push(Route route) {
    setState(() {
      _history.add(route);
    });
  }
  
  void pop() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
      });
    }
  }
  
  void popUntil(RoutePredicate predicate) {
    setState(() {
      while (_history.length > 1 && !predicate(_history.last)) {
        _history.removeLast();
      }
    });
  }
  
  void pushReplacement(Route route) {
    setState(() {
      if (_history.isNotEmpty) {
        _history.removeLast();
      }
      _history.add(route);
    });
  }
  
  void pushNamedAndClearStack(String routeName) {
    final route = widget.routes?[routeName];
    if (route != null) {
      setState(() {
        _history.clear();
        _history.add(PageRoute(
          builder: route,
          settings: RouteSettings(name: routeName),
        ));
      });
    }
  }
  
  void pushNamed(String routeName, {Object? arguments}) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      push(PageRoute(
        builder: routeBuilder,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ));
    }
  }
  
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    final routeBuilder = widget.routes?[routeName];
    if (routeBuilder != null) {
      pushReplacement(PageRoute(
        builder: routeBuilder,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      if (widget.initialRoute != null && widget.routes != null) {
        final initialBuilder = widget.routes![widget.initialRoute!];
        if (initialBuilder != null) {
          _history.add(PageRoute(
            builder: initialBuilder,
            settings: RouteSettings(name: widget.initialRoute!),
          ));
        }
      }
    }
    
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
  const Navigator({
    this.home,
    this.routes,
    this.initialRoute,
  });
  
  final Widget? home;
  final Map<String, RouteBuilder>? routes;
  final String? initialRoute;
  
  @override
  NavigatorState createState() => NavigatorState();
  
  static NavigatorState of(BuildContext context) {
    final scope = context.findAncestorWidgetOfExactType<_NavigatorScope>();
    if (scope == null) {
      throw FlutterError(
        'Navigator operation requested with a context that does not include a Navigator.\n'
        'The context used to push or pop routes from the Navigator must be that of a '
        'widget that is a descendant of a Navigator widget.'
      );
    }
    return scope.navigator;
  }
  
  static void push(BuildContext context, Route route) {
    of(context).push(route);
  }
  
  static void pop(BuildContext context) {
    of(context).pop();
  }
  
  static void popUntil(BuildContext context, RoutePredicate predicate) {
    of(context).popUntil(predicate);
  }
  
  static void pushReplacement(BuildContext context, Route route) {
    of(context).pushReplacement(route);
  }
  
  static void pushNamed(BuildContext context, String routeName, {Object? arguments}) {
    of(context).pushNamed(routeName, arguments: arguments);
  }
  
  static void pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}) {
    of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
  
  static void pushNamedAndClearStack(BuildContext context, String routeName) {
    of(context).pushNamedAndClearStack(routeName);
  }
}

class _NavigatorScope extends StatelessWidget {
  const _NavigatorScope({
    required this.navigator,
    required this.child,
  });
  
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
}