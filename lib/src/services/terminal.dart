import 'terminal_backend.dart';

abstract class Terminal {
  int get width;
  int get height;
  void clear();
  void hideCursor();
  void showCursor();
  void setCursorPosition(int x, int y);
  void reset();
  TerminalBackend get backend;
  void write(String data);
}
