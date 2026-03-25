import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Offset', () {
    group('constructor', () {
      test('creates offset with x and y', () {
        const offset = Offset(10, 20);
        expect(offset.x, equals(10));
        expect(offset.y, equals(20));
      });

      test('creates offset with zero values', () {
        const offset = Offset(0, 0);
        expect(offset.x, equals(0));
        expect(offset.y, equals(0));
      });

      test('creates offset with negative values', () {
        const offset = Offset(-5, -10);
        expect(offset.x, equals(-5));
        expect(offset.y, equals(-10));
      });
    });

    group('zero constant', () {
      test('has zero x and y', () {
        expect(Offset.zero.x, equals(0));
        expect(Offset.zero.y, equals(0));
      });
    });

    group('operator +', () {
      test('adds two offsets', () {
        const a = Offset(10, 20);
        const b = Offset(5, 10);
        final result = a + b;
        expect(result.x, equals(15));
        expect(result.y, equals(30));
      });

      test('adds zero offset', () {
        const offset = Offset(10, 20);
        final result = offset + Offset.zero;
        expect(result, equals(offset));
      });

      test('adds negative offset', () {
        const offset = Offset(10, 20);
        const negative = Offset(-5, -10);
        final result = offset + negative;
        expect(result.x, equals(5));
        expect(result.y, equals(10));
      });
    });

    group('operator -', () {
      test('subtracts two offsets', () {
        const a = Offset(10, 20);
        const b = Offset(5, 10);
        final result = a - b;
        expect(result.x, equals(5));
        expect(result.y, equals(10));
      });

      test('subtracts zero offset', () {
        const offset = Offset(10, 20);
        final result = offset - Offset.zero;
        expect(result, equals(offset));
      });

      test('subtracts to negative', () {
        const a = Offset(5, 10);
        const b = Offset(10, 20);
        final result = a - b;
        expect(result.x, equals(-5));
        expect(result.y, equals(-10));
      });
    });

    group('equality', () {
      test('equal offsets have same hashCode', () {
        const a = Offset(10, 20);
        const b = Offset(10, 20);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different offsets are not equal', () {
        const a = Offset(10, 20);
        const b = Offset(10, 21);
        expect(a, isNot(equals(b)));
      });

      test('zero offsets are equal', () {
        const a = Offset.zero;
        const b = Offset(0, 0);
        expect(a, equals(b));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const offset = Offset(10, 20);
        expect(offset.toString(), equals('Offset(10, 20)'));
      });
    });
  });
}
