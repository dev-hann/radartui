import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Key', () {
    test('Key.value creates ValueKey<String>', () {
      const key = Key.value('test');
      expect(key, isA<ValueKey<String>>());
      expect((key as ValueKey<String>).value, equals('test'));
    });
  });

  group('ValueKey', () {
    test('ValueKey stores value', () {
      const key = ValueKey<int>(42);
      expect(key.value, equals(42));
    });

    test('ValueKey equality same values are equal', () {
      const key1 = ValueKey<String>('test');
      const key2 = ValueKey<String>('test');
      expect(key1, equals(key2));
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('ValueKey equality different values are not equal', () {
      const key1 = ValueKey<String>('test1');
      const key2 = ValueKey<String>('test2');
      expect(key1, isNot(equals(key2)));
    });

    test('ValueKey equality different types are not equal', () {
      const key1 = ValueKey<String>('42');
      const key2 = ValueKey<int>(42);
      expect(key1, isNot(equals(key2)));
    });

    test('ValueKey toString returns readable format', () {
      const key = ValueKey<String>('test');
      expect(key.toString(), contains('ValueKey'));
      expect(key.toString(), contains('test'));
    });
  });

  group('GlobalKey', () {
    test('GlobalKey currentWidget returns null initially', () {
      final key = GlobalKey();
      expect(key.currentWidget, isNull);
      expect(key.currentElement, isNull);
    });

    test('GlobalKey toString contains hash', () {
      final key = GlobalKey();
      expect(key.toString(), contains('GlobalKey'));
    });
  });

  group('Widget.canUpdate', () {
    test('canUpdate returns true for same type and null keys', () {
      const oldWidget = _TestWidget();
      const newWidget = _TestWidget();
      expect(Widget.canUpdate(oldWidget, newWidget), isTrue);
    });

    test('canUpdate returns true for same type and same key', () {
      const key = ValueKey<String>('test');
      const oldWidget = _TestWidget(key: key);
      const newWidget = _TestWidget(key: key);
      expect(Widget.canUpdate(oldWidget, newWidget), isTrue);
    });

    test('canUpdate returns false for same type but different keys', () {
      const key1 = ValueKey<String>('test1');
      const key2 = ValueKey<String>('test2');
      const oldWidget = _TestWidget(key: key1);
      const newWidget = _TestWidget(key: key2);
      expect(Widget.canUpdate(oldWidget, newWidget), isFalse);
    });

    test('canUpdate returns false for different types', () {
      const oldWidget = _TestWidget();
      const newWidget = _TestWidget2();
      expect(Widget.canUpdate(oldWidget, newWidget), isFalse);
    });
  });
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({super.key});

  @override
  Widget build(BuildContext context) => const Text('test');
}

class _TestWidget2 extends StatelessWidget {
  const _TestWidget2();

  @override
  Widget build(BuildContext context) => const Text('test2');
}
