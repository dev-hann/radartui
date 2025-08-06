import 'dart:io';

import 'package:radartui/canvas/size.dart';
import 'package:radartui/canvas/style.dart';

class Canvas {
  Canvas._();
  static final Canvas instance = Canvas._();

  Size get windowSize {
    try {
      final height = stdout.terminalLines;
      final width = stdout.terminalColumns;
      return Size(width, height);
    } catch (e) {
      // Return default size for non-interactive environments
      return Size(80, 24);
    }
  }

  void init() {
    try {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } catch (e) {
      // Handle non-interactive environments (like CI/testing)
      // where terminal mode cannot be set
    }
    clear();
    hideCursor();
  }

  void dispose() {
    try {
      stdin.echoMode = true;
      stdin.lineMode = true;
    } catch (e) {
      // Handle non-interactive environments
    }
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
