import 'dart:async';
import 'dart:io';

import 'package:radartui/model/key.dart';

class Input {
  Input._();
  static final Input instance = Input._();

  final StreamController<Key> _controller = StreamController<Key>.broadcast();
  bool _isInit = false;

  void init() {
    if (_isInit) return;
    _isInit = true;
    try {
      stdin
        ..echoMode = false
        ..lineMode = false;
    } catch (e) {
      // Handle non-interactive environments
    }
    stdin.listen((List<int> bytes) async {
      final iterator = bytes.iterator;
      while (iterator.moveNext()) {
        final key = _decode(iterator);
        if (key != null) _controller.add(key);
      }
    });
  }

  Stream<Key> get stream => _controller.stream;

  Key? readSync() {
    final List<int> buffer = [stdin.readByteSync()];
    if (buffer.first == 27 && stdin.hasTerminal) {
      // Escape sequence 예상되면 더 읽기
      while (stdin.hasTerminal) {
        buffer.add(stdin.readByteSync());
      }
    }
    return _decode(buffer.iterator);
  }

  Key? _decode(Iterator<int> iter) {
    final first = iter.current;

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
      if (!iter.moveNext()) return Key(KeyType.escape, 'Esc');
      final second = iter.current;

      if (second == 91) {
        if (!iter.moveNext()) return null;
        final third = iter.current;

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
            if (!iter.moveNext()) return null;
            if (iter.current == 126) return Key(KeyType.delete, 'Del');
            break;
          case 53:
            if (!iter.moveNext()) return null;
            if (iter.current == 126) return Key(KeyType.pageUp, 'PgUp');
            break;
          case 54:
            if (!iter.moveNext()) return null;
            if (iter.current == 126) return Key(KeyType.pageDown, 'PgDn');
            break;
        }
      }

      if (second >= 32 && second <= 126) {
        return Key(KeyType.char, String.fromCharCode(second), alt: true);
      }

      return Key(KeyType.escape, 'Esc');
    }

    // 일반 문자
    return Key(KeyType.char, String.fromCharCode(first));
  }
}
