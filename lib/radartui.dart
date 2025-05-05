import 'dart:io';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/logger/file_logger.dart';
import 'package:radartui/logger/logger.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

export 'canvas/canvas.dart';
export 'canvas/rect.dart';
export 'widget/widget.dart';
export 'logger/logger.dart';

class Radartui {
  static final canvas = Canvas();

  static Future runApp(
    Widget app, {
    required Function(Key key) onKey,
    Logger? logger,
  }) async {
    logger ??= FileLogger();
    await logger.run(
      callback: () {
        canvas.init();
        app.onMount();
        while (true) {
          canvas.clear();
          app.render(
            canvas,
            Rect(
              x: 0,
              y: 0,
              width: canvas.windowSize.width,
              height: canvas.windowSize.height,
            ),
          );
          final key = readKeySync();
          print(key);
          onKey(key);
        }
      },
    );
  }

  static void exitApp() {
    canvas.dispose();
    exit(0);
  }

  static Key readKeySync() {
    final input = stdin;
    final first = input.readByteSync();
    print(first);

    // Enter
    if (first == 10 || first == 13) return Key(KeyType.enter, '\n');

    // Tab
    if (first == 9) return Key(KeyType.tab, '\t');

    // Backspace
    if (first == 127) return Key(KeyType.backspace, '\b');

    // Ctrl+C / Ctrl+D
    if (first == 3) return Key(KeyType.ctrlC, '^C', ctrl: true);
    if (first == 4) return Key(KeyType.ctrlD, '^D', ctrl: true);

    // Ctrl+A ~ Ctrl+Z
    if (first >= 1 && first <= 26) {
      final label = String.fromCharCode(first + 96);
      return Key(KeyType.char, label, ctrl: true);
    }

    // Escape (ESC)
    if (first == 27) {
      // Try to read second byte (non-blocking check)
      if (!stdin.hasTerminal) {
        return Key(KeyType.escape, 'Esc');
      }

      // Wait for the next byte(s)
      final second = input.readByteSync();
      if (second == 91) {
        final third = input.readByteSync();
        switch (third) {
          case 65:
            return Key(KeyType.up, '↑');
          case 66:
            return Key(KeyType.down, '↓');
          case 67:
            return Key(KeyType.right, '→');
          case 68:
            return Key(KeyType.left, '←');
          case 72:
            return Key(KeyType.home, 'Home');
          case 70:
            return Key(KeyType.end, 'End');
          case 51:
            final fourth = input.readByteSync(); // ~ expected
            if (fourth == 126) return Key(KeyType.delete, 'Del');
            break;
          case 53:
            final fourth = input.readByteSync(); // ~ expected
            if (fourth == 126) return Key(KeyType.pageUp, 'PgUp');
            break;
          case 54:
            final fourth = input.readByteSync(); // ~ expected
            if (fourth == 126) return Key(KeyType.pageDown, 'PgDn');
            break;
        }
      }

      // Alt + char
      if (second >= 32 && second <= 126) {
        final label = String.fromCharCode(second);
        return Key(KeyType.char, label, alt: true);
      }

      return Key(KeyType.escape, 'Esc');
    }

    // 일반 문자
    return Key(KeyType.char, String.fromCharCode(first));
  }
}
