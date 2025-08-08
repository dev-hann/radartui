import 'dart:io';

class Terminal {
  int get width {
    try {
      return stdout.terminalColumns;
    } on StdoutException {
      return 80;
    }
  }

  int get height {
    try {
      return stdout.terminalLines;
    } on StdoutException {
      return 24;
    }
  }

  void setCursorPosition(int x, int y) =>
      stdout.write('\x1b[${y + 1};${x + 1}H');
  void hideCursor() => stdout.write('\x1b[?25l');
  void showCursor() => stdout.write('\x1b[?25h');
  void clear() => stdout.write('\x1b[2J\x1b[H');
  void reset() => stdout.write('\x1b[0m');
}
