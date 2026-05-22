import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('charWidth', () {
    group('ASCII printable characters', () {
      test('space returns 1', () {
        expect(charWidth(0x20), equals(1));
      });

      test('digits return 1', () {
        for (int cp = 0x30; cp <= 0x39; cp++) {
          expect(charWidth(cp), equals(1), reason: 'digit ${cp}');
        }
      });

      test('uppercase letters return 1', () {
        for (int cp = 0x41; cp <= 0x5A; cp++) {
          expect(charWidth(cp), equals(1), reason: 'char ${cp}');
        }
      });

      test('lowercase letters return 1', () {
        for (int cp = 0x61; cp <= 0x7A; cp++) {
          expect(charWidth(cp), equals(1), reason: 'char ${cp}');
        }
      });

      test('tilde (~) returns 1', () {
        expect(charWidth(0x7E), equals(1));
      });
    });

    group('control characters', () {
      test('null returns 0', () {
        expect(charWidth(0), equals(0));
      });

      test('tab returns 0', () {
        expect(charWidth(9), equals(0));
      });

      test('newline returns 0', () {
        expect(charWidth(10), equals(0));
      });

      test('carriage return returns 0', () {
        expect(charWidth(13), equals(0));
      });

      test('escape returns 0', () {
        expect(charWidth(27), equals(0));
      });

      test('delete (0x7F) returns 0', () {
        expect(charWidth(0x7F), equals(0));
      });

      test('C1 control area (0x80-0x9F) returns 0', () {
        expect(charWidth(0x80), equals(0));
        expect(charWidth(0x9F), equals(0));
      });
    });

    group('CJK wide characters', () {
      test('CJK Unified Ideographs (U+4E00) return 2', () {
        expect(charWidth(0x4E00), equals(2));
      });

      test('Hangul syllables (U+AC00) return 2', () {
        expect(charWidth(0xAC00), equals(2));
      });

      test('Katakana (U+30A1) return 2', () {
        expect(charWidth(0x30A1), equals(2));
      });

      test('Fullwidth forms (U+FF01) return 2', () {
        expect(charWidth(0xFF01), equals(2));
      });
    });

    group('emoji', () {
      test('emoji (U+1F600) return 2', () {
        expect(charWidth(0x1F600), equals(2));
      });
    });

    group('non-ASCII narrow characters', () {
      test('Latin-1 Supplement printable (U+00A0) returns 1', () {
        expect(charWidth(0xA0), equals(1));
      });

      test('Latin small letter e with acute (U+00E9) returns 1', () {
        expect(charWidth(0xE9), equals(1));
      });
    });
  });

  group('stringWidth', () {
    test('empty string returns 0', () {
      expect(stringWidth(''), equals(0));
    });

    test('ASCII string returns correct width', () {
      expect(stringWidth('hello'), equals(5));
    });

    test('string with control chars skips them', () {
      expect(stringWidth('a\x00b'), equals(2));
      expect(stringWidth('a\nb'), equals(2));
    });

    test('string with CJK characters counts wide chars as 2', () {
      expect(stringWidth('\u4E00\u4E01'), equals(4));
    });

    test('mixed ASCII and CJK', () {
      expect(stringWidth('A\u4E00B'), equals(4));
    });
  });
}
