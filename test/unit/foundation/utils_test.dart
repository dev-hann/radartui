import 'package:radartui/src/foundation/utils.dart';
import 'package:test/test.dart';

void main() {
  group('listEquals', () {
    test('returns true for identical lists', () {
      final a = [1, 2, 3];
      expect(listEquals(a, a), isTrue);
    });

    test('returns true for equal lists', () {
      expect(listEquals([1, 2, 3], [1, 2, 3]), isTrue);
    });

    test('returns false for different lengths', () {
      expect(listEquals([1, 2], [1, 2, 3]), isFalse);
    });

    test('returns false for different elements', () {
      expect(listEquals([1, 2, 3], [1, 2, 4]), isFalse);
    });

    test('returns true for two null lists', () {
      expect(listEquals(null, null), isTrue);
    });

    test('returns false for null and non-null', () {
      expect(listEquals([1], null), isFalse);
      expect(listEquals(null, [1]), isFalse);
    });

    test('returns true for empty lists', () {
      expect(listEquals(<int>[], <int>[]), isTrue);
    });
  });

  group('iterableEquals', () {
    test('returns true for identical iterables', () {
      final a = [1, 2, 3];
      expect(iterableEquals(a, a), isTrue);
    });

    test('returns true for equal iterables', () {
      expect(iterableEquals([1, 2, 3], [1, 2, 3]), isTrue);
    });

    test('returns false for different lengths', () {
      expect(iterableEquals([1, 2], [1, 2, 3]), isFalse);
      expect(iterableEquals([1, 2, 3], [1, 2]), isFalse);
    });

    test('returns false for different elements', () {
      expect(iterableEquals([1, 2, 3], [1, 2, 4]), isFalse);
    });

    test('returns true for two null iterables', () {
      expect(iterableEquals(null, null), isTrue);
    });

    test('returns false for null and non-null', () {
      expect(iterableEquals([1], null), isFalse);
      expect(iterableEquals(null, [1]), isFalse);
    });

    test('returns true for empty iterables', () {
      expect(iterableEquals(<int>[], <int>[]), isTrue);
    });

    test('works with sets', () {
      expect(
        iterableEquals({1, 2, 3}, {1, 2, 3}),
        isTrue,
      );
    });
  });

  group('setEquals', () {
    test('returns true for identical sets', () {
      final a = {1, 2, 3};
      expect(setEquals(a, a), isTrue);
    });

    test('returns true for equal sets', () {
      expect(setEquals({1, 2, 3}, {3, 2, 1}), isTrue);
    });

    test('returns false for different lengths', () {
      expect(setEquals({1, 2}, {1, 2, 3}), isFalse);
    });

    test('returns false for different elements', () {
      expect(setEquals({1, 2, 3}, {1, 2, 4}), isFalse);
    });

    test('returns true for two null sets', () {
      expect(setEquals(null, null), isTrue);
    });

    test('returns false for null and non-null', () {
      expect(setEquals({1}, null), isFalse);
      expect(setEquals(null, {1}), isFalse);
    });

    test('returns true for empty sets', () {
      expect(setEquals(<int>{}, <int>{}), isTrue);
    });
  });

  group('mapEquals', () {
    test('returns true for identical maps', () {
      final a = {'a': 1};
      expect(mapEquals(a, a), isTrue);
    });

    test('returns true for equal maps', () {
      expect(mapEquals({'a': 1, 'b': 2}, {'a': 1, 'b': 2}), isTrue);
    });

    test('returns true for equal maps with different insertion order', () {
      expect(mapEquals({'a': 1, 'b': 2}, {'b': 2, 'a': 1}), isTrue);
    });

    test('returns false for different lengths', () {
      expect(mapEquals({'a': 1}, {'a': 1, 'b': 2}), isFalse);
    });

    test('returns false for different values', () {
      expect(mapEquals({'a': 1}, {'a': 2}), isFalse);
    });

    test('returns false for different keys', () {
      expect(mapEquals({'a': 1}, {'b': 1}), isFalse);
    });

    test('returns true for two null maps', () {
      expect(mapEquals(null, null), isTrue);
    });

    test('returns false for null and non-null', () {
      expect(mapEquals({'a': 1}, null), isFalse);
      expect(mapEquals(null, {'a': 1}), isFalse);
    });

    test('returns true for empty maps', () {
      expect(mapEquals(<String, int>{}, <String, int>{}), isTrue);
    });
  });
}
