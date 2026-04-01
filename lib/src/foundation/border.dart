class Border {
  const Border({
    this.top = '',
    this.right = '',
    this.bottom = '',
    this.left = '',
  });

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

  final String top;
  final String right;
  final String bottom;
  final String left;

  static const Border all = Border(
    top: '─',
    left: '│',
    right: '│',
    bottom: '─',
  );

  static const Border none = Border(
    top: '',
    left: '',
    right: '',
    bottom: '',
  );
}
