import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Size', () {
    group('constructor', () {
      test('creates size with width and height', () {
        final size = Size(80, 24);
        expect(size.width, equals(80));
        expect(size.height, equals(24));
      });

      test('creates size with zero values', () {
        final size = Size(0, 0);
        expect(size.width, equals(0));
        expect(size.height, equals(0));
      });

      test('creates large size', () {
        final size = Size(1000, 500);
        expect(size.width, equals(1000));
        expect(size.height, equals(500));
      });
    });

    group('zero constant', () {
      test('has zero width and height', () {
        expect(Size.zero.width, equals(0));
        expect(Size.zero.height, equals(0));
      });
    });

    group('equality', () {
      test('equal sizes have same hashCode', () {
        final a = Size(80, 24);
        final b = Size(80, 24);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different sizes are not equal', () {
        final a = Size(80, 24);
        final b = Size(80, 25);
        expect(a, isNot(equals(b)));
      });

      test('zero sizes are equal', () {
        final a = Size.zero;
        final b = Size(0, 0);
        expect(a, equals(b));
      });

      test('sizes with different widths are not equal', () {
        final a = Size(80, 24);
        final b = Size(81, 24);
        expect(a, isNot(equals(b)));
      });

      test('sizes with different heights are not equal', () {
        final a = Size(80, 24);
        final b = Size(80, 25);
        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        final size = Size(80, 24);
        expect(size.toString(), equals('Size(80, 24)'));
      });

      test('returns readable representation for zero', () {
        final size = Size.zero;
        expect(size.toString(), equals('Size(0, 0)'));
      });
    });
  });
}
