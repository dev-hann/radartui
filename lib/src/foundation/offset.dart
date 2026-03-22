class Offset {
  final int x, y;
  const Offset(this.x, this.y);
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
