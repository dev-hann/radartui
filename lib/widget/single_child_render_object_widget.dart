import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {
  const SingleChildRenderObjectWidget({super.key, required this.child});

  final Widget child;
}
