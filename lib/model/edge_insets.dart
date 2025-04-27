class EdgeInsets {
  const EdgeInsets.all(int value)
    : left = value,
      right = value,
      top = value,
      bottom = value;

  const EdgeInsets.only({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  final int left;
  final int right;
  final int top;
  final int bottom;
}
