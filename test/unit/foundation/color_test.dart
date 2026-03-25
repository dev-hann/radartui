import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Color', () {
    group('constructor', () {
      test('creates color with value', () {
        const color = Color(5);
        expect(color.value, equals(5));
      });

      test('creates color with zero value', () {
        const color = Color(0);
        expect(color.value, equals(0));
      });

      test('creates color with negative value', () {
        const color = Color(-1);
        expect(color.value, equals(-1));
      });
    });

    group('basic colors', () {
      test('black has value 0', () {
        expect(Color.black.value, equals(0));
      });

      test('red has value 1', () {
        expect(Color.red.value, equals(1));
      });

      test('green has value 2', () {
        expect(Color.green.value, equals(2));
      });

      test('yellow has value 3', () {
        expect(Color.yellow.value, equals(3));
      });

      test('blue has value 4', () {
        expect(Color.blue.value, equals(4));
      });

      test('magenta has value 5', () {
        expect(Color.magenta.value, equals(5));
      });

      test('cyan has value 6', () {
        expect(Color.cyan.value, equals(6));
      });

      test('white has value 7', () {
        expect(Color.white.value, equals(7));
      });
    });

    group('bright colors', () {
      test('brightBlack has value 8', () {
        expect(Color.brightBlack.value, equals(8));
      });

      test('brightRed has value 9', () {
        expect(Color.brightRed.value, equals(9));
      });

      test('brightGreen has value 10', () {
        expect(Color.brightGreen.value, equals(10));
      });

      test('brightYellow has value 11', () {
        expect(Color.brightYellow.value, equals(11));
      });

      test('brightBlue has value 12', () {
        expect(Color.brightBlue.value, equals(12));
      });

      test('brightMagenta has value 13', () {
        expect(Color.brightMagenta.value, equals(13));
      });

      test('brightCyan has value 14', () {
        expect(Color.brightCyan.value, equals(14));
      });

      test('brightWhite has value 15', () {
        expect(Color.brightWhite.value, equals(15));
      });
    });

    group('special colors', () {
      test('transparent has value -1', () {
        expect(Color.transparent.value, equals(-1));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const color = Color(5);
        expect(color.toString(), equals('Color(5)'));
      });
    });
  });

  group('Colors', () {
    group('basic colors', () {
      test('black has value 0', () {
        expect(Colors.black.value, equals(0));
      });

      test('red has value 1', () {
        expect(Colors.red.value, equals(1));
      });

      test('green has value 2', () {
        expect(Colors.green.value, equals(2));
      });

      test('yellow has value 3', () {
        expect(Colors.yellow.value, equals(3));
      });

      test('blue has value 4', () {
        expect(Colors.blue.value, equals(4));
      });

      test('magenta has value 5', () {
        expect(Colors.magenta.value, equals(5));
      });

      test('cyan has value 6', () {
        expect(Colors.cyan.value, equals(6));
      });

      test('white has value 7', () {
        expect(Colors.white.value, equals(7));
      });
    });

    group('bright colors', () {
      test('brightBlack has value 8', () {
        expect(Colors.brightBlack.value, equals(8));
      });

      test('brightRed has value 9', () {
        expect(Colors.brightRed.value, equals(9));
      });

      test('brightGreen has value 10', () {
        expect(Colors.brightGreen.value, equals(10));
      });

      test('brightYellow has value 11', () {
        expect(Colors.brightYellow.value, equals(11));
      });

      test('brightBlue has value 12', () {
        expect(Colors.brightBlue.value, equals(12));
      });

      test('brightMagenta has value 13', () {
        expect(Colors.brightMagenta.value, equals(13));
      });

      test('brightCyan has value 14', () {
        expect(Colors.brightCyan.value, equals(14));
      });

      test('brightWhite has value 15', () {
        expect(Colors.brightWhite.value, equals(15));
      });
    });

    group('special colors', () {
      test('transparent has value -1', () {
        expect(Colors.transparent.value, equals(-1));
      });

      test('black54 has value 16', () {
        expect(Colors.black54.value, equals(16));
      });
    });
  });

  group('TextStyle', () {
    group('constructor', () {
      test('creates with default values', () {
        const style = TextStyle();
        expect(style.color, isNull);
        expect(style.backgroundColor, isNull);
        expect(style.bold, isFalse);
        expect(style.italic, isFalse);
        expect(style.underline, isFalse);
        expect(style.fontFamily, equals(FontFamily.monospace));
      });

      test('creates with color', () {
        const style = TextStyle(color: Colors.red);
        expect(style.color, equals(Colors.red));
      });

      test('creates with backgroundColor', () {
        const style = TextStyle(backgroundColor: Colors.blue);
        expect(style.backgroundColor, equals(Colors.blue));
      });

      test('creates with bold', () {
        const style = TextStyle(bold: true);
        expect(style.bold, isTrue);
      });

      test('creates with italic', () {
        const style = TextStyle(italic: true);
        expect(style.italic, isTrue);
      });

      test('creates with underline', () {
        const style = TextStyle(underline: true);
        expect(style.underline, isTrue);
      });

      test('creates with fontFamily', () {
        const style = TextStyle(fontFamily: FontFamily.system);
        expect(style.fontFamily, equals(FontFamily.system));
      });

      test('creates with all properties', () {
        const style = TextStyle(
          color: Colors.red,
          backgroundColor: Colors.blue,
          bold: true,
          italic: true,
          underline: true,
          fontFamily: FontFamily.system,
        );
        expect(style.color, equals(Colors.red));
        expect(style.backgroundColor, equals(Colors.blue));
        expect(style.bold, isTrue);
        expect(style.italic, isTrue);
        expect(style.underline, isTrue);
        expect(style.fontFamily, equals(FontFamily.system));
      });
    });

    group('equality', () {
      test('equal styles have same hashCode', () {
        const a = TextStyle(color: Colors.red, bold: true);
        const b = TextStyle(color: Colors.red, bold: true);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different styles are not equal', () {
        const a = TextStyle(color: Colors.red);
        const b = TextStyle(color: Colors.blue);
        expect(a, isNot(equals(b)));
      });

      test('default styles are equal', () {
        const a = TextStyle();
        const b = TextStyle();
        expect(a, equals(b));
      });
    });

    group('toString', () {
      test('returns readable representation', () {
        const style = TextStyle(color: Colors.red);
        expect(style.toString(), contains('Color(1)'));
      });
    });
  });

  group('FontFamily', () {
    test('has system value', () {
      expect(FontFamily.system.index, equals(0));
    });

    test('has monospace value', () {
      expect(FontFamily.monospace.index, equals(1));
    });
  });
}
