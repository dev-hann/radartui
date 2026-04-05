import 'terminal_backend.dart';

/// Abstract interface for terminal operations such as writing and cursor control.
abstract class Terminal {
  /// The number of columns in the terminal.
  int get width;

  /// The number of rows in the terminal.
  int get height;

  /// Clears the terminal screen.
  void clear();

  /// Hides the terminal cursor.
  void hideCursor();

  /// Shows the terminal cursor.
  void showCursor();

  /// Moves the cursor to the given [x] (column) and [y] (row) position.
  void setCursorPosition(int x, int y);

  /// Resets the terminal to its default state.
  void reset();

  /// The backend used for low-level terminal I/O.
  TerminalBackend get backend;

  /// Writes raw [data] to the terminal.
  void write(String data);
}
