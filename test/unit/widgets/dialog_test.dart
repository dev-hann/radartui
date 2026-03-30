import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Dialog', () {
    group('constructor', () {
      test('creates with required child', () {
        const dialog = Dialog(child: Text('Content'));
        expect(dialog.child, isA<Text>());
      });

      test('creates with title', () {
        const dialog = Dialog(
          child: Text('Content'),
          title: 'Dialog Title',
        );
        expect(dialog.title, equals('Dialog Title'));
      });

      test('creates with actions', () {
        final dialog = Dialog(
          child: const Text('Content'),
          actions: [
            Button(text: 'OK', onPressed: () {}),
            Button(text: 'Cancel', onPressed: () {}),
          ],
        );
        expect(dialog.actions, isNotNull);
        expect(dialog.actions!.length, equals(2));
      });

      test('creates with custom padding', () {
        const dialog = Dialog(
          child: Text('Content'),
          padding: EdgeInsets.all(4),
        );
        expect(dialog.padding, equals(const EdgeInsets.all(4)));
      });

      test('creates with custom title style', () {
        const titleStyle = TextStyle(color: Color.cyan, bold: true);
        const dialog = Dialog(
          child: Text('Content'),
          title: 'Title',
          titleStyle: titleStyle,
        );
        expect(dialog.titleStyle, equals(titleStyle));
      });

      test('creates with custom background color', () {
        const dialog = Dialog(
          child: Text('Content'),
          backgroundColor: Color.blue,
        );
        expect(dialog.backgroundColor, equals(Color.blue));
      });

      test('default background color is white', () {
        const dialog = Dialog(child: Text('Content'));
        expect(dialog.backgroundColor, equals(Color.white));
      });
    });

    group('build', () {
      test('builds dialog with title and content', () {
        const dialog = Dialog(
          child: Text('Content'),
          title: 'Title',
        );
        final widget = dialog.build(_MockBuildContext());
        expect(widget, isA<Widget>());
      });

      test('builds dialog with actions', () {
        final dialog = Dialog(
          child: const Text('Content'),
          actions: [
            Button(text: 'OK', onPressed: () {}),
          ],
        );
        final widget = dialog.build(_MockBuildContext());
        expect(widget, isA<Widget>());
      });

      test('builds dialog without title', () {
        const dialog = Dialog(child: Text('Content'));
        final widget = dialog.build(_MockBuildContext());
        expect(widget, isA<Widget>());
      });
    });
  });

  group('ModalRoute', () {
    group('constructor', () {
      test('creates with required builder', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
        );
        expect(route.builder, isNotNull);
      });

      test('creates with barrierDismissible', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
          barrierDismissible: false,
        );
        expect(route.barrierDismissible, isFalse);
      });

      test('creates with barrierColor', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
          barrierColor: Color.brightBlack,
        );
        expect(route.barrierColor, equals(Color.brightBlack));
      });

      test('creates with alignment', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
          alignment: Alignment.topCenter,
        );
        expect(route.alignment, equals(Alignment.topCenter));
      });

      test('creates with settings', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
          settings: const RouteSettings(name: '/dialog'),
        );
        expect(route.settings?.name, equals('/dialog'));
      });
    });

    group('fullScreenRender', () {
      test('returns false', () {
        final route = ModalRoute(
          builder: (context) => const Dialog(child: Text('Test')),
        );
        expect(route.fullScreenRender, isFalse);
      });
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
      final route = PageRoute(
        builder: (context) => const Text('Test'),
      );
      expect(route.fullScreenRender, isTrue);
    });
  });

  group('showDialog', () {
    test('is a function', () {
      expect(showDialog, isA<Function>());
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
