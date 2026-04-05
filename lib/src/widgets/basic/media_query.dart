import '../../../radartui.dart';

/// Contains terminal dimensions and safe area insets.
///
/// Use [MediaQuery.of] to obtain the current [MediaQueryData], which provides
/// [size] (terminal columns × rows) and [padding] (safe area insets).
class MediaQueryData {
  /// Creates a [MediaQueryData] with the given [size] and optional [padding].
  const MediaQueryData({required this.size, this.padding = EdgeInsets.zero});

  /// The terminal size in columns × rows.
  final Size size;

  /// Safe area insets (e.g., for status bars).
  final EdgeInsets padding;

  /// Creates a copy of this object with the given fields replaced.
  MediaQueryData copyWith({Size? size, EdgeInsets? padding}) {
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

/// An inherited widget that provides [MediaQueryData] to its descendants.
///
/// Use [MediaQuery.of] to look up the current terminal dimensions.
class MediaQuery extends InheritedWidget {
  /// Creates a [MediaQuery] with the given [data].
  const MediaQuery({super.key, required this.data, required super.child});

  /// The current media query data (terminal size, padding, etc.).
  final MediaQueryData data;

  /// Returns the [MediaQueryData] from the closest [MediaQuery] ancestor.
  ///
  /// Throws a [RadartuiError] if no [MediaQuery] is found.
  static MediaQueryData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    if (widget != null) {
      return widget.data;
    }
    throw RadartuiError('MediaQuery.of() called with no MediaQuery ancestor');
  }

  /// Returns the [MediaQueryData] from the closest [MediaQuery] ancestor,
  /// or a default 80×24 fallback if none is found.
  static MediaQueryData maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    return widget?.data ?? const MediaQueryData(size: Size(80, 24));
  }

  /// Whether descendant widgets should be notified when [data] changes.
  @override
  bool updateShouldNotify(MediaQuery oldWidget) => data != oldWidget.data;
}
