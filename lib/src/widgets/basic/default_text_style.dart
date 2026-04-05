import '../../../radartui.dart';

/// An inherited widget that sets the default [TextStyle] for descendant
/// [Text] and [RichText] widgets.
///
/// Retrieve via [DefaultTextStyle.of]. If no DefaultTextStyle ancestor exists,
/// returns a default [TextStyle()].
class DefaultTextStyle extends InheritedWidget {
  /// Creates a [DefaultTextStyle] that provides [style] to descendants.
  const DefaultTextStyle({
    super.key,
    required this.style,
    required super.child,
  });

  /// The default text style for descendant [Text] widgets.
  final TextStyle style;

  /// Returns the [TextStyle] from the closest [DefaultTextStyle] ancestor,
  /// or a default [TextStyle()] if none exists.
  static TextStyle of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    if (widget != null) {
      return widget.style;
    }
    return const TextStyle();
  }

  /// Returns the [TextStyle] from the closest [DefaultTextStyle] ancestor,
  /// or `null` if none exists.
  static TextStyle maybeOf(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    return widget?.style ?? const TextStyle();
  }

  /// Whether descendant widgets should rebuild when [style] changes.
  @override
  bool updateShouldNotify(DefaultTextStyle oldWidget) =>
      style != oldWidget.style;
}
