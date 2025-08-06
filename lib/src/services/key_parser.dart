class KeyEvent {
  final String key;
  final bool isSpecial;
  final String? specialType;
  
  const KeyEvent(this.key, {this.isSpecial = false, this.specialType});
  
  @override
  String toString() => 'KeyEvent($key, special: $isSpecial, type: $specialType)';
}

class KeyParser {
  static KeyEvent parse(List<int> rawData) {
    if (rawData.isEmpty) {
      return KeyEvent('');
    }
    
    // Handle special keys (escape sequences)
    if (rawData.length >= 3 && rawData[0] == 27 && rawData[1] == 91) { // ESC [
      switch (rawData[2]) {
        case 65: // Up arrow
          return KeyEvent('ArrowUp', isSpecial: true, specialType: 'arrow');
        case 66: // Down arrow
          return KeyEvent('ArrowDown', isSpecial: true, specialType: 'arrow');
        case 67: // Right arrow
          return KeyEvent('ArrowRight', isSpecial: true, specialType: 'arrow');
        case 68: // Left arrow
          return KeyEvent('ArrowLeft', isSpecial: true, specialType: 'arrow');
        case 72: // Home
          return KeyEvent('Home', isSpecial: true, specialType: 'navigation');
        case 70: // End
          return KeyEvent('End', isSpecial: true, specialType: 'navigation');
      }
    }
    
    // Handle other escape sequences
    if (rawData.length >= 4 && rawData[0] == 27 && rawData[1] == 91) {
      if (rawData[3] == 126) { // ESC [ n ~
        switch (rawData[2]) {
          case 51: // Delete
            return KeyEvent('Delete', isSpecial: true, specialType: 'edit');
          case 53: // Page Up
            return KeyEvent('PageUp', isSpecial: true, specialType: 'navigation');
          case 54: // Page Down
            return KeyEvent('PageDown', isSpecial: true, specialType: 'navigation');
        }
      }
    }
    
    // Handle single character special keys
    if (rawData.length == 1) {
      switch (rawData[0]) {
        case 27: // Escape
          return KeyEvent('Escape', isSpecial: true, specialType: 'control');
        case 9: // Tab
          return KeyEvent('Tab', isSpecial: true, specialType: 'control');
        case 10: // Enter (LF)
        case 13: // Enter (CR)
          return KeyEvent('Enter', isSpecial: true, specialType: 'control');
        case 127: // Backspace (DEL)
        case 8: // Backspace (BS)
          return KeyEvent('Backspace', isSpecial: true, specialType: 'edit');
        case 32: // Space
          return KeyEvent('Space', isSpecial: true, specialType: 'printable');
      }
    }
    
    // Handle Ctrl combinations
    if (rawData.length == 1 && rawData[0] < 32) {
      final ctrlChar = String.fromCharCode(rawData[0] + 64);
      return KeyEvent('Ctrl+$ctrlChar', isSpecial: true, specialType: 'control');
    }
    
    // Handle regular printable characters
    try {
      final char = String.fromCharCodes(rawData).trim();
      if (char.isNotEmpty) {
        return KeyEvent(char, isSpecial: false);
      }
    } catch (_) {
      // Fall through to unknown
    }
    
    // Unknown key
    return KeyEvent(
      'Unknown(${rawData.map((e) => e.toRadixString(16)).join(' ')})', 
      isSpecial: true, 
      specialType: 'unknown'
    );
  }
  
  static bool isDigit(String key) {
    return !key.isEmpty && '0123456789'.contains(key);
  }
  
  static bool isLetter(String key) {
    return !key.isEmpty && RegExp(r'[a-zA-Z]').hasMatch(key);
  }
  
  static bool isAlphaNumeric(String key) {
    return isDigit(key) || isLetter(key);
  }
}