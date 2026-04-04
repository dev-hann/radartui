import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('RouteSettings', () {
    test('creates with name and arguments', () {
      const settings = RouteSettings(
        name: '/test',
        arguments: {'key': 'value'},
      );
      expect(settings.name, equals('/test'));
      expect(settings.arguments, equals({'key': 'value'}));
    });

    test('creates with null values', () {
      const settings = RouteSettings();
      expect(settings.name, isNull);
      expect(settings.arguments, isNull);
    });
  });

  group('PageRoute', () {
    test('creates with builder', () {
      final route = PageRoute(
        builder: (context) => const Text('Test'),
        settings: const RouteSettings(name: '/test'),
      );
      expect(route.settings?.name, equals('/test'));
    });

    test('fullScreenRender defaults to true', () {
      final route = PageRoute(builder: (context) => const Text('Test'));
      expect(route.fullScreenRender, isTrue);
    });

    test('buildPage returns widget from builder', () {
      final route = PageRoute(builder: (context) => const Text('Test'));
      final widget = route.buildPage(_MockBuildContext());
      expect(widget, isA<Text>());
    });
  });

  group('Route', () {
    test('isFirst returns true for root route', () {
      final route = PageRoute(
        builder: (context) => const Text('Test'),
        settings: const RouteSettings(name: '/'),
      );
      expect(route.isFirst, isTrue);
    });

    test('isFirst returns false for non-root route', () {
      final route = PageRoute(
        builder: (context) => const Text('Test'),
        settings: const RouteSettings(name: '/other'),
      );
      expect(route.isFirst, isFalse);
    });

    test('canPop defaults to true', () {
      final route = PageRoute(builder: (context) => const Text('Test'));
      expect(route.canPop, isTrue);
    });

    test('fullScreenRender defaults to true', () {
      final route = PageRoute(builder: (context) => const Text('Test'));
      expect(route.fullScreenRender, isTrue);
    });
  });

  group('Navigator', () {
    test('creates with home', () {
      const navigator = Navigator(home: Text('Home'));
      expect(navigator.home, isA<Text>());
    });

    test('creates with routes', () {
      final navigator = Navigator(
        initialRoute: '/',
        routes: {
          '/': (context) => const Text('Home'),
          '/page1': (context) => const Text('Page1'),
        },
      );
      expect(navigator.routes?.length, equals(2));
    });

    test('creates with observers', () {
      final observer = _TestNavigatorObserver();
      final navigator = Navigator(
        home: const Text('Home'),
        observers: [observer],
      );
      expect(navigator.observers?.length, equals(1));
    });

    test('of throws when Navigator not in context', () {
      final context = _MockBuildContextWithoutNavigator();
      expect(() => Navigator.of(context), throwsA(isA<RadartuiError>()));
    });
  });
}

class _MockBuildContext implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  InheritedElement?
      findAncestorElementOfExactType<T extends InheritedWidget>() => null;
}

class _MockBuildContextWithoutNavigator implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  InheritedElement?
      findAncestorElementOfExactType<T extends InheritedWidget>() => null;
}

class _TestNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {}

  @override
  void didPop(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}
}
