import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

abstract class MultiChildRenderObjectWidget extends RenderObjectWidget {
  const MultiChildRenderObjectWidget({super.key, this.children = const <Widget>[]});

  final List<Widget> children;
}
