import 'logger.dart';

enum KeyCode {
  unknown,
  arrowUp,
  arrowDown,
  arrowLeft,
  arrowRight,
  enter,
  escape,
  tab,
  backspace,
  delete,
  home,
  end,
  pageUp,
  pageDown,
  f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12,
  // Add more as needed
  char, // For printable characters
}

class KeyEvent {
  final KeyCode code;
  final String? char; // For printable characters
  final bool isShiftPressed;
  final bool isAltPressed;
  final bool isCtrlPressed;
  final bool isMetaPressed; // For Cmd/Windows key

  const KeyEvent({
    required this.code,
    this.char,
    this.isShiftPressed = false,
    this.isAltPressed = false,
    this.isCtrlPressed = false,
    this.isMetaPressed = false,
  });

  @override
  String toString() {
    final modifiers = <String>[];
    if (isCtrlPressed) modifiers.add('Ctrl');
    if (isAltPressed) modifiers.add('Alt');
    if (isShiftPressed) modifiers.add('Shift');
    if (isMetaPressed) modifiers.add('Meta');

    final modifierString = modifiers.isNotEmpty ? '${modifiers.join('+')}+' : '';

    if (code == KeyCode.char) {
      return 'KeyEvent(${modifierString}${char ?? 'null'})';
    }
    return 'KeyEvent(${modifierString}${code.name})';
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

    // Handle common escape sequences (CSI - Control Sequence Introducer)
    // Format: ESC [ <modifier>;<key>A/B/C/D for arrow keys with modifiers
    // Modifiers: 1=Shift, 2=Alt, 4=Ctrl, 8=Meta (often combined, e.g., 3=Shift+Alt)
    if (rawData.length >= 3 && rawData[0] == 27 && rawData[1] == 91) {
      // Check for CSI sequences with modifiers (e.g., ESC [ 1;2A for Shift+Up)
      if (rawData.length >= 4 && rawData[2] >= 48 && rawData[2] <= 57 && rawData[3] == 59) { // Digit;
        final modifierCode = rawData[2] - 48; // Convert char code to int
        if (modifierCode & 1 == 1) isShift = true;
        if (modifierCode & 2 == 2) isAlt = true;
        if (modifierCode & 4 == 4) isCtrl = true;
        if (modifierCode & 8 == 8) isMeta = true;

        // Now parse the actual key after the modifier
        if (rawData.length >= 5) {
          switch (rawData[4]) {
            case 65: // Up arrow
              return KeyEvent(code: KeyCode.arrowUp, isShiftPressed: isShift, isAltPressed: isAlt, isCtrlPressed: isCtrl, isMetaPressed: isMeta);
            case 66: // Down arrow
              return KeyEvent(code: KeyCode.arrowDown, isShiftPressed: isShift, isAltPressed: isAlt, isCtrlPressed: isCtrl, isMetaPressed: isMeta);
            case 67: // Right arrow
              return KeyEvent(code: KeyCode.arrowRight, isShiftPressed: isShift, isAltPressed: isAlt, isCtrlPressed: isCtrl, isMetaPressed: isMeta);
            case 68: // Left arrow
              return KeyEvent(code: KeyCode.arrowLeft, isShiftPressed: isShift, isAltPressed: isAlt, isCtrlPressed: isCtrl, isMetaPressed: isMeta);
          }
        }
      }

      // Basic CSI sequences without explicit modifiers (or where modifier is part of the sequence)
      switch (rawData[2]) {
        case 65: // Up arrow
          return const KeyEvent(code: KeyCode.arrowUp);
        case 66: // Down arrow
          return const KeyEvent(code: KeyCode.arrowDown);
        case 67: // Right arrow
          return const KeyEvent(code: KeyCode.arrowRight);
        case 68: // Left arrow
          return const KeyEvent(code: KeyCode.arrowLeft);
        case 72: // Home
          return const KeyEvent(code: KeyCode.home);
        case 70: // End
          return const KeyEvent(code: KeyCode.end);
        case 90: // Shift+Tab (ESC [ Z)
          return const KeyEvent(code: KeyCode.tab, isShiftPressed: true);
      }
    }

    // Handle other escape sequences (e.g., Delete, PageUp, PageDown, F-keys)
    // Format: ESC [ n ~
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[3] == 126) {
      switch (rawData[2]) {
        case 51: // Delete
          return const KeyEvent(code: KeyCode.delete);
        case 53: // Page Up
          return const KeyEvent(code: KeyCode.pageUp);
        case 54: // Page Down
          return const KeyEvent(code: KeyCode.pageDown);
        // F-keys (common sequences, can vary)
        case 49: // F1 (ESC [ 1 P) - this is a common one, but others are ESC O P/Q/R/S
          if (rawData.length >= 3 && rawData[0] == 27 && rawData[1] == 79) { // ESC O
            switch (rawData[2]) {
              case 80: return const KeyEvent(code: KeyCode.f1);
              case 81: return const KeyEvent(code: KeyCode.f2);
              case 82: return const KeyEvent(code: KeyCode.f3);
              case 83: return const KeyEvent(code: KeyCode.f4);
            }
          }
          // Fallback for F1-F4 if not ESC O P/Q/R/S
          if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91 && rawData[3] == 126) {
            switch (rawData[2]) {
              case 49: return const KeyEvent(code: KeyCode.f1); // ESC [ 1 ~ (sometimes F1)
              case 50: return const KeyEvent(code: KeyCode.f2); // ESC [ 2 ~ (sometimes F2)
              case 55: return const KeyEvent(code: KeyCode.f5); // ESC [ 15 ~ (F5)
              case 56: return const KeyEvent(code: KeyCode.f6); // ESC [ 17 ~ (F6)
              case 57: return const KeyEvent(code: KeyCode.f7); // ESC [ 18 ~ (F7)
              case 48: // ESC [ 20 ~ (F9)
                if (rawData.length >= 5 && rawData[4] == 50) return const KeyEvent(code: KeyCode.f9);
                break;
            }
          }
      }
    }

    // Handle single character special keys
    if (rawData.length == 1) {
      switch (rawData[0]) {
        case 27: // Escape
          return const KeyEvent(code: KeyCode.escape);
        case 9: // Tab
          return const KeyEvent(code: KeyCode.tab);
        case 10: // Enter (LF)
        case 13: // Enter (CR)
          return const KeyEvent(code: KeyCode.enter);
        case 127: // Backspace (DEL)
        case 8: // Backspace (BS)
          return const KeyEvent(code: KeyCode.backspace);
        case 32: // Space
          return const KeyEvent(code: KeyCode.char, char: ' ');
      }
    }

    // Handle Ctrl combinations (Ctrl+A to Ctrl+Z)
    // These are single bytes 1-26
    if (rawData.length == 1 && rawData[0] >= 1 && rawData[0] <= 26) {
      isCtrl = true;
      final charCode = rawData[0] + 64; // Convert to ASCII char code (e.g., 1 -> A, 2 -> B)
      return KeyEvent(code: KeyCode.char, char: String.fromCharCode(charCode), isCtrlPressed: true);
    }

    // Handle Alt combinations (often ESC followed by the key)
    if (rawData.length == 2 && rawData[0] == 27) { // ESC + char
      isAlt = true;
      final char = String.fromCharCode(rawData[1]);
      return KeyEvent(code: KeyCode.char, char: char, isAltPressed: true);
    }

    // Handle regular printable characters
    try {
      final char = String.fromCharCodes(rawData).trim();
      if (char.isNotEmpty) {
        return KeyEvent(code: KeyCode.char, char: char);
      }
    } catch (_) {
      // Fall through to unknown
    }

    // Unknown key
    return const KeyEvent(code: KeyCode.unknown);
  }

}
