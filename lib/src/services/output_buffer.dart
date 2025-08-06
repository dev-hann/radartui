
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/services/terminal.dart';

/// Represents a single cell on the terminal screen.
class Cell {
  String character;
  // TODO: Add style properties (foreground, background, bold, etc.)

  Cell(this.character);

  // TODO: Implement a method to generate the full ANSI string for this cell.
}

/// A 2D buffer that represents the state of the terminal screen.
///
/// This is a critical component for performance. Drawing operations write to this
/// buffer in memory. The `flush` method then intelligently compares this buffer
/// to the previous state of the screen and sends a minimal set of commands
/// to the terminal to update only the parts that have changed.
class OutputBuffer {
  final Terminal _terminal;
  late List<List<Cell>> _grid;
  late List<List<Cell>> _previousGrid;

  OutputBuffer(this._terminal) {
    // TODO: Initialize the grid with the terminal size.
  }

  /// Resizes the buffer if the terminal size has changed.
  void resize(Size newSize) {
    // TODO: Implement resizing logic, preserving content where possible.
  }

  /// Writes a character to a specific position in the buffer.
  void write(int x, int y, String char /*, Style style */) {
    // TODO: Implement writing to the _grid.
  }

  /// Flushes the changes from the buffer to the actual terminal.
  void flush() {
    // TODO: Implement the core diffing logic.
    // 1. Iterate through the _grid.
    // 2. Compare each cell with the corresponding cell in _previousGrid.
    // 3. If different, move the cursor to that position and print the new cell's content.
    // 4. After flushing, copy _grid to _previousGrid.
  }
}
