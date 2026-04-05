import '../../../radartui.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

/// A stateless utility widget that calls a [builder] callback to obtain its child.
///
/// Useful for obtaining a [BuildContext] that is a child of a different widget
/// without introducing a new widget subclass.
class Builder extends StatelessWidget {
  const Builder({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}
