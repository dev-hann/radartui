import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('StyleCache', () {
    test('get calls builder on first access', () {
      final cache = StyleCache();
      int buildCount = 0;

      final style = cache.get('body', () {
        buildCount++;
        return const TextStyle(bold: true);
      });

      expect(style.bold, isTrue);
      expect(buildCount, equals(1));
    });

    test('get returns cached value on subsequent access', () {
      final cache = StyleCache();
      int buildCount = 0;

      final builder = () {
        buildCount++;
        return const TextStyle(color: Color.red);
      };

      final first = cache.get('body', builder);
      final second = cache.get('body', builder);

      expect(identical(first, second), isTrue);
      expect(buildCount, equals(1));
    });

    test('different keys use different cache entries', () {
      final cache = StyleCache();
      int buildCount = 0;

      final builder = () {
        buildCount++;
        return const TextStyle();
      };

      cache.get('a', builder);
      cache.get('b', builder);

      expect(buildCount, equals(2));
    });

    test('clear invalidates cache', () {
      final cache = StyleCache();
      int buildCount = 0;

      final builder = () {
        buildCount++;
        return const TextStyle();
      };

      cache.get('body', builder);
      expect(buildCount, equals(1));

      cache.clear();
      expect(cache.isValid, isFalse);

      cache.get('body', builder);
      expect(buildCount, equals(2));
    });

    test('isValid is false initially', () {
      final cache = StyleCache();
      expect(cache.isValid, isFalse);
    });

    test('clear resets isValid to false', () {
      final cache = StyleCache();
      cache.clear();
      expect(cache.isValid, isFalse);
    });
  });

  group('TextWidthCache', () {
    test('get returns string width', () {
      final cache = TextWidthCache();
      final width = cache.get('hello');
      expect(width, equals(5));
    });

    test('get returns cached width for identical string instance', () {
      final cache = TextWidthCache();
      final text = 'hello';

      final w1 = cache.get(text);
      final w2 = cache.get(text);

      expect(w1, equals(w2));
      expect(w1, equals(5));
    });

    test('get recalculates for different string', () {
      final cache = TextWidthCache();

      cache.get('hi');
      final width = cache.get('goodbye');

      expect(width, equals(7));
    });

    test('invalidate forces recalculation', () {
      final cache = TextWidthCache();
      final text = 'test';

      final w1 = cache.get(text);
      cache.invalidate();
      final w2 = cache.get(text);

      expect(w1, equals(w2));
      expect(w2, equals(4));
    });

    test('handles empty string', () {
      final cache = TextWidthCache();
      expect(cache.get(''), equals(0));
    });

    test('handles wide characters', () {
      final cache = TextWidthCache();
      expect(cache.get('\u4e16\u754c'), equals(4));
    });
  });
}
