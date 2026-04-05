import '../foundation.dart';
import 'logger.dart';
import 'terminal.dart';

/// Represents a single character cell with optional text styling.
class Cell {
  /// Creates a [Cell] with the given [char] and optional [style].
  const Cell(this.char, [this.style]);

  /// The character displayed in this cell.
  final String char;

  /// The text style applied to this cell, or `null` for default styling.
  final TextStyle? style;

  /// An empty cell containing a single space with no styling.
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

/// Manages a grid of character cells and renders diffs to the terminal.
class OutputBuffer {
  /// Creates an [OutputBuffer] for the given [terminal] and initializes the grid.
  OutputBuffer(this.terminal) {
    resize();
  }

  /// The terminal this buffer renders to.
  final Terminal terminal;
  late List<List<Cell>> _grid;
  late List<List<Cell>> _previousGrid;

  /// Rebuilds the internal grid to match the current terminal dimensions.
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

  /// Writes a character at the given position with default styling.
  void write(int x, int y, String char) {
    writeStyled(x, y, char, null);
  }

  /// Writes a character at the given position with the specified [style].
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

  /// Fills the entire grid with empty cells.
  void clear() {
    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
      }
    }
  }

  /// Clears both the grid and the terminal, forcing a full redraw on next flush.
  void clearAll() {
    terminal.clear();

    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
        _previousGrid[y][x] = const Cell('');
      }
    }
  }

  /// Fills the grid with empty cells while preserving the previous frame for diffing.
  void smartClear() {
    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell.empty;
      }
    }
  }

  /// Returns `true` if the previous frame had significantly more content than the current one.
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

  /// Clears using a full clear only when remnants are likely, otherwise uses a smart clear.
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

  /// Renders only the changed cells to the terminal since the last flush.
  void flush() {
    final StringBuffer buffer = StringBuffer();
    TextStyle? currentStyle;
    for (int y = 0; y < terminal.height; y++) {
      for (int x = 0; x < terminal.width; x++) {
        currentStyle = _flushCell(buffer, x, y, currentStyle);
      }
    }
    buffer.write('\x1b[0m');
    buffer.write('\x1b[1;1H');
    terminal.backend.write(buffer.toString());
    terminal.backend.flush();
  }

  TextStyle? _flushCell(
      StringBuffer buffer, int x, int y, TextStyle? currentStyle) {
    final Cell cell = _grid[y][x];
    if (cell.char.isEmpty) return currentStyle;
    if (cell == _previousGrid[y][x]) return currentStyle;
    buffer.write('\x1b[${y + 1};${x + 1}H');
    final TextStyle? newStyle = cell.style;
    if (newStyle != currentStyle) {
      currentStyle = newStyle;
      buffer.write(_buildAnsiEscapeCode(currentStyle));
    }
    buffer.write(cell.char);
    _previousGrid[y][x] = cell;
    final int w = charWidth(cell.char.codeUnitAt(0));
    if (w == 2 && x + 1 < terminal.width) {
      _previousGrid[y][x + 1] = _grid[y][x + 1];
    }
    return currentStyle;
  }
}
