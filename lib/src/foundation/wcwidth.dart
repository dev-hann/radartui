/// Returns the display width (number of terminal columns) of a single [codePoint].
///
/// Wide characters (e.g. CJK, emoji) return 2; control characters return 0.
int charWidth(int codePoint) {
  if (codePoint < 32) return 0;
  if (codePoint < 127) return 1;
  if (codePoint < 0xA0) return 0;

  if (_isWide(codePoint)) return 2;

  return 1;
}

/// Returns the total display width of [text] in terminal columns.
int stringWidth(String text) {
  int width = 0;
  for (int i = 0; i < text.length; i++) {
    final int cp = text.codeUnitAt(i);
    if (cp < 32) continue;
    if (cp < 127) {
      width++;
      continue;
    }
    width += charWidth(cp);
  }
  return width;
}

bool _isWide(int cp) {
  if (cp >= 0x1100 &&
      (cp <= 0x115F ||
          cp == 0x2329 ||
          cp == 0x232A ||
          (cp >= 0x2E80 && cp <= 0x303E && cp != 0x303F) ||
          (cp >= 0x3041 && cp <= 0x3247) ||
          (cp >= 0x3250 && cp <= 0x4DBF) ||
          (cp >= 0x4E00 && cp <= 0xA4C6) ||
          (cp >= 0xA960 && cp <= 0xA97C) ||
          (cp >= 0xAC00 && cp <= 0xD7A3) ||
          (cp >= 0xF900 && cp <= 0xFAFF) ||
          (cp >= 0xFE10 && cp <= 0xFE19) ||
          (cp >= 0xFE30 && cp <= 0xFE6B) ||
          (cp >= 0xFF01 && cp <= 0xFF60) ||
          (cp >= 0xFFE0 && cp <= 0xFFE6) ||
          (cp >= 0x16FE0 && cp <= 0x1B2FB) ||
          (cp >= 0x1F200 && cp <= 0x1F251) ||
          (cp >= 0x1F300 && cp <= 0x1F64F) ||
          (cp >= 0x1F680 && cp <= 0x1F6FF) ||
          (cp >= 0x1F900 && cp <= 0x1FAFF) ||
          (cp >= 0x20000 && cp <= 0x3FFFD))) {
    return true;
  }
  return false;
}
