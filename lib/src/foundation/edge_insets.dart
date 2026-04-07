/// Immutable insets for each edge of a terminal rectangle.
///
/// Follows Flutter's EdgeInsets API: [EdgeInsets.all], [EdgeInsets.symmetric],
/// [EdgeInsets.only], and [EdgeInsets.fromLTRB].
class EdgeInsets {
  /// Creates insets from individual left, top, right, and bottom values.
  const EdgeInsets.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// Creates insets where all four edges are the same value [v].
  const EdgeInsets.all(int v) : this.fromLTRB(v, v, v, v);

  /// Creates insets with symmetric vertical and horizontal values.
  const EdgeInsets.symmetric({int vertical = 0, int horizontal = 0})
      : this.fromLTRB(horizontal, vertical, horizontal, vertical);

  /// Creates insets with only the specified non-zero edges.
  const EdgeInsets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// The inset from the top edge.
  final int top;

  /// The inset from the right edge.
  final int right;

  /// The inset from the bottom edge.
  final int bottom;

  /// The inset from the left edge.
  final int left;

  /// Zero insets on all sides.
  static const EdgeInsets zero = EdgeInsets.all(0);

  /// Horizontal padding of 1 unit on left and right.
  static const EdgeInsets horizontalOne = EdgeInsets.symmetric(horizontal: 1);

  /// Horizontal padding of 2 units on left and right.
  static const EdgeInsets horizontalTwo = EdgeInsets.symmetric(horizontal: 2);

  /// The total horizontal inset (left + right).
  int get horizontal => left + right;

  /// The total vertical inset (top + bottom).
  int get vertical => top + bottom;

  /// Returns the sum of these insets and [other].
  EdgeInsets operator +(EdgeInsets other) => EdgeInsets.fromLTRB(
        left + other.left,
        top + other.top,
        right + other.right,
        bottom + other.bottom,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EdgeInsets &&
        top == other.top &&
        right == other.right &&
        bottom == other.bottom &&
        left == other.left;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left);

  @override
  String toString() => 'EdgeInsets($left, $top, $right, $bottom)';
}
