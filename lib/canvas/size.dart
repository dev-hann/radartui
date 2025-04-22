class Size {
  const Size(this.width, this.height);
  final int width;
  final int height;

  static const zero = Size(0, 0);

  // Offset get center {
  //   return Offset(width ~/ 2, height ~/ 2);
  // }

  @override
  String toString() {
    return "$runtimeType{$width,$height}";
  }

  Size operator -(Size other) {
    return Size(width - other.width, height - other.height);
  }

  Size operator +(Size other) {
    return Size(width + other.width, height + other.height);
  }
}
