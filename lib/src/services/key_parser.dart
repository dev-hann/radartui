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

    final modifierString = modifiers.isNotEmpty
        ? '${modifiers.join('+')}+'
        : '';

    if (code == KeyCode.char) {
      return 'KeyEvent($modifierString${char ?? 'null'})';
    }
    return 'KeyEvent($modifierString${code.name})';
  }
}

class KeyParser {
  static const List<int> _csi = [27, 91];
  static const List<int> _ss3 = [27, 79];

  static KeyEvent parse(List<int> data) {
    if (data.isEmpty) return const KeyEvent(code: KeyCode.unknown);

    return _parseModifiedArrowKeys(data) ??
        _parseArrowAndNavKeys(data) ??
        _parseSS3FunctionKeys(data) ??
        _parseSpecialKeys(data) ??
        _parseExtendedFunctionKeys(data) ??
        _parseSingleByte(data) ??
        _parseCtrlChar(data) ??
        _parseAltChar(data) ??
        _parseCharFallback(data);
  }

  static KeyEvent? _parseModifiedArrowKeys(List<int> data) {
    if (!_startsWith(data, _csi, 2)) return null;
    if (data.length < 4) return null;
    if (data[2] < 48 || data[2] > 57 || data[3] != 59) return null;

    final bool isShift = (data[2] - 48) & 1 == 1;
    final bool isAlt = (data[2] - 48) & 2 == 2;
    final bool isCtrl = (data[2] - 48) & 4 == 4;
    final bool isMeta = (data[2] - 48) & 8 == 8;

    if (data.length < 5) return null;
    final code = _arrowKeyCode(data[4]);
    if (code == null) return null;

    return KeyEvent(
      code: code,
      isShiftPressed: isShift,
      isAltPressed: isAlt,
      isCtrlPressed: isCtrl,
      isMetaPressed: isMeta,
    );
  }

  static KeyEvent? _parseArrowAndNavKeys(List<int> data) {
    if (!_startsWith(data, _csi, 2)) return null;
    final code = switch (data[2]) {
      65 => KeyCode.arrowUp,
      66 => KeyCode.arrowDown,
      67 => KeyCode.arrowRight,
      68 => KeyCode.arrowLeft,
      72 => KeyCode.home,
      70 => KeyCode.end,
      90 => KeyCode.tab,
      _ => null,
    };
    if (code == KeyCode.tab) {
      return const KeyEvent(code: KeyCode.tab, isShiftPressed: true);
    }
    if (code != null) return KeyEvent(code: code);
    return null;
  }

  static KeyEvent? _parseSS3FunctionKeys(List<int> data) {
    if (!_startsWith(data, _ss3, 2)) return null;
    final code = switch (data[2]) {
      80 => KeyCode.f1,
      81 => KeyCode.f2,
      82 => KeyCode.f3,
      83 => KeyCode.f4,
      _ => null,
    };
    if (code != null) return KeyEvent(code: code);
    return null;
  }

  static KeyEvent? _parseSpecialKeys(List<int> data) {
    if (data.length < 4) return null;
    if (!_startsWith(data, _csi, 2) || data[3] != 126) return null;
    final code = switch (data[2]) {
      50 => KeyCode.insert,
      51 => KeyCode.delete,
      53 => KeyCode.pageUp,
      54 => KeyCode.pageDown,
      49 => KeyCode.home,
      52 => KeyCode.end,
      _ => null,
    };
    if (code != null) return KeyEvent(code: code);
    return null;
  }

  static const Map<String, KeyCode> _fKeyMap = {
    '\x1b[11~': KeyCode.f1,
    '\x1b[12~': KeyCode.f2,
    '\x1b[13~': KeyCode.f3,
    '\x1b[14~': KeyCode.f4,
    '\x1b[15~': KeyCode.f5,
    '\x1b[17~': KeyCode.f6,
    '\x1b[18~': KeyCode.f7,
    '\x1b[19~': KeyCode.f8,
    '\x1b[20~': KeyCode.f9,
    '\x1b[21~': KeyCode.f10,
    '\x1b[23~': KeyCode.f11,
    '\x1b[24~': KeyCode.f12,
  };

  static KeyEvent? _parseExtendedFunctionKeys(List<int> data) {
    final key = String.fromCharCodes(data);
    final code = _fKeyMap[key];
    if (code != null) return KeyEvent(code: code);
    return null;
  }

  static KeyEvent? _parseSingleByte(List<int> data) {
    if (data.length != 1) return null;
    final code = switch (data[0]) {
      27 => KeyCode.escape,
      9 => KeyCode.tab,
      10 || 13 => KeyCode.enter,
      127 || 8 => KeyCode.backspace,
      32 => KeyCode.space,
      _ => null,
    };
    if (code != null) return KeyEvent(code: code);
    return null;
  }

  static KeyEvent? _parseCtrlChar(List<int> data) {
    if (data.length != 1 || data[0] < 1 || data[0] > 26) return null;
    return KeyEvent(
      code: KeyCode.char,
      char: String.fromCharCode(data[0] + 64),
      isCtrlPressed: true,
    );
  }

  static KeyEvent? _parseAltChar(List<int> data) {
    if (data.length != 2 || data[0] != 27) return null;
    return KeyEvent(
      code: KeyCode.char,
      char: String.fromCharCode(data[1]),
      isAltPressed: true,
    );
  }

  static KeyEvent _parseCharFallback(List<int> data) {
    try {
      final char = String.fromCharCodes(data).trim();
      if (char.isNotEmpty) return KeyEvent(code: KeyCode.char, char: char);
    } on FormatException catch (e) {
      AppLogger.log('KeyParser: Invalid character encoding - $e');
    } on Exception catch (e) {
      AppLogger.log('KeyParser: Unexpected error parsing input - $e');
    }
    return const KeyEvent(code: KeyCode.unknown);
  }

  static KeyCode? _arrowKeyCode(int byte) => switch (byte) {
    65 => KeyCode.arrowUp,
    66 => KeyCode.arrowDown,
    67 => KeyCode.arrowRight,
    68 => KeyCode.arrowLeft,
    _ => null,
  };

  static bool _startsWith(List<int> data, List<int> prefix, int minLen) {
    if (data.length < minLen) return false;
    for (int i = 0; i < prefix.length; i++) {
      if (data[i] != prefix[i]) return false;
    }
    return true;
  }
}
