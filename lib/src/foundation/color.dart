/// A terminal color using ANSI 16-color palette values (0–15).
///
/// Use [Color.transparent] (-1) to indicate no color.
/// See also [Colors] for named constants.
class Color {
  /// Creates a [Color] with the given ANSI [value].
  const Color(this.value);

  /// The ANSI color value (0–15), or -1 for transparent.
  final int value;

  /// Black (ANSI 0).
  static const Color black = Color(0);

  /// Red (ANSI 1).
  static const Color red = Color(1);

  /// Green (ANSI 2).
  static const Color green = Color(2);

  /// Yellow (ANSI 3).
  static const Color yellow = Color(3);

  /// Blue (ANSI 4).
  static const Color blue = Color(4);

  /// Magenta (ANSI 5).
  static const Color magenta = Color(5);

  /// Cyan (ANSI 6).
  static const Color cyan = Color(6);

  /// White (ANSI 7).
  static const Color white = Color(7);

  /// Bright black / dark gray (ANSI 8).
  static const Color brightBlack = Color(8);

  /// Bright red (ANSI 9).
  static const Color brightRed = Color(9);

  /// Bright green (ANSI 10).
  static const Color brightGreen = Color(10);

  /// Bright yellow (ANSI 11).
  static const Color brightYellow = Color(11);

  /// Bright blue (ANSI 12).
  static const Color brightBlue = Color(12);

  /// Bright magenta (ANSI 13).
  static const Color brightMagenta = Color(13);

  /// Bright cyan (ANSI 14).
  static const Color brightCyan = Color(14);

  /// Bright white (ANSI 15).
  static const Color brightWhite = Color(15);

  /// No color (value -1).
  static const Color transparent = Color(-1);

  @override
  String toString() => 'Color($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Color && value == other.value;
  }

  @override
  int get hashCode => value;
}

/// Predefined [Color] constants following material naming conventions.
///
/// Provides same ANSI 16-color palette as [Color].
class Colors {
  /// Black (ANSI 0).
  static const Color black = Color(0);

  /// Red (ANSI 1).
  static const Color red = Color(1);

  /// Green (ANSI 2).
  static const Color green = Color(2);

  /// Yellow (ANSI 3).
  static const Color yellow = Color(3);

  /// Blue (ANSI 4).
  static const Color blue = Color(4);

  /// Magenta (ANSI 5).
  static const Color magenta = Color(5);

  /// Cyan (ANSI 6).
  static const Color cyan = Color(6);

  /// White (ANSI 7).
  static const Color white = Color(7);

  /// Bright black / dark gray (ANSI 8).
  static const Color brightBlack = Color(8);

  /// Bright red (ANSI 9).
  static const Color brightRed = Color(9);

  /// Bright green (ANSI 10).
  static const Color brightGreen = Color(10);

  /// Bright yellow (ANSI 11).
  static const Color brightYellow = Color(11);

  /// Bright blue (ANSI 12).
  static const Color brightBlue = Color(12);

  /// Bright magenta (ANSI 13).
  static const Color brightMagenta = Color(13);

  /// Bright cyan (ANSI 14).
  static const Color brightCyan = Color(14);

  /// Bright white (ANSI 15).
  static const Color brightWhite = Color(15);

  /// No color.
  static const Color transparent = Color(-1);
}

/// Font family options for terminal text rendering.
enum FontFamily {
  /// System default font.
  system,

  /// Monospace font (suitable for code, terminals, etc.).
  monospace,
}

/// Describes the style of terminal text — color, weight, slant, and decorations.
///
/// TextStyles are immutable. Use [merge] to combine two styles, with the
/// other style's non-null properties taking priority.
class TextStyle {
  /// Creates a [TextStyle] with the given properties.
  const TextStyle({
    this.color,
    this.backgroundColor,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.dim = false,
    this.fontFamily = FontFamily.monospace,
  });

  /// The foreground color of the text.
  final Color? color;

  /// The background color behind the text.
  final Color? backgroundColor;

  /// Whether the text is rendered in bold weight.
  final bool bold;

  /// Whether the text is rendered in italic slant.
  final bool italic;

  /// Whether the text is rendered with an underline decoration.
  final bool underline;

  /// Whether the text is rendered in dim/faint mode.
  final bool dim;

  /// The font family used to render the text.
  final FontFamily fontFamily;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextStyle &&
        color == other.color &&
        backgroundColor == other.backgroundColor &&
        bold == other.bold &&
        italic == other.italic &&
        underline == other.underline &&
        dim == other.dim &&
        fontFamily == other.fontFamily;
  }

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

  /// Returns a new [TextStyle] that merges this style with [other].
  ///
  /// Non-null properties from [other] take priority over this style's values.
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
