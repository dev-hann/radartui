import 'package:radartui/widget/element.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/widget.dart';

abstract class RenderObjectWidget extends Widget {
  RenderObject createRenderObject();
  void updateRenderObject(RenderObject renderObject);

  @override
  Element createElement() => RenderObjectElement(this);
}
