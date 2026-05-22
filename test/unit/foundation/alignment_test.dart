import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Alignment', () {
    group('static constants', () {
      test('topLeft has correct values', () {
        expect(Alignment.topLeft.x, equals(-1.0));
        expect(Alignment.topLeft.y, equals(-1.0));
      });

      test('topCenter has correct values', () {
        expect(Alignment.topCenter.x, equals(0.0));
        expect(Alignment.topCenter.y, equals(-1.0));
      });

      test('topRight has correct values', () {
        expect(Alignment.topRight.x, equals(1.0));
        expect(Alignment.topRight.y, equals(-1.0));
      });

      test('centerLeft has correct values', () {
        expect(Alignment.centerLeft.x, equals(-1.0));
        expect(Alignment.centerLeft.y, equals(0.0));
      });

      test('center has correct values', () {
        expect(Alignment.center.x, equals(0.0));
        expect(Alignment.center.y, equals(0.0));
      });

      test('centerRight has correct values', () {
        expect(Alignment.centerRight.x, equals(1.0));
        expect(Alignment.centerRight.y, equals(0.0));
      });

      test('bottomLeft has correct values', () {
        expect(Alignment.bottomLeft.x, equals(-1.0));
        expect(Alignment.bottomLeft.y, equals(1.0));
      });

      test('bottomCenter has correct values', () {
        expect(Alignment.bottomCenter.x, equals(0.0));
        expect(Alignment.bottomCenter.y, equals(1.0));
      });

      test('bottomRight has correct values', () {
        expect(Alignment.bottomRight.x, equals(1.0));
        expect(Alignment.bottomRight.y, equals(1.0));
      });
    });

    group('equality', () {
      test('equal instances are equal', () {
        const a = Alignment(1.0, -1.0);
        const b = Alignment(1.0, -1.0);
        expect(a, equals(b));
      });

      test('equal instances have same hashCode', () {
        const a = Alignment(-1.0, 0.0);
        const b = Alignment(-1.0, 0.0);
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different x values are not equal', () {
        const a = Alignment(0.0, 0.0);
        const b = Alignment(1.0, 0.0);
        expect(a, isNot(equals(b)));
      });

      test('different y values are not equal', () {
        const a = Alignment(0.0, 0.0);
        const b = Alignment(0.0, 1.0);
        expect(a, isNot(equals(b)));
      });

      test('is not equal to non-Alignment object', () {
        const a = Alignment(0.0, 0.0);
        expect(a, isNot(equals('not an alignment')));
        expect(a, isNot(equals(42)));
      });

      test('identical instance is equal', () {
        const a = Alignment.center;
        expect(a == a, isTrue);
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const a = Alignment(1.0, -1.0);
        expect(a.toString(), equals('Alignment(1.0, -1.0)'));
      });

      test('center toString', () {
        expect(Alignment.center.toString(), equals('Alignment(0.0, 0.0)'));
      });

      test('topLeft toString', () {
        expect(
          Alignment.topLeft.toString(),
          equals('Alignment(-1.0, -1.0)'),
        );
      });
    });
  });
}
