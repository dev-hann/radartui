import 'dart:io';
import '../foundation.dart';
import 'ffi_write.dart';
import 'terminal_backend.dart';

class RealTerminalBackend implements TerminalBackend {
  RealTerminalBackend() {
    FfiWrite.instance.openTty();
  }

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
    FfiWrite.instance.writeString(data);
  }

  @override
  void setCursorPosition(int x, int y) {
    FfiWrite.instance.writeString('\x1b[${y + 1};${x + 1}H');
  }

  @override
  void hideCursor() {
    FfiWrite.instance.writeString('\x1b[?25l');
  }

  @override
  void showCursor() {
    FfiWrite.instance.writeString('\x1b[?25h');
  }

  @override
  void clear() {
    FfiWrite.instance.writeString('\x1b[2J\x1b[H');
  }

  @override
  void flush() {}

  void dispose() {
    FfiWrite.instance.closeTty();
  }
}
