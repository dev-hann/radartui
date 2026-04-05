/// A position within a rectangle, expressed as offsets from center.
///
/// (-1, -1) is top-left, (0, 0) is center, (1, 1) is bottom-right.
/// Follows Flutter's Alignment coordinate system.
class Alignment {
  /// Creates an [Alignment] with the given [x] and [y] offsets.
  const Alignment(this.x, this.y);

  /// The horizontal offset from center (-1 to 1).
  final double x;

  /// The vertical offset from center (-1 to 1).
  final double y;

  /// The top-left corner.
  static const Alignment topLeft = Alignment(-1.0, -1.0);

  /// The center of the top edge.
  static const Alignment topCenter = Alignment(0.0, -1.0);

  /// The top-right corner.
  static const Alignment topRight = Alignment(1.0, -1.0);

  /// The center of the left edge.
  static const Alignment centerLeft = Alignment(-1.0, 0.0);

  /// The exact center.
  static const Alignment center = Alignment(0.0, 0.0);

  /// The center of the right edge.
  static const Alignment centerRight = Alignment(1.0, 0.0);

  /// The bottom-left corner.
  static const Alignment bottomLeft = Alignment(-1.0, 1.0);

  /// The center of the bottom edge.
  static const Alignment bottomCenter = Alignment(0.0, 1.0);

  /// The bottom-right corner.
  static const Alignment bottomRight = Alignment(1.0, 1.0);

  @override
  bool operator ==(Object other) =>
      other is Alignment && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Alignment($x, $y)';
}
