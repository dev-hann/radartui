import 'package:radartui/radartui.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

class Builder extends StatelessWidget {
  const Builder({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}