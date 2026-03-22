import '../../../radartui.dart';

class MediaQueryData {
  final Size size;
  final EdgeInsets padding;

  const MediaQueryData({
    required this.size,
    this.padding = EdgeInsets.zero,
  });

  MediaQueryData copyWith({
    Size? size,
    EdgeInsets? padding,
  }) {
    return MediaQueryData(
      size: size ?? this.size,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaQueryData &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          padding == other.padding;

  @override
  int get hashCode => Object.hash(size, padding);

  @override
  String toString() => 'MediaQueryData(size: $size, padding: $padding)';
}

class MediaQuery extends InheritedWidget {
  final MediaQueryData data;

  const MediaQuery({
    super.key,
    required this.data,
    required super.child,
  });

  static MediaQueryData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    if (widget != null) {
      return widget.data;
    }
    throw FlutterError('MediaQuery.of() called with no MediaQuery ancestor');
  }

  static MediaQueryData maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    return widget?.data ?? const MediaQueryData(size: Size(80, 24));
  }

  @override
  bool updateShouldNotify(MediaQuery oldWidget) => data != oldWidget.data;
}

class FlutterError implements Exception {
  final String message;
  FlutterError(this.message);
  @override
  String toString() => 'FlutterError: $message';
}
