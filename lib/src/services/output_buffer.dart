import 'dart:io';
import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/services/logger.dart';

class Cell {
  String char;
  TextStyle? style;
  Cell(this.char, [this.style]);
  
  @override 
  bool operator ==(Object other) => 
    other is Cell && char == other.char && style?.toString() == other.style?.toString();
  
  @override 
  int get hashCode => char.hashCode ^ (style?.toString().hashCode ?? 0);
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
    writeStyled(x, y, char, null);
  }

  void writeStyled(int x, int y, String char, TextStyle? style) {
    if (y >= terminal.height || x >= terminal.width || x < 0 || y < 0) {
      AppLogger.log("OutputBuffer.writeStyled: Out of bounds ($x, $y) char='$char'");
      return;
    }
    _grid[y][x] = Cell(char, style);
    AppLogger.log("OutputBuffer.writeStyled: ($x, $y) char='$char' style=$style");
  }

  void clear() {
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        _grid[y][x] = Cell(' ');
      }
    }
    AppLogger.log('OutputBuffer cleared');
  }

  String _buildAnsiEscapeCode(TextStyle? style) {
    if (style == null) return '\x1b[0m'; // Reset
    
    List<String> codes = [];
    
    if (style.bold) codes.add('1');
    if (style.italic) codes.add('3');
    if (style.underline) codes.add('4');
    
    if (style.color != null) {
      codes.add('3${style.color!.value}');
    }
    
    if (style.backgroundColor != null) {
      codes.add('4${style.backgroundColor!.value}');
    }
    
    return codes.isEmpty ? '\x1b[0m' : '\x1b[${codes.join(';')}m';
  }

  void flush() {
    AppLogger.log('OutputBuffer.flush: Starting');
    terminal.hideCursor();
    TextStyle? currentStyle;
    
    for (var y = 0; y < terminal.height; y++) {
      for (var x = 0; x < terminal.width; x++) {
        if (_grid[y][x] != _previousGrid[y][x]) {
          AppLogger.log("  Diff found at ($x, $y): old='${_previousGrid[y][x].char}', new='${_grid[y][x].char}'");
          terminal.setCursorPosition(x, y);
          
          // Apply style if different from current
          if (_grid[y][x].style != currentStyle) {
            currentStyle = _grid[y][x].style;
            stdout.write(_buildAnsiEscapeCode(currentStyle));
          }
          
          stdout.write(_grid[y][x].char);
          _previousGrid[y][x] = _grid[y][x];
        }
      }
    }
    
    // Reset style at the end
    stdout.write('\x1b[0m');
    terminal.setCursorPosition(0, 0);
    terminal.showCursor();
    AppLogger.log('OutputBuffer.flush: Finished');
  }
}