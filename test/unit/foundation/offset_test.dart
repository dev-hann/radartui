import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Offset', () {
    group('constructor', () {
      test('creates offset with x and y', () {
        final offset = Offset(10, 20);
        expect(offset.x, equals(10));
        expect(offset.y, equals(20));
      });

      test('creates offset with zero values', () {
        final offset = Offset(0, 0);
        expect(offset.x, equals(0));
        expect(offset.y, equals(0));
      });

      test('creates offset with negative values', () {
        final offset = Offset(-5, -10);
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
        final a = Offset(10, 20);
        final b = Offset(5, 10);
        final result = a + b;
        expect(result.x, equals(15));
        expect(result.y, equals(30));
      });

      test('adds zero offset', () {
        final offset = Offset(10, 20);
        final result = offset + Offset.zero;
        expect(result, equals(offset));
      });

      test('adds negative offset', () {
        final offset = Offset(10, 20);
        final negative = Offset(-5, -10);
        final result = offset + negative;
        expect(result.x, equals(5));
        expect(result.y, equals(10));
      });
    });

    group('operator -', () {
      test('subtracts two offsets', () {
        final a = Offset(10, 20);
        final b = Offset(5, 10);
        final result = a - b;
        expect(result.x, equals(5));
        expect(result.y, equals(10));
      });

      test('subtracts zero offset', () {
        final offset = Offset(10, 20);
        final result = offset - Offset.zero;
        expect(result, equals(offset));
      });

      test('subtracts to negative', () {
        final a = Offset(5, 10);
        final b = Offset(10, 20);
        final result = a - b;
        expect(result.x, equals(-5));
        expect(result.y, equals(-10));
      });
    });

    group('equality', () {
      test('equal offsets have same hashCode', () {
        final a = Offset(10, 20);
        final b = Offset(10, 20);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different offsets are not equal', () {
        final a = Offset(10, 20);
        final b = Offset(10, 21);
        expect(a, isNot(equals(b)));
      });

      test('zero offsets are equal', () {
        final a = Offset.zero;
        final b = Offset(0, 0);
        expect(a, equals(b));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        final offset = Offset(10, 20);
        expect(offset.toString(), equals('Offset(10, 20)'));
      });
    });
  });
}
