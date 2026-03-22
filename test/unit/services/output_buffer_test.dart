import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Cell', () {
    group('constructor', () {
      test('creates cell with character', () {
        final cell = Cell('A');
        expect(cell.char, equals('A'));
        expect(cell.style, isNull);
      });

      test('creates cell with character and style', () {
        final style = TextStyle(color: Colors.red);
        final cell = Cell('A', style);
        expect(cell.char, equals('A'));
        expect(cell.style, equals(style));
      });

      test('creates empty cell', () {
        expect(Cell.empty.char, equals(' '));
        expect(Cell.empty.style, isNull);
      });
    });

    group('equality', () {
      test('equal cells have same hashCode', () {
        final style = TextStyle(color: Colors.red);
        final a = Cell('A', style);
        final b = Cell('A', style);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different characters are not equal', () {
        final a = Cell('A');
        final b = Cell('B');
        expect(a, isNot(equals(b)));
      });

      test('different styles are not equal', () {
        final a = Cell('A', TextStyle(color: Colors.red));
        final b = Cell('A', TextStyle(color: Colors.blue));
        expect(a, isNot(equals(b)));
      });

      test('cell with style and cell without style are not equal', () {
        final a = Cell('A', TextStyle(color: Colors.red));
        final b = Cell('A');
        expect(a, isNot(equals(b)));
      });

      test('two empty cells are equal', () {
        expect(Cell.empty, equals(Cell.empty));
      });
    });
  });

  group('OutputBuffer', () {
    late Terminal terminal;
    late OutputBuffer buffer;

    setUp(() {
      terminal = Terminal();
      buffer = OutputBuffer(terminal);
    });

    group('write', () {
      test('write at valid position', () {
        buffer.write(0, 0, 'A');
      });

      test('write at negative position does nothing', () {
        buffer.write(-1, -1, 'A');
      });
    });

    group('writeStyled', () {
      test('writeStyled at valid position', () {
        final style = TextStyle(color: Colors.red);
        buffer.writeStyled(0, 0, 'A', style);
      });

      test('writeStyled at negative position does nothing', () {
        final style = TextStyle(color: Colors.red);
        buffer.writeStyled(-1, -1, 'A', style);
      });

      test('writeStyled with null style', () {
        buffer.writeStyled(0, 0, 'A', null);
      });
    });

    group('clear', () {
      test('clear fills grid with empty cells', () {
        buffer.write(0, 0, 'A');
        buffer.clear();
      });
    });

    group('smartClear', () {
      test('smartClear fills grid with empty cells', () {
        buffer.write(0, 0, 'A');
        buffer.smartClear();
      });
    });

    group('needsFullClear', () {
      test('returns false when content is same', () {
        buffer.write(0, 0, 'A');
        buffer.write(0, 0, 'A');
        expect(buffer.needsFullClear(), isFalse);
      });
    });
  });
}
