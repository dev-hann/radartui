import '../../../radartui.dart';

/// Signature for a function that builds a widget given a [BuildContext].
typedef WidgetBuilder = Widget Function(BuildContext context);

/// A stateless utility widget that calls a [builder] callback to obtain its child.
///
/// Useful for obtaining a [BuildContext] that is a child of a different widget
/// without introducing a new widget subclass.
class Builder extends StatelessWidget {
  /// Creates a [Builder] that calls [builder] to obtain its child.
  const Builder({super.key, required this.builder});

  /// The callback invoked during [build] to create the child widget.
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}
