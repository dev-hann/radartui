import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('EdgeInsets', () {
    group('EdgeInsets.fromLTRB', () {
      test('creates with individual values', () {
        const insets = EdgeInsets.fromLTRB(5, 10, 15, 20);
        expect(insets.left, equals(5));
        expect(insets.top, equals(10));
        expect(insets.right, equals(15));
        expect(insets.bottom, equals(20));
      });

      test('creates with zero values', () {
        const insets = EdgeInsets.fromLTRB(0, 0, 0, 0);
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.all', () {
      test('creates symmetric insets', () {
        const insets = EdgeInsets.all(10);
        expect(insets.left, equals(10));
        expect(insets.top, equals(10));
        expect(insets.right, equals(10));
        expect(insets.bottom, equals(10));
      });

      test('creates zero insets', () {
        const insets = EdgeInsets.all(0);
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.symmetric', () {
      test('creates with vertical and horizontal', () {
        const insets = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
        expect(insets.left, equals(20));
        expect(insets.top, equals(10));
        expect(insets.right, equals(20));
        expect(insets.bottom, equals(10));
      });

      test('creates with only vertical', () {
        const insets = EdgeInsets.symmetric(vertical: 10);
        expect(insets.left, equals(0));
        expect(insets.top, equals(10));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(10));
      });

      test('creates with only horizontal', () {
        const insets = EdgeInsets.symmetric(horizontal: 20);
        expect(insets.left, equals(20));
        expect(insets.top, equals(0));
        expect(insets.right, equals(20));
        expect(insets.bottom, equals(0));
      });

      test('creates with default values', () {
        const insets = EdgeInsets.symmetric();
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.only', () {
      test('creates with only top', () {
        const insets = EdgeInsets.only(top: 10);
        expect(insets.top, equals(10));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(0));
      });

      test('creates with only right', () {
        const insets = EdgeInsets.only(right: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(10));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(0));
      });

      test('creates with only bottom', () {
        const insets = EdgeInsets.only(bottom: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(10));
        expect(insets.left, equals(0));
      });

      test('creates with only left', () {
        const insets = EdgeInsets.only(left: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(10));
      });

      test('creates with mixed values', () {
        const insets = EdgeInsets.only(top: 5, left: 10);
        expect(insets.top, equals(5));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(10));
      });
    });

    group('horizontal getter', () {
      test('returns left + right', () {
        const insets = EdgeInsets.fromLTRB(5, 0, 10, 0);
        expect(insets.horizontal, equals(15));
      });

      test('returns 0 for zero insets', () {
        const insets = EdgeInsets.all(0);
        expect(insets.horizontal, equals(0));
      });
    });

    group('vertical getter', () {
      test('returns top + bottom', () {
        const insets = EdgeInsets.fromLTRB(0, 5, 0, 10);
        expect(insets.vertical, equals(15));
      });

      test('returns 0 for zero insets', () {
        const insets = EdgeInsets.all(0);
        expect(insets.vertical, equals(0));
      });
    });

    group('operator +', () {
      test('adds two edge insets', () {
        const a = EdgeInsets.fromLTRB(5, 10, 15, 20);
        const b = EdgeInsets.fromLTRB(1, 2, 3, 4);
        final result = a + b;
        expect(result.left, equals(6));
        expect(result.top, equals(12));
        expect(result.right, equals(18));
        expect(result.bottom, equals(24));
      });

      test('adds zero insets', () {
        const insets = EdgeInsets.all(10);
        const zero = EdgeInsets.all(0);
        final result = insets + zero;
        expect(result, equals(insets));
      });
    });

    group('equality', () {
      test('equal insets have same hashCode', () {
        const a = EdgeInsets.all(10);
        const b = EdgeInsets.all(10);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different insets are not equal', () {
        const a = EdgeInsets.all(10);
        const b = EdgeInsets.all(11);
        expect(a, isNot(equals(b)));
      });

      test('fromLTRB and all with same values are equal', () {
        const a = EdgeInsets.fromLTRB(10, 10, 10, 10);
        const b = EdgeInsets.all(10);
        expect(a, equals(b));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const insets = EdgeInsets.fromLTRB(5, 10, 15, 20);
        expect(insets.toString(), equals('EdgeInsets(5, 10, 15, 20)'));
      });
    });
  });
}
