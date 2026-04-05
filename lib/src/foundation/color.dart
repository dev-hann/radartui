/// A terminal color using ANSI 16-color palette values (0–15).
///
/// Use [Color.transparent] (-1) to indicate no color.
/// See also [Colors] for named constants.
class Color {
  const Color(this.value);
  final int value;

  // Basic colors
  static const Color black = Color(0);
  static const Color red = Color(1);
  static const Color green = Color(2);
  static const Color yellow = Color(3);
  static const Color blue = Color(4);
  static const Color magenta = Color(5);
  static const Color cyan = Color(6);
  static const Color white = Color(7);

  // Bright colors
  static const Color brightBlack = Color(8);
  static const Color brightRed = Color(9);
  static const Color brightGreen = Color(10);
  static const Color brightYellow = Color(11);
  static const Color brightBlue = Color(12);
  static const Color brightMagenta = Color(13);
  static const Color brightCyan = Color(14);
  static const Color brightWhite = Color(15);

  // Special colors
  static const Color transparent = Color(-1);

  @override
  String toString() => 'Color($value)';
}

/// Predefined [Color] constants following material naming conventions.
///
/// Provides the same ANSI 16-color palette as [Color] plus additional
/// semantic colors like [Colors.black54].
class Colors {
  static const Color black = Color(0);
  static const Color red = Color(1);
  static const Color green = Color(2);
  static const Color yellow = Color(3);
  static const Color blue = Color(4);
  static const Color magenta = Color(5);
  static const Color cyan = Color(6);
  static const Color white = Color(7);

  // Bright colors
  static const Color brightBlack = Color(8);
  static const Color brightRed = Color(9);
  static const Color brightGreen = Color(10);
  static const Color brightYellow = Color(11);
  static const Color brightBlue = Color(12);
  static const Color brightMagenta = Color(13);
  static const Color brightCyan = Color(14);
  static const Color brightWhite = Color(15);

  // Special colors
  static const Color transparent = Color(-1);
  static const Color black54 = Color(16); // Semi-transparent black for barriers
}

enum FontFamily {
  /// System default font
  system,

  /// Monospace font (suitable for code, terminals, etc.)
  monospace,
}

/// Describes the style of terminal text — color, weight, slant, and decorations.
///
/// TextStyles are immutable. Use [merge] to combine two styles, with the
/// other style's non-null properties taking priority.
class TextStyle {
  const TextStyle({
    this.color,
    this.backgroundColor,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.dim = false,
    this.fontFamily = FontFamily.monospace,
  });
  final Color? color;
  final Color? backgroundColor;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool dim;
  final FontFamily fontFamily;

  @override
  bool operator ==(Object other) =>
      other is TextStyle &&
      color == other.color &&
      backgroundColor == other.backgroundColor &&
      bold == other.bold &&
      italic == other.italic &&
      underline == other.underline &&
      dim == other.dim &&
      fontFamily == other.fontFamily;

  @override
  int get hashCode => Object.hash(
        color,
        backgroundColor,
        bold,
        italic,
        underline,
        dim,
        fontFamily,
      );

  TextStyle merge(TextStyle? other) {
    if (other == null) return this;
    return TextStyle(
      color: other.color ?? color,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      bold: other.bold || bold,
      italic: other.italic || italic,
      underline: other.underline || underline,
      dim: other.dim || dim,
      fontFamily: other.fontFamily,
    );
  }

  @override
  String toString() =>
      'TextStyle(color: $color, bg: $backgroundColor, bold: $bold, dim: $dim, font: $fontFamily)';
}
