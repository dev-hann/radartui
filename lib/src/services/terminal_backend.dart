abstract class TerminalBackend {
  int get width;
  int get height;
  void write(String data);
  void setCursorPosition(int x, int y);
  void hideCursor();
  void showCursor();
  void clear();
}
