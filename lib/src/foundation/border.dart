/// Describes a border made of box-drawing characters for each side.
///
/// Empty strings mean no border on that side. Use [Border.all] for a full
/// box border, or [Border.symmetric] for horizontal/vertical patterns.
class Border {
  /// Creates a [Border] with individual characters for each side.
  const Border({
    this.top = '',
    this.right = '',
    this.bottom = '',
    this.left = '',
  });

  /// Creates a border with symmetric horizontal and vertical characters.
  factory Border.symmetric({
    required String horizontal,
    required String vertical,
  }) =>
      Border(
        top: horizontal,
        left: vertical,
        right: vertical,
        bottom: horizontal,
      );

  /// Creates a border with only the specified sides.
  factory Border.only({
    String? top,
    String? right,
    String? bottom,
    String? left,
  }) =>
      Border(
        top: top ?? '',
        right: right ?? '',
        bottom: bottom ?? '',
        left: left ?? '',
      );

  /// The character used for the top border.
  final String top;

  /// The character used for the right border.
  final String right;

  /// The character used for the bottom border.
  final String bottom;

  /// The character used for the left border.
  final String left;

  /// A full box border using standard box-drawing characters.
  static const Border all = Border(
    top: '─',
    left: '│',
    right: '│',
    bottom: '─',
  );

  /// No border on any side.
  static const Border none = Border(top: '', left: '', right: '', bottom: '');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Border &&
        top == other.top &&
        right == other.right &&
        bottom == other.bottom &&
        left == other.left;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left);
}
