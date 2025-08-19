import 'dart:io';
import '../foundation/color.dart';
import '../services/terminal.dart';

class Cell {
  String char;
  TextStyle? style;
  Cell(this.char, [this.style]);

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
  final Terminal terminal;
  late List<List<Cell>> _grid;
  late List<List<Cell>> _previousGrid;

  OutputBuffer(this.terminal) {
    resize();
  }

  void resize() {
    _grid = List.generate(
      terminal.height,
      (_) => List.generate(terminal.width, (_) => Cell(' ')),
    );
    _previousGrid = List.generate(
      terminal.height,
      (_) => List.generate(terminal.width, (_) => Cell(' ')),
    );
  }

  void write(int x, int y, String char) {
    writeStyled(x, y, char, null);
  }

  void writeStyled(int x, int y, String char, TextStyle? style) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) {
      return;
    }
    _grid[y][x] = Cell(char, style);
  }

  void clear() {
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell(' ', null); // Clear with null style
      }
    }
  }

  void clearAll() {
    // Clear the terminal completely
    terminal.clear();

    // Clear both current and previous grids to force complete redraw
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell(' ', null); // Clear with null style
        _previousGrid[y][x] = Cell(
          '',
          null,
        ); // Make different from current to force redraw
      }
    }
  }

  void smartClear() {
    // Clear only the grid, preserve previous grid for diff-based rendering
    // This avoids terminal flicker while ensuring clean content
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell(' ', null); // Clear with null style
      }
    }
  }

  bool needsFullClear() {
    // Check if current content footprint is smaller than previous
    // This indicates we might need to clear remnants
    int currentContent = 0;
    int previousContent = 0;

    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
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
      // Complete reset to clear all previous styles
      return '\x1b[0m';
    }

    // Always start with reset to ensure clean style application
    List<String> codes = ['0'];

    // Apply new styles
    if (style.bold) codes.add('1');
    if (style.italic) codes.add('3');
    if (style.underline) codes.add('4');

    if (style.color != null) {
      codes.add('3${style.color!.value}');
    }

    if (style.backgroundColor != null) {
      codes.add('4${style.backgroundColor!.value}');
    }

    return '\x1b[${codes.join(';')}m';
  }

  void flush() {
    terminal.hideCursor();
    TextStyle? currentStyle;

    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        if (_grid[y][x] != _previousGrid[y][x]) {
          terminal.setCursorPosition(x, y);

          // Always apply style to ensure proper overrides
          // This ensures that style changes are properly rendered
          final newStyle = _grid[y][x].style;
          if (newStyle != currentStyle) {
            currentStyle = newStyle;
            stdout.write(_buildAnsiEscapeCode(currentStyle));
          }

          stdout.write(_grid[y][x].char);
          _previousGrid[y][x] = _grid[y][x];
        }
      }
    }

    // Reset style at the end to ensure clean state
    stdout.write('\x1b[0m');
    terminal.setCursorPosition(0, 0);
    terminal.showCursor();
  }
}
