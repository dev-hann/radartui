import 'dart:io';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/services/logger.dart'; // Added import

class Cell {
  String char;
  Cell(this.char);
  @override bool operator ==(Object other) => other is Cell && char == other.char;
  @override int get hashCode => char.hashCode;
}

class OutputBuffer {
  final Terminal terminal;
  late List<List<Cell>> _grid;
  late List<List<Cell>> _previousGrid;

  OutputBuffer(this.terminal) {
    resize();
  }

  void resize() {
    _grid = List.generate(terminal.height, (_) => List.generate(terminal.width, (_) => Cell(' ')));
    _previousGrid = List.generate(terminal.height, (_) => List.generate(terminal.width, (_) => Cell(' ')));
    AppLogger.log('OutputBuffer resized to ${terminal.width}x${terminal.height}');
  }

  void write(int x, int y, String char) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) {
      AppLogger.log("OutputBuffer.write: Out of bounds ($x, $y) char='$char'");
      return;
    }
    _grid[y][x] = Cell(char);
    AppLogger.log("OutputBuffer.write: ($x, $y) char='$char'");
  }

  void flush() {
    AppLogger.log('OutputBuffer.flush: Starting');
    terminal.hideCursor();
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        if (_grid[y][x] != _previousGrid[y][x]) {
          AppLogger.log("  Diff found at ($x, $y): old='${_previousGrid[y][x].char}', new='${_grid[y][x].char}'");
          terminal.setCursorPosition(x, y);
          stdout.write(_grid[y][x].char); // Corrected: Access .char property
          _previousGrid[y][x] = _grid[y][x];
        }
      }
    }
    terminal.setCursorPosition(0, 0); // Reset cursor to top-left
    terminal.showCursor();
    AppLogger.log('OutputBuffer.flush: Finished');
  }
}