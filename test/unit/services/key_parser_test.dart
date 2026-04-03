import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('KeyParser', () {
    group('empty input', () {
      test('returns unknown for empty data', () {
        final event = KeyParser.parse([]);
        expect(event.code, equals(KeyCode.unknown));
      });
    });

    group('single character keys', () {
      test('parses escape key', () {
        final event = KeyParser.parse([27]);
        expect(event.code, equals(KeyCode.escape));
      });

      test('parses tab key', () {
        final event = KeyParser.parse([9]);
        expect(event.code, equals(KeyCode.tab));
        expect(event.isShiftPressed, isFalse);
      });

      test('parses enter key (LF)', () {
        final event = KeyParser.parse([10]);
        expect(event.code, equals(KeyCode.enter));
      });

      test('parses enter key (CR)', () {
        final event = KeyParser.parse([13]);
        expect(event.code, equals(KeyCode.enter));
      });

      test('parses backspace (127)', () {
        final event = KeyParser.parse([127]);
        expect(event.code, equals(KeyCode.backspace));
      });

      test('parses backspace (8)', () {
        final event = KeyParser.parse([8]);
        expect(event.code, equals(KeyCode.backspace));
      });

      test('parses space key', () {
        final event = KeyParser.parse([32]);
        expect(event.code, equals(KeyCode.space));
      });
    });

    group('arrow keys', () {
      test('parses arrow up', () {
        final event = KeyParser.parse([27, 91, 65]);
        expect(event.code, equals(KeyCode.arrowUp));
      });

      test('parses arrow down', () {
        final event = KeyParser.parse([27, 91, 66]);
        expect(event.code, equals(KeyCode.arrowDown));
      });

      test('parses arrow right', () {
        final event = KeyParser.parse([27, 91, 67]);
        expect(event.code, equals(KeyCode.arrowRight));
      });

      test('parses arrow left', () {
        final event = KeyParser.parse([27, 91, 68]);
        expect(event.code, equals(KeyCode.arrowLeft));
      });
    });

    group('arrow keys with modifiers', () {
      test('parses arrow up with shift', () {
        final event = KeyParser.parse([27, 91, 49, 59, 65]);
        expect(event.code, equals(KeyCode.arrowUp));
        expect(event.isShiftPressed, isTrue);
        expect(event.isAltPressed, isFalse);
        expect(event.isCtrlPressed, isFalse);
      });

      test('parses arrow down with alt', () {
        final event = KeyParser.parse([27, 91, 50, 59, 66]);
        expect(event.code, equals(KeyCode.arrowDown));
        expect(event.isShiftPressed, isFalse);
        expect(event.isAltPressed, isTrue);
        expect(event.isCtrlPressed, isFalse);
      });

      test('parses arrow right with ctrl', () {
        final event = KeyParser.parse([27, 91, 52, 59, 67]);
        expect(event.code, equals(KeyCode.arrowRight));
        expect(event.isShiftPressed, isFalse);
        expect(event.isAltPressed, isFalse);
        expect(event.isCtrlPressed, isTrue);
      });

      test('parses arrow left with shift+alt', () {
        final event = KeyParser.parse([27, 91, 51, 59, 68]);
        expect(event.code, equals(KeyCode.arrowLeft));
        expect(event.isShiftPressed, isTrue);
        expect(event.isAltPressed, isTrue);
        expect(event.isCtrlPressed, isFalse);
      });

      test('parses arrow up with shift+alt+ctrl', () {
        final event = KeyParser.parse([27, 91, 55, 59, 65]);
        expect(event.code, equals(KeyCode.arrowUp));
        expect(event.isShiftPressed, isTrue);
        expect(event.isAltPressed, isTrue);
        expect(event.isCtrlPressed, isTrue);
      });
    });

    group('home and end keys', () {
      test('parses home (ESC[H)', () {
        final event = KeyParser.parse([27, 91, 72]);
        expect(event.code, equals(KeyCode.home));
      });

      test('parses end (ESC[F)', () {
        final event = KeyParser.parse([27, 91, 70]);
        expect(event.code, equals(KeyCode.end));
      });

      test('parses home (ESC[1~)', () {
        final event = KeyParser.parse([27, 91, 49, 126]);
        expect(event.code, equals(KeyCode.home));
      });

      test('parses end (ESC[4~)', () {
        final event = KeyParser.parse([27, 91, 52, 126]);
        expect(event.code, equals(KeyCode.end));
      });
    });

    group('navigation keys', () {
      test('parses insert (ESC[2~)', () {
        final event = KeyParser.parse([27, 91, 50, 126]);
        expect(event.code, equals(KeyCode.insert));
      });

      test('parses delete (ESC[3~)', () {
        final event = KeyParser.parse([27, 91, 51, 126]);
        expect(event.code, equals(KeyCode.delete));
      });

      test('parses page up (ESC[5~)', () {
        final event = KeyParser.parse([27, 91, 53, 126]);
        expect(event.code, equals(KeyCode.pageUp));
      });

      test('parses page down (ESC[6~)', () {
        final event = KeyParser.parse([27, 91, 54, 126]);
        expect(event.code, equals(KeyCode.pageDown));
      });
    });

    group('F-keys (VT100 sequence: ESC O P)', () {
      test('parses F1 (ESC O P)', () {
        final event = KeyParser.parse([27, 79, 80]);
        expect(event.code, equals(KeyCode.f1));
      });

      test('parses F2 (ESC O Q)', () {
        final event = KeyParser.parse([27, 79, 81]);
        expect(event.code, equals(KeyCode.f2));
      });

      test('parses F3 (ESC O R)', () {
        final event = KeyParser.parse([27, 79, 82]);
        expect(event.code, equals(KeyCode.f3));
      });

      test('parses F4 (ESC O S)', () {
        final event = KeyParser.parse([27, 79, 83]);
        expect(event.code, equals(KeyCode.f4));
      });
    });

    group('F-keys (extended sequence: ESC [ nn ~)', () {
      test('parses F3 (ESC[13~)', () {
        final event = KeyParser.parse([27, 91, 49, 51, 126]);
        expect(event.code, equals(KeyCode.f3));
      });

      test('parses F4 (ESC[14~)', () {
        final event = KeyParser.parse([27, 91, 49, 52, 126]);
        expect(event.code, equals(KeyCode.f4));
      });

      test('parses F5 (ESC[15~)', () {
        final event = KeyParser.parse([27, 91, 49, 53, 126]);
        expect(event.code, equals(KeyCode.f5));
      });

      test('parses F6 (ESC[17~)', () {
        final event = KeyParser.parse([27, 91, 49, 55, 126]);
        expect(event.code, equals(KeyCode.f6));
      });

      test('parses F7 (ESC[18~)', () {
        final event = KeyParser.parse([27, 91, 49, 56, 126]);
        expect(event.code, equals(KeyCode.f7));
      });

      test('parses F8 (ESC[19~)', () {
        final event = KeyParser.parse([27, 91, 49, 57, 126]);
        expect(event.code, equals(KeyCode.f8));
      });

      test('parses F9 (ESC[20~)', () {
        final event = KeyParser.parse([27, 91, 50, 48, 126]);
        expect(event.code, equals(KeyCode.f9));
      });

      test('parses F10 (ESC[21~)', () {
        final event = KeyParser.parse([27, 91, 50, 49, 126]);
        expect(event.code, equals(KeyCode.f10));
      });

      test('parses F11 (ESC[23~)', () {
        final event = KeyParser.parse([27, 91, 50, 51, 126]);
        expect(event.code, equals(KeyCode.f11));
      });

      test('parses F12 (ESC[24~)', () {
        final event = KeyParser.parse([27, 91, 50, 52, 126]);
        expect(event.code, equals(KeyCode.f12));
      });
    });

    group('shift+tab', () {
      test('parses shift+tab (ESC[Z)', () {
        final event = KeyParser.parse([27, 91, 90]);
        expect(event.code, equals(KeyCode.tab));
        expect(event.isShiftPressed, isTrue);
      });
    });

    group('ctrl+letter', () {
      test('parses Ctrl+A', () {
        final event = KeyParser.parse([1]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('A'));
        expect(event.isCtrlPressed, isTrue);
      });

      test('parses Ctrl+B', () {
        final event = KeyParser.parse([2]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('B'));
        expect(event.isCtrlPressed, isTrue);
      });

      test('parses Ctrl+Z', () {
        final event = KeyParser.parse([26]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('Z'));
        expect(event.isCtrlPressed, isTrue);
      });
    });

    group('alt+letter', () {
      test('parses Alt+a', () {
        final event = KeyParser.parse([27, 97]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('a'));
        expect(event.isAltPressed, isTrue);
      });

      test('parses Alt+A', () {
        final event = KeyParser.parse([27, 65]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('A'));
        expect(event.isAltPressed, isTrue);
      });
    });

    group('regular characters', () {
      test('parses lowercase letter', () {
        final event = KeyParser.parse([97]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('a'));
      });

      test('parses uppercase letter', () {
        final event = KeyParser.parse([65]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('A'));
      });

      test('parses digit', () {
        final event = KeyParser.parse([49]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('1'));
      });

      test('parses multiple characters', () {
        final event = KeyParser.parse([97, 98, 99]);
        expect(event.code, equals(KeyCode.char));
        expect(event.char, equals('abc'));
      });
    });
  });

  group('KeyEvent', () {
    group('toString', () {
      test('formats character key', () {
        const event = KeyEvent(code: KeyCode.char, char: 'a');
        expect(event.toString(), equals('KeyEvent(a)'));
      });

      test('formats character key with modifiers', () {
        const event = KeyEvent(
          code: KeyCode.char,
          char: 'a',
          isCtrlPressed: true,
          isAltPressed: true,
        );
        expect(event.toString(), equals('KeyEvent(Ctrl+Alt+a)'));
      });

      test('formats special key', () {
        const event = KeyEvent(code: KeyCode.arrowUp);
        expect(event.toString(), equals('KeyEvent(arrowUp)'));
      });

      test('formats special key with modifiers', () {
        const event = KeyEvent(code: KeyCode.arrowUp, isShiftPressed: true);
        expect(event.toString(), equals('KeyEvent(Shift+arrowUp)'));
      });

      test('formats all modifiers in order', () {
        const event = KeyEvent(
          code: KeyCode.enter,
          isCtrlPressed: true,
          isAltPressed: true,
          isShiftPressed: true,
          isMetaPressed: true,
        );
        expect(event.toString(), equals('KeyEvent(Ctrl+Alt+Shift+Meta+enter)'));
      });
    });
  });
}
