import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('EdgeInsets', () {
    group('EdgeInsets.fromLTRB', () {
      test('creates with individual values', () {
        final insets = EdgeInsets.fromLTRB(5, 10, 15, 20);
        expect(insets.left, equals(5));
        expect(insets.top, equals(10));
        expect(insets.right, equals(15));
        expect(insets.bottom, equals(20));
      });

      test('creates with zero values', () {
        final insets = EdgeInsets.fromLTRB(0, 0, 0, 0);
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.all', () {
      test('creates symmetric insets', () {
        final insets = EdgeInsets.all(10);
        expect(insets.left, equals(10));
        expect(insets.top, equals(10));
        expect(insets.right, equals(10));
        expect(insets.bottom, equals(10));
      });

      test('creates zero insets', () {
        final insets = EdgeInsets.all(0);
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.symmetric', () {
      test('creates with vertical and horizontal', () {
        final insets = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
        expect(insets.left, equals(20));
        expect(insets.top, equals(10));
        expect(insets.right, equals(20));
        expect(insets.bottom, equals(10));
      });

      test('creates with only vertical', () {
        final insets = EdgeInsets.symmetric(vertical: 10);
        expect(insets.left, equals(0));
        expect(insets.top, equals(10));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(10));
      });

      test('creates with only horizontal', () {
        final insets = EdgeInsets.symmetric(horizontal: 20);
        expect(insets.left, equals(20));
        expect(insets.top, equals(0));
        expect(insets.right, equals(20));
        expect(insets.bottom, equals(0));
      });

      test('creates with default values', () {
        final insets = EdgeInsets.symmetric();
        expect(insets.left, equals(0));
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
      });
    });

    group('EdgeInsets.only', () {
      test('creates with only top', () {
        final insets = EdgeInsets.only(top: 10);
        expect(insets.top, equals(10));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(0));
      });

      test('creates with only right', () {
        final insets = EdgeInsets.only(right: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(10));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(0));
      });

      test('creates with only bottom', () {
        final insets = EdgeInsets.only(bottom: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(10));
        expect(insets.left, equals(0));
      });

      test('creates with only left', () {
        final insets = EdgeInsets.only(left: 10);
        expect(insets.top, equals(0));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(10));
      });

      test('creates with mixed values', () {
        final insets = EdgeInsets.only(top: 5, left: 10);
        expect(insets.top, equals(5));
        expect(insets.right, equals(0));
        expect(insets.bottom, equals(0));
        expect(insets.left, equals(10));
      });
    });

    group('horizontal getter', () {
      test('returns left + right', () {
        final insets = EdgeInsets.fromLTRB(5, 0, 10, 0);
        expect(insets.horizontal, equals(15));
      });

      test('returns 0 for zero insets', () {
        final insets = EdgeInsets.all(0);
        expect(insets.horizontal, equals(0));
      });
    });

    group('vertical getter', () {
      test('returns top + bottom', () {
        final insets = EdgeInsets.fromLTRB(0, 5, 0, 10);
        expect(insets.vertical, equals(15));
      });

      test('returns 0 for zero insets', () {
        final insets = EdgeInsets.all(0);
        expect(insets.vertical, equals(0));
      });
    });

    group('operator +', () {
      test('adds two edge insets', () {
        final a = EdgeInsets.fromLTRB(5, 10, 15, 20);
        final b = EdgeInsets.fromLTRB(1, 2, 3, 4);
        final result = a + b;
        expect(result.left, equals(6));
        expect(result.top, equals(12));
        expect(result.right, equals(18));
        expect(result.bottom, equals(24));
      });

      test('adds zero insets', () {
        final insets = EdgeInsets.all(10);
        final zero = EdgeInsets.all(0);
        final result = insets + zero;
        expect(result, equals(insets));
      });
    });

    group('equality', () {
      test('equal insets have same hashCode', () {
        final a = EdgeInsets.all(10);
        final b = EdgeInsets.all(10);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different insets are not equal', () {
        final a = EdgeInsets.all(10);
        final b = EdgeInsets.all(11);
        expect(a, isNot(equals(b)));
      });

      test('fromLTRB and all with same values are equal', () {
        final a = EdgeInsets.fromLTRB(10, 10, 10, 10);
        final b = EdgeInsets.all(10);
        expect(a, equals(b));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        final insets = EdgeInsets.fromLTRB(5, 10, 15, 20);
        expect(insets.toString(), equals('EdgeInsets(5, 10, 15, 20)'));
      });
    });
  });
}
