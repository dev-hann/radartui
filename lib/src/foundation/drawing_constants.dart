/// Box-drawing constants for terminal UI rendering.
///
/// Provides single-character constants for Unicode box-drawing characters
/// used across the codebase.
class BoxDrawingConstants {
  BoxDrawingConstants._();

  /// Horizontal line
  static const String horizontal = '─';

  /// Vertical line
  static const String vertical = '│';

  /// Top-left corner
  static const String topLeft = '┌';

  /// Top-right corner
  static const String topRight = '┐';

  /// Bottom-left corner
  static const String bottomLeft = '└';

  /// Bottom-right corner
  static const String bottomRight = '┘';

  /// Cross intersection
  static const String cross = '┼';

  /// Top T-intersection
  static const String topTee = '┬';

  /// Bottom T-intersection
  static const String bottomTee = '┴';

  /// Left T-intersection
  static const String leftTee = '├';

  /// Right T-intersection
  static const String rightTee = '┤';

  /// Full block cursor
  static const String fullBlockCursor = '█';

  /// Up arrow
  static const String arrowUp = '▲';

  /// Down arrow
  static const String arrowDown = '▼';

  /// Checkmark prefix for selected items
  static const String checkmark = '>';

  /// Space prefix for unselected items (two spaces)
  static const String spacePrefix = '  ';

  /// Ellipsis for text overflow
  static const String ellipsis = '...';
}

/// Spacing constants for terminal UI.
///
/// Provides standard spacing values used across the codebase.
class SpacingConstants {
  SpacingConstants._();

  /// Single cell spacing
  static const int singleCell = 1;

  /// Double cell spacing
  static const int doubleCell = 2;

  /// Border width in cells
  static const int borderWidth = 1;
}

/// Text constants for rendering.
///
/// Provides text-related constants used across the codebase.
class TextConstants {
  TextConstants._();

  /// Length of ellipsis for text overflow
  static const int ellipsisLength = 3;

  /// Minimum line height
  static const int minLineHeight = 1;
}
