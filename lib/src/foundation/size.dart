class Size {
  final int width, height;
  const Size(this.width, this.height);
  static const zero = Size(0, 0);
  
  @override
  String toString() => 'Size($width, $height)';
}
