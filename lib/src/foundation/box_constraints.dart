class BoxConstraints {
  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;

  const BoxConstraints({
    this.minWidth = 0,
    this.maxWidth = 999999,
    this.minHeight = 0,
    this.maxHeight = 999999,
  });

  const BoxConstraints.tight(Size size)
      : minWidth = size.width,
        maxWidth = size.width,
        minHeight = size.height,
        maxHeight = size.height;

  const BoxConstraints.loose(Size size)
      : minWidth = 0,
        maxWidth = size.width,
        minHeight = 0,
        maxHeight = size.height;

  const BoxConstraints.expand({
    int? width,
    int? height,
  }) : minWidth = width ?? 999999,
       maxWidth = width ?? 999999,
       minHeight = height ?? 999999,
       maxHeight = height ?? 999999;

  bool get isTight => minWidth >= maxWidth && minHeight >= maxHeight;

  bool get isNormalized =>
      minWidth >= 0.0 &&
      minWidth <= maxWidth &&
      minHeight >= 0.0 &&
      minHeight <= maxHeight;

  BoxConstraints enforce(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: minWidth.clamp(constraints.minWidth, constraints.maxWidth),
      maxWidth: maxWidth.clamp(constraints.minWidth, constraints.maxWidth),
      minHeight: minHeight.clamp(constraints.minHeight, constraints.maxHeight),
      maxHeight: maxHeight.clamp(constraints.minHeight, constraints.maxHeight),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is BoxConstraints &&
      minWidth == other.minWidth &&
      maxWidth == other.maxWidth &&
      minHeight == other.minHeight &&
      maxHeight == other.maxHeight;

  @override
  int get hashCode => Object.hash(minWidth, maxWidth, minHeight, maxHeight);

  @override
  String toString() => 'BoxConstraints(w: $minWidth-$maxWidth, h: $minHeight-$maxHeight)';
}

class Size {
  final int width;
  final int height;

  const Size(this.width, this.height);

  static const Size zero = Size(0, 0);

  @override
  bool operator ==(Object other) =>
      other is Size && width == other.width && height == other.height;

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() => 'Size($width, $height)';
}