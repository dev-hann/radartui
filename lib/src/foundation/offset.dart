/// An immutable 2D integer offset with [x] and [y] coordinates.
///
/// Used for positioning within the terminal grid (0-based).
class Offset {
  const Offset(this.x, this.y);
  final int x, y;
  static const zero = Offset(0, 0);
  Offset operator +(Offset other) => Offset(x + other.x, y + other.y);
  Offset operator -(Offset other) => Offset(x - other.x, y - other.y);

  @override
  bool operator ==(Object other) =>
      other is Offset && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Offset($x, $y)';
}
