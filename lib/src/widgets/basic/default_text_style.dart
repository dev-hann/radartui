import '../../../radartui.dart';

class DefaultTextStyle extends InheritedWidget {
  const DefaultTextStyle({
    super.key,
    required this.style,
    required super.child,
  });

  final TextStyle style;

  static TextStyle of(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    if (widget != null) {
      return widget.style;
    }
    return const TextStyle();
  }

  static TextStyle maybeOf(BuildContext context) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    return widget?.style ?? const TextStyle();
  }

  @override
  bool updateShouldNotify(DefaultTextStyle oldWidget) =>
      style != oldWidget.style;
}
