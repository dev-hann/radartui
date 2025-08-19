import '../foundation.dart';
import 'render_object.dart';

class FlexParentData extends ParentData {
  Offset offset = Offset.zero;
}

abstract class RenderBox extends RenderObject {}

mixin ContainerRenderObjectMixin<C extends RenderObject, D extends ParentData> on RenderObject {
  final List<C> _children = [];
  void add(C child) {
    child.parent = this; // Use the setter
    _children.add(child);
  }
  void clear() => _children.clear();
  List<C> get children => _children;
}
