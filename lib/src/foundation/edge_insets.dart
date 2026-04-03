class EdgeInsets {
  const EdgeInsets.fromLTRB(this.left, this.top, this.right, this.bottom);
  const EdgeInsets.all(int v) : this.fromLTRB(v, v, v, v);
  const EdgeInsets.symmetric({int vertical = 0, int horizontal = 0})
    : this.fromLTRB(horizontal, vertical, horizontal, vertical);
  const EdgeInsets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });
  final int top, right, bottom, left;
  static const EdgeInsets zero = EdgeInsets.all(0);

  int get horizontal => left + right;
  int get vertical => top + bottom;

  EdgeInsets operator +(EdgeInsets other) => EdgeInsets.fromLTRB(
    left + other.left,
    top + other.top,
    right + other.right,
    bottom + other.bottom,
  );

  @override
  bool operator ==(Object other) =>
      other is EdgeInsets &&
      top == other.top &&
      right == other.right &&
      bottom == other.bottom &&
      left == other.left;

  @override
  int get hashCode => Object.hash(top, right, bottom, left);

  @override
  String toString() => 'EdgeInsets($left, $top, $right, $bottom)';
}
