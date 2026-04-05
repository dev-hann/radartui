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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Cell) return false;
    if (char != other.char) return false;
    final TextStyle? a = style;
    final TextStyle? b = other.style;
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a == b;
  }

  @override
  int get hashCode => char.hashCode ^ (style?.hashCode ?? 0);
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

  /// Writes a string of characters starting at ([x], [y]) with the given
  /// [style], advancing the cursor by [charWidth] per character.
  ///
  /// Unlike calling [writeStyled] per character, this checks row bounds once
  /// and silently clips characters that fall outside the column range.
  ///
  /// Returns the total width advance (sum of [charWidth] for all characters).
  int writeStringBatch(int x, int y, String text, TextStyle? style) {
    if (y < 0 || y >= terminal.height) {
      int totalWidth = 0;
      for (int i = 0; i < text.length; i++) {
        totalWidth += charWidth(text.codeUnitAt(i));
      }
      return totalWidth;
    }
    final int w = terminal.width;
    int col = x;
    for (int i = 0; i < text.length; i++) {
      final String ch = text[i];
      if (col >= 0 && col < w) {
        _grid[y][col] = Cell(ch, style);
      }
      col += charWidth(ch.codeUnitAt(0));
    }
    return col - x;
  }

  void _fillRow(int y) {
    _grid[y] = List<Cell>.filled(terminal.width, Cell.empty);
  }

  void _fillPreviousRow(int y, Cell cell) {
    _previousGrid[y] = List<Cell>.filled(terminal.width, cell);
  }

  /// Fills the entire grid with empty cells.
  void clear() {
    for (int y = 0; y < terminal.height; y++) {
      _fillRow(y);
    }
  }

  /// Clears both the grid and the terminal, forcing a full redraw on next flush.
  void clearAll() {
    terminal.clear();
    _previousGridPopulated = false;
    for (int y = 0; y < terminal.height; y++) {
      _fillRow(y);
      _fillPreviousRow(y, const Cell(''));
    }
  }

  /// Fills the grid with empty cells while preserving the previous frame for diffing.
  void smartClear() {
    clear();
  }

  static const int _fullClearThreshold = 10;

  bool _previousGridPopulated = false;

  /// Returns `true` if the previous frame had significantly more content than the current one.
  bool needsFullClear() {
    if (!_previousGridPopulated) return false;
    int currentContent = 0;
    int previousContent = 0;
    final int totalCells = terminal.height * terminal.width;

    for (int y = 0; y < terminal.height; y++) {
      final result =
          _scanRowContent(y, currentContent, previousContent, totalCells);
      if (result.$1) return true;
      currentContent = result.$2;
      previousContent = result.$3;
    }

    return previousContent > currentContent + _fullClearThreshold;
  }

  (bool, int, int) _scanRowContent(
    int y,
    int currentContent,
    int previousContent,
    int totalCells,
  ) {
    for (int x = 0; x < terminal.width; x++) {
      final int visited = y * terminal.width + x;
      if (previousContent >
          currentContent + (totalCells - visited) + _fullClearThreshold) {
        return (true, currentContent, previousContent);
      }
      if (_grid[y][x].char != ' ') currentContent++;
      if (_previousGrid[y][x].char != ' ') previousContent++;
    }
    return (false, currentContent, previousContent);
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

  static const List<String> _fgAnsi = [
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
  ];

  static const List<String> _bgAnsi = [
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '100',
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
  ];

  String _buildAnsiEscapeCode(TextStyle? style) {
    if (style == null) {
      return '\x1b[0m';
    }

    final StringBuffer buf = StringBuffer('\x1b[');
    buf.write('0');

    if (style.bold) buf.write(';1');
    if (style.dim) buf.write(';2');
    if (style.italic) buf.write(';3');
    if (style.underline) buf.write(';4');

    if (style.color != null) {
      final int v = style.color!.value;
      buf.write(';');
      buf.write(v >= 0 && v < 16 ? _fgAnsi[v] : '39');
    }

    if (style.backgroundColor != null) {
      final int v = style.backgroundColor!.value;
      buf.write(';');
      buf.write(v >= 0 && v < 16 ? _bgAnsi[v] : '49');
    }

    buf.write('m');
    return buf.toString();
  }

  TextStyle? _cachedAnsiStyle;
  String? _cachedAnsiCode;

  String _getCachedAnsiEscapeCode(TextStyle? style) {
    if (style == _cachedAnsiStyle && _cachedAnsiCode != null) {
      return _cachedAnsiCode!;
    }
    final String code = _buildAnsiEscapeCode(style);
    _cachedAnsiStyle = style;
    _cachedAnsiCode = code;
    return code;
  }

  /// Renders only the changed cells to the terminal since the last flush.
  void flush() {
    _flushBuffer.clear();
    int cursorX = -1;
    int cursorY = -1;
    TextStyle? currentStyle;

    for (int y = 0; y < terminal.height; y++) {
      final result = _flushRow(
        y,
        _flushBuffer,
        cursorX: cursorX,
        cursorY: cursorY,
        currentStyle: currentStyle,
      );
      cursorX = result.$1;
      cursorY = result.$2;
      currentStyle = result.$3;
    }
    _flushBuffer.write('\x1b[0m');
    _flushBuffer.write('\x1b[1;1H');
    terminal.backend.write(_flushBuffer.toString());
    terminal.backend.flush();
  }

  final StringBuffer _flushBuffer = StringBuffer();

  (int, int, TextStyle?) _flushRow(
    int y,
    StringBuffer buffer, {
    required int cursorX,
    required int cursorY,
    required TextStyle? currentStyle,
  }) {
    for (int x = 0; x < terminal.width; x++) {
      final Cell cell = _grid[y][x];
      if (cell.char.isEmpty) continue;
      if (cell == _previousGrid[y][x]) continue;

      final result = _writeChangedCell(
        x,
        y,
        cell,
        buffer,
        cursorX: cursorX,
        cursorY: cursorY,
        currentStyle: currentStyle,
      );
      cursorX = result.$1;
      cursorY = result.$2;
      currentStyle = result.$3;
    }
    return (cursorX, cursorY, currentStyle);
  }

  (int, int, TextStyle?) _writeChangedCell(
    int x,
    int y,
    Cell cell,
    StringBuffer buffer, {
    required int cursorX,
    required int cursorY,
    required TextStyle? currentStyle,
  }) {
    if (x != cursorX || y != cursorY) {
      buffer.write('\x1b[${y + 1};${x + 1}H');
    }

    final TextStyle? newStyle = cell.style;
    if (newStyle != currentStyle) {
      currentStyle = newStyle;
      buffer.write(_getCachedAnsiEscapeCode(currentStyle));
    }

    buffer.write(cell.char);
    final int newCursorX = x + charWidth(cell.char.codeUnitAt(0));

    _previousGrid[y][x] = cell;
    _previousGridPopulated = true;
    if (newCursorX - x == 2 && x + 1 < terminal.width) {
      _previousGrid[y][x + 1] = _grid[y][x + 1];
    }

    return (newCursorX, y, currentStyle);
  }
}
