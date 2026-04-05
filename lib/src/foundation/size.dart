/// An immutable 2D integer size with [width] and [height].
///
/// Terminal cells are discrete, so coordinates are always integers.
class Size {
  /// Creates a [Size] with the given [width] and [height].
  const Size(this.width, this.height);

  /// The width in terminal columns.
  final int width;

  /// The height in terminal rows.
  final int height;

  /// A size with zero width and height.
  static const zero = Size(0, 0);

  @override
  String toString() => 'Size($width, $height)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Size && width == other.width && height == other.height;
  }

  @override
  int get hashCode => Object.hash(width, height);
}
