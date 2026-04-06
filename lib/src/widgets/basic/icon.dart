import '../../../radartui.dart';

/// Displays a single Unicode character (glyph) with optional color styling.
///
/// Use for rendering box-drawing characters, icons, or other single-character
/// symbols in the terminal.
class Icon extends StatelessWidget {
  /// Creates an [Icon] displaying [icon] with an optional [color].
  const Icon({super.key, required this.icon, this.color});

  /// The glyph character to display.
  final String icon;

  /// The color of the icon glyph.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      icon,
      style: color == null ? const TextStyle() : TextStyle(color: color),
    );
  }
}

/// Common icon glyphs for use with [Icon] or [Text].
class Icons {
  /// An upward arrow glyph.
  static const String arrowUp = '↑';

  /// A downward arrow glyph.
  static const String arrowDown = '↓';

  /// A leftward arrow glyph.
  static const String arrowLeft = '←';

  /// A rightward arrow glyph.
  static const String arrowRight = '→';

  /// A check mark glyph.
  static const String check = '✓';

  /// A cross mark glyph.
  static const String cross = '✗';

  /// A plus sign glyph.
  static const String plus = '+';

  /// A minus sign glyph.
  static const String minus = '-';

  /// A folder icon glyph.
  static const String folder = '📁';

  /// A file icon glyph.
  static const String file = '📄';

  /// A menu/hamburger icon glyph.
  static const String menu = '☰';

  /// A search/magnifier icon glyph.
  static const String search = '🔍';

  /// A settings/gear icon glyph.
  static const String settings = '⚙';

  /// An info icon glyph.
  static const String info = 'ℹ';

  /// A warning icon glyph.
  static const String warning = '⚠';

  /// An error icon glyph.
  static const String error = '✕';

  /// ASCII fallback for upward arrow.
  static const String arrowUpAscii = '^';

  /// ASCII fallback for downward arrow.
  static const String arrowDownAscii = 'v';

  /// ASCII fallback for leftward arrow.
  static const String arrowLeftAscii = '<';

  /// ASCII fallback for rightward arrow.
  static const String arrowRightAscii = '>';

  /// ASCII fallback for check mark.
  static const String checkAscii = '*';

  /// ASCII fallback for cross mark.
  static const String crossAscii = 'x';
}
