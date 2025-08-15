class EdgeInsets {
  final int top, right, bottom, left;
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

  @override
  String toString() => 'EdgeInsets($left, $top, $right, $bottom)';
}
