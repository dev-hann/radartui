import 'dart:io';
import '../foundation/constants.dart';

class Terminal {
  int get width {
    try {
      return stdout.terminalColumns;
    } on StdoutException {
      return LayoutConstants.defaultTerminalWidth;
    }
  }

  int get height {
    try {
      return stdout.terminalLines;
    } on StdoutException {
      return LayoutConstants.defaultTerminalHeight;
    }
  }

  void setCursorPosition(int x, int y) =>
      stdout.write('\x1b[${y + 1};${x + 1}H');
  void hideCursor() => stdout.write('\x1b[?25l');
  void showCursor() => stdout.write('\x1b[?25h');
  void clear() => stdout.write('\x1b[2J\x1b[H');
  void reset() => stdout.write('\x1b[0m');
}
