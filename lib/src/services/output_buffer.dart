import 'dart:io';
import 'package:radartui/src/services/terminal.dart';

class OutputBuffer {
  final Terminal terminal;
  late List<List<String>> _grid;

  OutputBuffer(this.terminal) {
    _grid = List.generate(terminal.height, (_) => List.generate(terminal.width, (_) => ' '));
  }

  void write(int x, int y, String char) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) return;
    _grid[y][x] = char;
  }

  void flush() {
    final buffer = StringBuffer();
    for (var y = 0; y < terminal.height; y++) {
      buffer.write('\x1b[${y + 1};1H');
      buffer.write(_grid[y].join());
    }
    stdout.write(buffer.toString());
  }
}
