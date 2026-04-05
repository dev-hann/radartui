/// A position within a rectangle, expressed as offsets from center.
///
/// (-1, -1) is top-left, (0, 0) is center, (1, 1) is bottom-right.
/// Follows Flutter's Alignment coordinate system.
class Alignment {
  const Alignment(this.x, this.y);
  final double x;
  final double y;

  static const Alignment topLeft = Alignment(-1.0, -1.0);
  static const Alignment topCenter = Alignment(0.0, -1.0);
  static const Alignment topRight = Alignment(1.0, -1.0);
  static const Alignment centerLeft = Alignment(-1.0, 0.0);
  static const Alignment center = Alignment(0.0, 0.0);
  static const Alignment centerRight = Alignment(1.0, 0.0);
  static const Alignment bottomLeft = Alignment(-1.0, 1.0);
  static const Alignment bottomCenter = Alignment(0.0, 1.0);
  static const Alignment bottomRight = Alignment(1.0, 1.0);

  @override
  bool operator ==(Object other) =>
      other is Alignment && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Alignment($x, $y)';
}
