
import 'package:radartui/src/foundation/color.dart';

/// A utility for creating ANSI escape codes for styling text.
class AnsiStyler {
  /// Generates the ANSI code for setting the foreground color.
  static String foreground(Color color) {
    // TODO: Implement ANSI color code generation.
    return '\x1b[38;5;${color.value}m';
  }

  /// Generates the ANSI code for setting the background color.
  static String background(Color color) {
    // TODO: Implement ANSI color code generation.
    return '\x1b[48;5;${color.value}m';
  }

  /// Generates the ANSI code for resetting all styles.
  static String reset() {
    // TODO: Implement ANSI reset code.
    return '\x1b[0m';
  }

  // TODO: Add methods for other styles like bold, italic, underline.
}
