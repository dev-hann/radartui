import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('MediaQueryData', () {
    test('MediaQueryData creates with required size', () {
      const data = MediaQueryData(size: Size(80, 24));
      expect(data.size.width, equals(80));
      expect(data.size.height, equals(24));
    });

    test('MediaQueryData creates with default padding', () {
      const data = MediaQueryData(size: Size(80, 24));
      expect(data.padding, equals(EdgeInsets.zero));
    });

    test('MediaQueryData creates with custom padding', () {
      const data = MediaQueryData(
        size: Size(100, 50),
        padding: EdgeInsets.all(2),
      );
      expect(data.padding.top, equals(2));
      expect(data.padding.left, equals(2));
      expect(data.padding.right, equals(2));
      expect(data.padding.bottom, equals(2));
    });

    test('MediaQueryData equality', () {
      const data1 = MediaQueryData(size: Size(80, 24));
      const data2 = MediaQueryData(size: Size(80, 24));
      expect(data1, equals(data2));
      expect(data1.hashCode, equals(data2.hashCode));
    });

    test('MediaQueryData inequality', () {
      const data1 = MediaQueryData(size: Size(80, 24));
      const data2 = MediaQueryData(size: Size(100, 50));
      expect(data1 == data2, isFalse);
    });

    test('MediaQueryData copyWith overrides size', () {
      const data = MediaQueryData(size: Size(80, 24));
      final copied = data.copyWith(size: const Size(120, 40));
      expect(copied.size, equals(const Size(120, 40)));
      expect(copied.padding, equals(EdgeInsets.zero));
    });

    test('MediaQueryData copyWith overrides padding', () {
      const data = MediaQueryData(size: Size(80, 24));
      final copied = data.copyWith(padding: const EdgeInsets.all(5));
      expect(copied.size, equals(const Size(80, 24)));
      expect(copied.padding, equals(const EdgeInsets.all(5)));
    });

    test('MediaQueryData copyWith preserves all when no args', () {
      const data = MediaQueryData(size: Size(80, 24));
      final copied = data.copyWith();
      expect(copied, equals(data));
    });

    test('MediaQueryData toString', () {
      const data = MediaQueryData(size: Size(80, 24));
      final str = data.toString();
      expect(str, contains('MediaQueryData'));
      expect(str, contains('size'));
      expect(str, contains('padding'));
    });
  });

  group('MediaQuery', () {
    test('MediaQuery creates with data and child', () {
      const mq = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('test'),
      );
      expect(mq.data.size.width, equals(80));
      expect(mq.data.size.height, equals(24));
      expect(mq.child, isA<Text>());
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

    test('MediaQuery is an InheritedWidget', () {
      const mq = MediaQuery(
        data: MediaQueryData(size: Size(80, 24)),
        child: Text('test'),
      );
      expect(mq, isA<InheritedWidget>());
    });
  });

  group('RadarTUIError', () {
    test('RadarTUIError stores message', () {
      final error = RadarTUIError('test error');
      expect(error.message, equals('test error'));
    });

    test('RadarTUIError toString', () {
      final error = RadarTUIError('test error');
      expect(error.toString(), equals('RadarTUIError: test error'));
    });

    test('RadarTUIError implements Exception', () {
      final error = RadarTUIError('test');
      expect(error, isA<Exception>());
    });
  });
}
