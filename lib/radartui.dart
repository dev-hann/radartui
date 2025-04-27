import 'dart:io';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/logger/logger.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

export 'canvas/canvas.dart';
export 'canvas/rect.dart';
export 'widget/widget.dart';
export 'logger/logger.dart';

class Radartui {
  static final canvas = Canvas();

  static Future runApp(Widget app, {required Function(Key key) onKey}) async {
    await Logger.run(
      callback: () {
        canvas.init();
        app.initState();
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

    final first = stdin.readByteSync();

    // 일반 문자/제어 문자
    if (first == 9) return Key(KeyType.tab, '\t');
    if (first == 10 || first == 13) return Key(KeyType.enter, '\n');
    if (first == 127) return Key(KeyType.backspace, '\b');
    if (first == 3) return Key(KeyType.ctrlC, '^C');
    if (first == 4) return Key(KeyType.ctrlD, '^D');

    // Escape 시퀀스
    if (first == 27) {
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
          case 51:
            final fourth = input.readByteSync(); // should be ~
            if (fourth == 126) return Key(KeyType.delete, 'Del');
            break;
          case 72:
            return Key(KeyType.home, 'Home');
          case 70:
            return Key(KeyType.end, 'End');
          case 53:
            final fourth = input.readByteSync(); // ~
            if (fourth == 126) return Key(KeyType.pageUp, 'PgUp');
            break;
          case 54:
            final fourth = input.readByteSync(); // ~
            if (fourth == 126) return Key(KeyType.pageDown, 'PgDn');
            break;
        }
      }
      return Key(KeyType.escape, 'Esc');
    }

    // 일반 문자 (영어, 숫자 등)
    return Key(KeyType.char, String.fromCharCode(first));
  }
}
