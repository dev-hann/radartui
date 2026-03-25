import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('BoxConstraints', () {
    group('default constructor', () {
      test('creates with default values', () {
        const constraints = BoxConstraints();
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(999999));
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(999999));
      });

      test('creates with custom values', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.minWidth, equals(10));
        expect(constraints.maxWidth, equals(100));
        expect(constraints.minHeight, equals(5));
        expect(constraints.maxHeight, equals(50));
      });
    });

    group('BoxConstraints.tight', () {
      test('creates tight constraints for size', () {
        final constraints = BoxConstraints.tight(const Size(80, 24));
        expect(constraints.minWidth, equals(80));
        expect(constraints.maxWidth, equals(80));
        expect(constraints.minHeight, equals(24));
        expect(constraints.maxHeight, equals(24));
        expect(constraints.isTight, isTrue);
      });

      test('creates tight constraints for zero size', () {
        final constraints = BoxConstraints.tight(Size.zero);
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(0));
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(0));
        expect(constraints.isTight, isTrue);
      });
    });

    group('BoxConstraints.loose', () {
      test('creates loose constraints for size', () {
        final constraints = BoxConstraints.loose(const Size(80, 24));
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(80));
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(24));
        expect(constraints.isTight, isFalse);
      });
    });

    group('BoxConstraints.expand', () {
      test('creates expand constraints with no arguments', () {
        const constraints = BoxConstraints.expand();
        expect(constraints.minWidth, equals(999999));
        expect(constraints.maxWidth, equals(999999));
        expect(constraints.minHeight, equals(999999));
        expect(constraints.maxHeight, equals(999999));
        expect(constraints.isTight, isTrue);
      });

      test('creates expand constraints with specific size', () {
        const constraints = BoxConstraints.expand(width: 100, height: 50);
        expect(constraints.minWidth, equals(100));
        expect(constraints.maxWidth, equals(100));
        expect(constraints.minHeight, equals(50));
        expect(constraints.maxHeight, equals(50));
        expect(constraints.isTight, isTrue);
      });

      test('creates expand constraints with only width', () {
        const constraints = BoxConstraints.expand(width: 100);
        expect(constraints.minWidth, equals(100));
        expect(constraints.maxWidth, equals(100));
        expect(constraints.minHeight, equals(999999));
        expect(constraints.maxHeight, equals(999999));
      });
    });

    group('BoxConstraints.tightFor', () {
      test('creates tight constraints for width only', () {
        const constraints = BoxConstraints.tightFor(width: 100);
        expect(constraints.minWidth, equals(100));
        expect(constraints.maxWidth, equals(100));
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(999999));
      });

      test('creates tight constraints for height only', () {
        const constraints = BoxConstraints.tightFor(height: 50);
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(999999));
        expect(constraints.minHeight, equals(50));
        expect(constraints.maxHeight, equals(50));
      });

      test('creates tight constraints for both dimensions', () {
        const constraints = BoxConstraints.tightFor(width: 100, height: 50);
        expect(constraints.minWidth, equals(100));
        expect(constraints.maxWidth, equals(100));
        expect(constraints.minHeight, equals(50));
        expect(constraints.maxHeight, equals(50));
        expect(constraints.isTight, isTrue);
      });

      test('creates unbounded constraints with no arguments', () {
        const constraints = BoxConstraints.tightFor();
        expect(constraints.minWidth, equals(0));
        expect(constraints.maxWidth, equals(999999));
        expect(constraints.minHeight, equals(0));
        expect(constraints.maxHeight, equals(999999));
      });
    });

    group('isTight', () {
      test('returns true when width and height are tight', () {
        final constraints = BoxConstraints.tight(const Size(100, 50));
        expect(constraints.isTight, isTrue);
      });

      test('returns false when only width is tight', () {
        const constraints = BoxConstraints(
          minWidth: 100,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 999999,
        );
        expect(constraints.isTight, isFalse);
      });

      test('returns false when only height is tight', () {
        const constraints = BoxConstraints(
          minWidth: 0,
          maxWidth: 999999,
          minHeight: 50,
          maxHeight: 50,
        );
        expect(constraints.isTight, isFalse);
      });

      test('returns false when neither is tight', () {
        final constraints = BoxConstraints.loose(const Size(100, 50));
        expect(constraints.isTight, isFalse);
      });
    });

    group('isNormalized', () {
      test('returns true for valid constraints', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.isNormalized, isTrue);
      });

      test('returns true for tight constraints', () {
        final constraints = BoxConstraints.tight(const Size(100, 50));
        expect(constraints.isNormalized, isTrue);
      });

      test('returns true for default constraints', () {
        const constraints = BoxConstraints();
        expect(constraints.isNormalized, isTrue);
      });
    });

    group('loosen', () {
      test('converts tight constraints to loose', () {
        final tight = BoxConstraints.tight(const Size(100, 50));
        final loose = tight.loosen();
        expect(loose.minWidth, equals(0));
        expect(loose.maxWidth, equals(100));
        expect(loose.minHeight, equals(0));
        expect(loose.maxHeight, equals(50));
      });

      test('preserves max values from original', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        final loose = constraints.loosen();
        expect(loose.minWidth, equals(0));
        expect(loose.maxWidth, equals(100));
        expect(loose.minHeight, equals(0));
        expect(loose.maxHeight, equals(50));
      });
    });

    group('enforce', () {
      test('enforces tighter constraints', () {
        const original = BoxConstraints(
          minWidth: 0,
          maxWidth: 200,
          minHeight: 0,
          maxHeight: 100,
        );
        const enforced = BoxConstraints(
          minWidth: 50,
          maxWidth: 100,
          minHeight: 20,
          maxHeight: 60,
        );
        final result = original.enforce(enforced);
        expect(result.minWidth, equals(50));
        expect(result.maxWidth, equals(100));
        expect(result.minHeight, equals(20));
        expect(result.maxHeight, equals(60));
      });

      test('clamps values to enforced bounds', () {
        const original = BoxConstraints(
          minWidth: 0,
          maxWidth: 200,
          minHeight: 0,
          maxHeight: 100,
        );
        const enforced = BoxConstraints(
          minWidth: 50,
          maxWidth: 150,
          minHeight: 25,
          maxHeight: 75,
        );
        final result = original.enforce(enforced);
        expect(result.minWidth, equals(50));
        expect(result.maxWidth, equals(150));
        expect(result.minHeight, equals(25));
        expect(result.maxHeight, equals(75));
      });
    });

    group('constrain', () {
      test('constrains size within bounds', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.constrain(const Size(50, 25)), equals(const Size(50, 25)));
      });

      test('clamps size to min bounds', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.constrain(const Size(5, 2)), equals(const Size(10, 5)));
      });

      test('clamps size to max bounds', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.constrain(const Size(150, 75)), equals(const Size(100, 50)));
      });

      test('returns exact size for tight constraints', () {
        final constraints = BoxConstraints.tight(const Size(100, 50));
        expect(constraints.constrain(const Size(200, 200)), equals(const Size(100, 50)));
        expect(constraints.constrain(const Size(0, 0)), equals(const Size(100, 50)));
      });
    });

    group('deflate', () {
      test('deflates with symmetric padding', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        const padding = EdgeInsets.all(5);
        final deflated = constraints.deflate(padding);
        expect(deflated.minWidth, equals(0));
        expect(deflated.maxWidth, equals(90));
        expect(deflated.minHeight, equals(0));
        expect(deflated.maxHeight, equals(40));
      });

      test('deflates with asymmetric padding', () {
        const constraints = BoxConstraints(
          minWidth: 20,
          maxWidth: 100,
          minHeight: 10,
          maxHeight: 50,
        );
        const padding = EdgeInsets.fromLTRB(5, 10, 5, 10);
        final deflated = constraints.deflate(padding);
        expect(deflated.minWidth, equals(10));
        expect(deflated.maxWidth, equals(90));
        expect(deflated.minHeight, equals(0));
        expect(deflated.maxHeight, equals(30));
      });

      test('handles padding larger than constraints', () {
        const constraints = BoxConstraints(
          minWidth: 5,
          maxWidth: 10,
          minHeight: 5,
          maxHeight: 10,
        );
        const padding = EdgeInsets.all(10);
        final deflated = constraints.deflate(padding);
        expect(deflated.minWidth, equals(0));
        expect(deflated.maxWidth, equals(0));
        expect(deflated.minHeight, equals(0));
        expect(deflated.maxHeight, equals(0));
      });

      test('handles zero padding', () {
        final constraints = BoxConstraints.tight(const Size(100, 50));
        const padding = EdgeInsets.all(0);
        final deflated = constraints.deflate(padding);
        expect(deflated.minWidth, equals(100));
        expect(deflated.maxWidth, equals(100));
        expect(deflated.minHeight, equals(50));
        expect(deflated.maxHeight, equals(50));
      });

      test('ensures min does not exceed max after deflation', () {
        const constraints = BoxConstraints(
          minWidth: 15,
          maxWidth: 20,
          minHeight: 15,
          maxHeight: 20,
        );
        const padding = EdgeInsets.all(10);
        final deflated = constraints.deflate(padding);
        expect(deflated.minWidth, lessThanOrEqualTo(deflated.maxWidth));
        expect(deflated.minHeight, lessThanOrEqualTo(deflated.maxHeight));
      });
    });

    group('equality', () {
      test('equal constraints have same hashCode', () {
        final a = BoxConstraints.tight(const Size(100, 50));
        final b = BoxConstraints.tight(const Size(100, 50));
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different constraints are not equal', () {
        final a = BoxConstraints.tight(const Size(100, 50));
        final b = BoxConstraints.tight(const Size(100, 51));
        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const constraints = BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 5,
          maxHeight: 50,
        );
        expect(constraints.toString(), contains('10-100'));
        expect(constraints.toString(), contains('5-50'));
      });
    });
  });
}
