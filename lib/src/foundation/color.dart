
/// Represents a terminal color using ANSI escape codes.
class Color {
  /// The ANSI color code.
  final int value;

  /// Creates a new Color instance.
  const Color(this.value);

  // --- Pre-defined basic ANSI colors ---
  static const Color black = Color(0);
  static const Color red = Color(1);
  static const Color green = Color(2);
  static const Color yellow = Color(3);
  static const Color blue = Color(4);
  static const Color magenta = Color(5);
  static const Color cyan = Color(6);
  static const Color white = Color(7);
}
