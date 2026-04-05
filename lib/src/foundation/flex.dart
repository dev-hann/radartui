/// How children should be placed along the main axis of a flex layout.
enum MainAxisAlignment {
  /// Place children at the start of the main axis.
  start,

  /// Place children at the end of the main axis.
  end,

  /// Place children at the center of the main axis.
  center,

  /// Place children evenly with no space before the first or after the last.
  spaceBetween,

  /// Place children evenly with equal space before the first and after the last.
  spaceAround,

  /// Place children evenly with equal space between every pair and at the edges.
  spaceEvenly,
}

/// How children should be placed along the cross axis of a flex layout.
enum CrossAxisAlignment {
  /// Place children at the start of the cross axis.
  start,

  /// Place children at the end of the cross axis.
  end,

  /// Place children at the center of the cross axis.
  center,

  /// Stretch children to fill the cross axis.
  stretch,
}

/// How much space a flex layout should occupy along its main axis.
enum MainAxisSize {
  /// Minimize the amount of space along the main axis.
  min,

  /// Maximize the amount of space along the main axis.
  max,
}

/// The vertical direction in which a flex layout flows.
enum VerticalDirection {
  /// Children are laid out from bottom to top.
  up,

  /// Children are laid out from top to bottom.
  down,
}
