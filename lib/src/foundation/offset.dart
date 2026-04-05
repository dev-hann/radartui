/// An immutable 2D integer offset with [x] and [y] coordinates.
///
/// Used for positioning within the terminal grid (0-based).
class Offset {
  /// Creates an [Offset] with the given [x] and [y] coordinates.
  const Offset(this.x, this.y);

  /// The horizontal coordinate.
  final int x;

  /// The vertical coordinate.
  final int y;

  /// An offset at the origin (0, 0).
  static const zero = Offset(0, 0);

  /// Returns the sum of this offset and [other].
  Offset operator +(Offset other) => Offset(x + other.x, y + other.y);

  /// Returns the difference between this offset and [other].
  Offset operator -(Offset other) => Offset(x - other.x, y - other.y);

  @override
  bool operator ==(Object other) =>
      other is Offset && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Offset($x, $y)';
}
