import 'logger.dart';

enum KeyCode {
  unknown,
  arrowUp,
  arrowDown,
  arrowLeft,
  arrowRight,
  enter,
  space,
  escape,
  tab,
  backspace,
  delete,
  home,
  end,
  pageUp,
  pageDown,
  insert,
  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  f10,
  f11,
  f12,
  char,
}

class KeyEvent {

  const KeyEvent({
    required this.code,
    this.char,
    this.isShiftPressed = false,
    this.isAltPressed = false,
    this.isCtrlPressed = false,
    this.isMetaPressed = false,
  });
  final KeyCode code;
  final String? char;
  final bool isShiftPressed;
  final bool isAltPressed;
  final bool isCtrlPressed;
  final bool isMetaPressed;

  @override
  String toString() {
    final modifiers = <String>[];
    if (isCtrlPressed) modifiers.add('Ctrl');
    if (isAltPressed) modifiers.add('Alt');
    if (isShiftPressed) modifiers.add('Shift');
    if (isMetaPressed) modifiers.add('Meta');

    final modifierString = modifiers.isNotEmpty ? '${modifiers.join('+')}+' : '';

    if (code == KeyCode.char) {
      return 'KeyEvent($modifierString${char ?? 'null'})';
    }
    return 'KeyEvent($modifierString${code.name})';
  }
}

class KeyParser {
  static KeyEvent parse(List<int> rawData) {
    if (rawData.isEmpty) {
      return const KeyEvent(code: KeyCode.unknown);
    }

    bool isShift = false;
    bool isAlt = false;
    bool isCtrl = false;
    bool isMeta = false;

    if (rawData.length >= 3 && rawData[0] == 27 && rawData[1] == 91) {
      if (rawData.length >= 4 && rawData[2] >= 48 && rawData[2] <= 57 && rawData[3] == 59) {
        final modifierCode = rawData[2] - 48;
        if (modifierCode & 1 == 1) isShift = true;
        if (modifierCode & 2 == 2) isAlt = true;
        if (modifierCode & 4 == 4) isCtrl = true;
        if (modifierCode & 8 == 8) isMeta = true;

        if (rawData.length >= 5) {
          switch (rawData[4]) {
            case 65:
              return KeyEvent(
                code: KeyCode.arrowUp,
                isShiftPressed: isShift,
                isAltPressed: isAlt,
                isCtrlPressed: isCtrl,
                isMetaPressed: isMeta,
              );
            case 66:
              return KeyEvent(
                code: KeyCode.arrowDown,
                isShiftPressed: isShift,
                isAltPressed: isAlt,
                isCtrlPressed: isCtrl,
                isMetaPressed: isMeta,
              );
            case 67:
              return KeyEvent(
                code: KeyCode.arrowRight,
                isShiftPressed: isShift,
                isAltPressed: isAlt,
                isCtrlPressed: isCtrl,
                isMetaPressed: isMeta,
              );
            case 68:
              return KeyEvent(
                code: KeyCode.arrowLeft,
                isShiftPressed: isShift,
                isAltPressed: isAlt,
                isCtrlPressed: isCtrl,
                isMetaPressed: isMeta,
              );
          }
        }
      }

      switch (rawData[2]) {
        case 65:
          return const KeyEvent(code: KeyCode.arrowUp);
        case 66:
          return const KeyEvent(code: KeyCode.arrowDown);
        case 67:
          return const KeyEvent(code: KeyCode.arrowRight);
        case 68:
          return const KeyEvent(code: KeyCode.arrowLeft);
        case 72:
          return const KeyEvent(code: KeyCode.home);
        case 70:
          return const KeyEvent(code: KeyCode.end);
        case 90:
          return const KeyEvent(code: KeyCode.tab, isShiftPressed: true);
      }
    }

    if (rawData.length >= 3 && rawData[0] == 27 && rawData[1] == 79) {
      switch (rawData[2]) {
        case 80:
          return const KeyEvent(code: KeyCode.f1);
        case 81:
          return const KeyEvent(code: KeyCode.f2);
        case 82:
          return const KeyEvent(code: KeyCode.f3);
        case 83:
          return const KeyEvent(code: KeyCode.f4);
      }
    }

    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[3] == 126) {
      switch (rawData[2]) {
        case 50:
          return const KeyEvent(code: KeyCode.insert);
        case 51:
          return const KeyEvent(code: KeyCode.delete);
        case 53:
          return const KeyEvent(code: KeyCode.pageUp);
        case 54:
          return const KeyEvent(code: KeyCode.pageDown);
        case 49:
          return const KeyEvent(code: KeyCode.home);
        case 52:
          return const KeyEvent(code: KeyCode.end);
      }
    }

    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 126) {
      return const KeyEvent(code: KeyCode.f1);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 50 && rawData[3] == 126) {
      return const KeyEvent(code: KeyCode.f2);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 51 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f3);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 52 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f4);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 53 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f5);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 55 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f6);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 56 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f7);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 49 && rawData[3] == 57 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f8);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 50 && rawData[3] == 48 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f9);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 50 && rawData[3] == 49 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f10);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 50 && rawData[3] == 51 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f11);
    }
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[2] == 50 && rawData[3] == 52 && rawData.length >= 5 && rawData[4] == 126) {
      return const KeyEvent(code: KeyCode.f12);
    }

    if (rawData.length == 1) {
      switch (rawData[0]) {
        case 27:
          return const KeyEvent(code: KeyCode.escape);
        case 9:
          return const KeyEvent(code: KeyCode.tab);
        case 10:
        case 13:
          return const KeyEvent(code: KeyCode.enter);
        case 127:
        case 8:
          return const KeyEvent(code: KeyCode.backspace);
        case 32:
          return const KeyEvent(code: KeyCode.space);
      }
    }

    if (rawData.length == 1 && rawData[0] >= 1 && rawData[0] <= 26) {
      isCtrl = true;
      final charCode = rawData[0] + 64;
      return KeyEvent(
        code: KeyCode.char,
        char: String.fromCharCode(charCode),
        isCtrlPressed: true,
      );
    }

    if (rawData.length == 2 && rawData[0] == 27) {
      isAlt = true;
      final char = String.fromCharCode(rawData[1]);
      return KeyEvent(code: KeyCode.char, char: char, isAltPressed: true);
    }

    try {
      final char = String.fromCharCodes(rawData).trim();
      if (char.isNotEmpty) {
        return KeyEvent(code: KeyCode.char, char: char);
      }
    } on FormatException catch (e) {
      AppLogger.log('KeyParser: Invalid character encoding - $e');
    } on Exception catch (e) {
      AppLogger.log('KeyParser: Unexpected error parsing input - $e');
    }

    return const KeyEvent(code: KeyCode.unknown);
  }
}
