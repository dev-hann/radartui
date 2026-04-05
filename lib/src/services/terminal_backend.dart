/// Abstract interface for low-level terminal I/O operations.
abstract class TerminalBackend {
  /// The number of columns in the terminal.
  int get width;

  /// The number of rows in the terminal.
  int get height;

  /// Writes [data] to the terminal output.
  void write(String data);

  /// Moves the cursor to the given [x] (column) and [y] (row) position.
  void setCursorPosition(int x, int y);

  /// Hides the terminal cursor.
  void hideCursor();

  /// Shows the terminal cursor.
  void showCursor();

  /// Clears the terminal screen.
  void clear();

  /// Flushes any buffered output to the terminal.
  void flush();
}
