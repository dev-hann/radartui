import 'dart:io';

import 'package:radartui/canvas/size.dart';
import 'package:radartui/canvas/style.dart';

class Canvas {
  Size get windowSize {
    final height = stdout.terminalLines;
    final width = stdout.terminalColumns;
    return Size(width, height);
  }

  void init() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    clear();
    hideCursor();
  }

  void dispose() {
    stdin.echoMode = true;
    stdin.lineMode = true;
    showCursor();
    clear();
  }

  void move(int x, int y) {
    stdout.write('\x1b[${y + 1};${x + 1}H');
  }

  void clear() {
    stdout.write('\x1B[2J');
    move(0, 0);
  }

  void hideCursor() {
    stdout.write('\x1b[?25l');
  }

  void showCursor() {
    stdout.write('\x1b[?25h');
  }

  void setStyle(Style? style) {
    if (style == null) {
      return;
    }
    stdout.write(style.toPrompt());
    final foreground = style.foreground;
    stdout.write("\x1b[3${foreground.value}m");
    final background = style.background;
    stdout.write('\x1b[4${background.value}m');
  }

  void clearStyle() {
    stdout.write('\x1b[0m');
  }

  void _updateStyle(Style style) {
    stdout.write(style.toPrompt());
    final foreground = style.foreground;
    stdout.write("\x1b[3${foreground.value}m");
    final background = style.background;
    stdout.write('\x1b[4${background.value}m');
  }

  void drawChar(String text, {Style? style}) {
    if (style != null) {
      _updateStyle(style);
    }
    stdout.write(text);
    clearStyle();
  }
}
