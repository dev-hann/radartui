import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/foundation/constants.dart';
import 'package:radartui/src/rendering/render_object.dart';

class BoxConstraints extends Constraints {
  final int maxWidth, maxHeight;
  const BoxConstraints({
    this.maxWidth = LayoutConstants.maxWidth, 
    this.maxHeight = LayoutConstants.maxHeight
  });

  Size get biggest => Size(maxWidth, maxHeight);
  
  Size constrain(Size size) {
    return Size(
      size.width.clamp(0, maxWidth).toInt(),
      size.height.clamp(0, maxHeight).toInt(),
    );
  }
  
  BoxConstraints deflate(EdgeInsets edge) {
    final horizontal = edge.left + edge.right;
    final vertical = edge.top + edge.bottom;
    return BoxConstraints(
      maxWidth: (maxWidth - horizontal).clamp(0, LayoutConstants.maxWidth),
      maxHeight: (maxHeight - vertical).clamp(0, LayoutConstants.maxHeight),
    );
  }
}

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
