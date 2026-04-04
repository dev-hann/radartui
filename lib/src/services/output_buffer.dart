import '../foundation.dart';
import 'logger.dart';
import 'terminal.dart';

class Cell {
  const Cell(this.char, [this.style]);
  final String char;
  final TextStyle? style;

  static const empty = Cell(' ');

  @override
  bool operator ==(Object other) =>
      other is Cell && char == other.char && _styleEquals(style, other.style);

  @override
  int get hashCode => char.hashCode ^ (style?.hashCode ?? 0);

  static bool _styleEquals(TextStyle? a, TextStyle? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a == b;
  }
}

class OutputBuffer {
  OutputBuffer(this.terminal) {
    resize();
  }
  final Terminal terminal;
  late List<List<Cell>> _grid;
  late List<List<Cell>> _previousGrid;

  void resize() {
    _grid = List.generate(
      terminal.height,
      (_) => List.generate(terminal.width, (_) => Cell.empty),
    );
    _previousGrid = List.generate(
      terminal.height,
      (_) => List.generate(terminal.width, (_) => Cell.empty),
    );
  }

  void write(int x, int y, String char) {
    writeStyled(x, y, char, null);
  }

  void writeStyled(int x, int y, String char, TextStyle? style) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) {
      AppLogger.log(
        'OutputBuffer: Write out of bounds - x:$x, y:$y, '
        'terminal size: ${terminal.width}x${terminal.height}',
      );
      return;
    }
    _grid[y][x] = Cell(char, style);
  }

  void clear() {
    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
      }
    }
  }

  void clearAll() {
    terminal.clear();

    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
        _previousGrid[y][x] = const Cell('');
      }
    }
  }

  void smartClear() {
    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
      }
    }
  }

  bool needsFullClear() {
    // Check if current content footprint is smaller than previous
    // This indicates we might need to clear remnants
    int currentContent = 0;
    int previousContent = 0;

    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        if (_grid[y][x].char != ' ') currentContent++;
        if (_previousGrid[y][x].char != ' ') previousContent++;
      }
    }

    // If previous frame had significantly more content, we might have remnants
    return previousContent >
        currentContent + 10; // Threshold to avoid false positives
  }

  void conditionalClear() {
    if (needsFullClear()) {
      // Use aggressive clearing only when remnants are likely
      clearAll();
    } else {
      // Use smart clearing for smooth rendering
      smartClear();
    }
  }

  String _buildAnsiEscapeCode(TextStyle? style) {
    if (style == null) {
      return '\x1b[0m';
    }

    final List<String> codes = ['0'];

    if (style.bold) codes.add('1');
    if (style.dim) codes.add('2');
    if (style.italic) codes.add('3');
    if (style.underline) codes.add('4');

    if (style.color != null) {
      codes.add(_colorToAnsi(style.color!.value, true));
    }

    if (style.backgroundColor != null) {
      codes.add(_colorToAnsi(style.backgroundColor!.value, false));
    }

    return '\x1b[${codes.join(';')}m';
  }

  String _colorToAnsi(int value, bool foreground) {
    if (value < 0) return foreground ? '39' : '49';
    if (value < 8) {
      return foreground ? '3$value' : '4$value';
    }
    if (value < 16) {
      final brightValue = value - 8;
      return foreground ? '9$brightValue' : '10$brightValue';
    }
    return foreground ? '39' : '49';
  }

  void flush() {
    final buffer = StringBuffer();
    TextStyle? currentStyle;

    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        if (_grid[y][x] == _previousGrid[y][x]) continue;

        buffer.write('\x1b[${y + 1};${x + 1}H');

        final newStyle = _grid[y][x].style;
        if (newStyle != currentStyle) {
          currentStyle = newStyle;
          buffer.write(_buildAnsiEscapeCode(currentStyle));
        }

        buffer.write(_grid[y][x].char);
        _previousGrid[y][x] = _grid[y][x];
      }
    }

    buffer.write('\x1b[0m');
    buffer.write('\x1b[1;1H');

    terminal.backend.write(buffer.toString());
    terminal.backend.flush();
  }
}
