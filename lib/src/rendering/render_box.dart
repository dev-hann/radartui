import '../foundation.dart';
import 'render_object.dart';

enum FlexFit { tight, loose }

class FlexParentData extends ParentData {
  int flex = 0;
  FlexFit fit = FlexFit.loose;
  Offset offset = Offset.zero;
}

abstract class RenderBox extends RenderObject {
  bool get hasSize => size != null;

  int get width => size?.width ?? 0;

  int get height => size?.height ?? 0;
}

mixin RenderObjectWithChildMixin<C extends RenderObject> on RenderObject {
  C? _child;

  C? get child => _child;
  set child(C? value) {
    if (_child != null) {
      _child!.parent = null;
    }
    _child = value;
    if (_child != null) {
      _child!.parent = this;
    }
  }

  bool get hasChild => _child != null;
}

mixin ContainerRenderObjectMixin<C extends RenderObject, D extends ParentData>
    on RenderObject {
  final List<C> _children = [];
  void add(C child) {
    child.parent = this;
    _children.add(child);
  }

  void remove(C child) {
    _children.remove(child);
    child.parent = null;
  }

  void clear() => _children.clear();
  List<C> get children => _children;
}
