import 'dart:io';
import '../foundation.dart';
import 'terminal_backend.dart';

class RealTerminalBackend implements TerminalBackend {
  @override
  int get width {
    try {
      return stdout.terminalColumns;
    } on StdoutException {
      return LayoutConstants.defaultTerminalWidth;
    }
  }

  @override
  int get height {
    try {
      return stdout.terminalLines;
    } on StdoutException {
      return LayoutConstants.defaultTerminalHeight;
    }
  }

  @override
  void write(String data) {
    stdout.write(data);
  }

  @override
  void setCursorPosition(int x, int y) {
    stdout.write('\x1b[${y + 1};${x + 1}H');
  }

  @override
  void hideCursor() {
    stdout.write('\x1b[?25l');
  }

  @override
  void showCursor() {
    stdout.write('\x1b[?25h');
  }

  @override
  void clear() {
    stdout.write('\x1b[2J\x1b[H');
  }
}
