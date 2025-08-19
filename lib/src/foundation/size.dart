class Size {
  final int width, height;
  const Size(this.width, this.height);
  static const zero = Size(0, 0);

  @override
  String toString() => 'Size($width, $height)';

  @override
  bool operator ==(Object other) =>
      other is Size && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hash(width, height);
}
