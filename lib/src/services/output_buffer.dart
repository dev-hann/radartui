import 'dart:io';
import 'package:radartui/src/services/terminal.dart';

class Cell {
  String char;
  Cell(this.char);
  @override bool operator ==(Object other) => other is Cell && char == other.char;
  @override int get hashCode => char.hashCode;
}

class OutputBuffer {
  final Terminal terminal;
  late List<List<String>> _grid;
  late List<List<String>> _previousGrid;

  OutputBuffer(this.terminal) {
    resize();
  }

  void resize() {
    _grid = List.generate(terminal.height, (_) => List.generate(terminal.width, (_) => ' '));
    _previousGrid = List.generate(terminal.height, (_) => List.generate(terminal.width, (_) => ' '));
  }

  void write(int x, int y, String char) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) return;
    _grid[y][x] = char;
  }

  void flush() {
    terminal.hideCursor();
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        if (_grid[y][x] != _previousGrid[y][x]) {
          terminal.setCursorPosition(x, y);
          stdout.write(_grid[y][x]);
          _previousGrid[y][x] = _grid[y][x];
        }
      }
    }
    terminal.setCursorPosition(0, 0); // Reset cursor to top-left
    terminal.showCursor();
  }
}
