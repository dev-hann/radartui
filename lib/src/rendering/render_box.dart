import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_object.dart';

class BoxConstraints extends Constraints {
  final int maxWidth, maxHeight;
  const BoxConstraints({this.maxWidth = 9999, this.maxHeight = 9999});

  Size get biggest => Size(maxWidth, maxHeight);
  BoxConstraints deflate(EdgeInsets edge) {
    final horizontal = edge.left + edge.right;
    final vertical = edge.top + edge.bottom;
    return BoxConstraints(
      maxWidth: (maxWidth - horizontal).clamp(0, 9999),
      maxHeight: (maxHeight - vertical).clamp(0, 9999),
    );
  }
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