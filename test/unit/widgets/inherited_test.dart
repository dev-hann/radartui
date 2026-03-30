import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('InheritedWidget', () {
    test('InheritedWidget child is accessible', () {
      const inherited = _TestInheritedWidget(
        value: 42,
        child: Text('test'),
      );
      expect(inherited.child, isA<Text>());
    });

    test('updateShouldNotify returns true when value changes', () {
      const oldWidget = _TestInheritedWidget(value: 1, child: Text('a'));
      const newWidget = _TestInheritedWidget(value: 2, child: Text('a'));
      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    test('updateShouldNotify returns false when value is same', () {
      const oldWidget = _TestInheritedWidget(value: 1, child: Text('a'));
      const newWidget = _TestInheritedWidget(value: 1, child: Text('b'));
      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });

  group('MediaQueryData', () {
    test('MediaQueryData creates with size', () {
      const data = MediaQueryData(size: Size(100, 50));
      expect(data.size.width, equals(100));
      expect(data.size.height, equals(50));
    });

    test('MediaQueryData creates with padding', () {
      const data = MediaQueryData(
        size: Size(100, 50),
        padding: EdgeInsets.all(2),
      );
      expect(data.padding.top, equals(2));
      expect(data.padding.left, equals(2));
    });

    test('MediaQueryData equality', () {
      const data1 = MediaQueryData(size: Size(100, 50));
      const data2 = MediaQueryData(size: Size(100, 50));
      expect(data1, equals(data2));
      expect(data1.hashCode, equals(data2.hashCode));
    });

    test('MediaQueryData copyWith', () {
      const data = MediaQueryData(size: Size(100, 50));
      final copied = data.copyWith(padding: const EdgeInsets.all(5));
      expect(copied.size, equals(const Size(100, 50)));
      expect(copied.padding, equals(const EdgeInsets.all(5)));
    });
  });

  group('MediaQuery', () {
    test('MediaQuery creates widget with data', () {
      const mq = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('test'),
      );
      expect(mq.data.size.width, equals(80));
      expect(mq.data.size.height, equals(24));
    });

    test('MediaQuery updateShouldNotify returns true on data change', () {
      const oldWidget = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('a'),
      );
      const newWidget = MediaQuery(
        data: MediaQueryData(size: Size(100, 50)),
        child: Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    test('MediaQuery updateShouldNotify returns false on same data', () {
      const oldWidget = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('a'),
      );
      const newWidget = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });

  group('ThemeData', () {
    test('ThemeData creates with default colors', () {
      const theme = ThemeData();
      expect(theme.primaryColor, equals(Colors.blue));
      expect(theme.backgroundColor, equals(Colors.black));
      expect(theme.textColor, equals(Colors.white));
    });

    test('ThemeData.dark creates dark theme', () {
      final theme = ThemeData.dark;
      expect(theme.backgroundColor, equals(Colors.black));
      expect(theme.textColor, equals(Colors.white));
    });

    test('ThemeData.light creates light theme', () {
      final theme = ThemeData.light;
      expect(theme.backgroundColor, equals(Colors.white));
      expect(theme.textColor, equals(Colors.black));
    });

    test('ThemeData equality', () {
      final theme1 = ThemeData.dark;
      final theme2 = ThemeData.dark;
      expect(theme1, equals(theme2));
      expect(theme1.hashCode, equals(theme2.hashCode));
    });

    test('ThemeData copyWith', () {
      final theme = ThemeData.dark;
      final copied = theme.copyWith(primaryColor: Colors.red);
      expect(copied.primaryColor, equals(Colors.red));
      expect(copied.backgroundColor, equals(Colors.black));
    });
  });

  group('Theme', () {
    test('Theme creates widget with data', () {
      final theme = Theme(
        data: ThemeData.dark,
        child: const Text('test'),
      );
      expect(theme.data, equals(ThemeData.dark));
    });

    test('Theme updateShouldNotify returns true on data change', () {
      final oldWidget = Theme(
        data: ThemeData.dark,
        child: const Text('a'),
      );
      final newWidget = Theme(
        data: ThemeData.light,
        child: const Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    test('Theme updateShouldNotify returns false on same data', () {
      final oldWidget = Theme(
        data: ThemeData.dark,
        child: const Text('a'),
      );
      final newWidget = Theme(
        data: ThemeData.dark,
        child: const Text('b'),
      );
      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });

  group('EdgeInsets.zero', () {
    test('EdgeInsets.zero has all zeros', () {
      expect(EdgeInsets.zero.top, equals(0));
      expect(EdgeInsets.zero.right, equals(0));
      expect(EdgeInsets.zero.bottom, equals(0));
      expect(EdgeInsets.zero.left, equals(0));
    });
  });
}

class _TestInheritedWidget extends InheritedWidget {
  const _TestInheritedWidget({
    required this.value,
    required super.child,
  });
  final int value;

  @override
  bool updateShouldNotify(_TestInheritedWidget oldWidget) =>
      value != oldWidget.value;
}
