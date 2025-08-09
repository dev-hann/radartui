import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/foundation/offset.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget();
  
  @override
  Widget build(BuildContext context) {
    return const _EmptyRenderWidget();
  }
}

class _EmptyRenderWidget extends RenderObjectWidget {
  const _EmptyRenderWidget();
  
  @override
  RenderObjectElement createElement() => RenderObjectElement(this);
  
  @override
  _EmptyRenderObject createRenderObject(BuildContext context) => _EmptyRenderObject();
}

class _EmptyRenderObject extends RenderObject {
  @override
  void performLayout(Constraints constraints) {
    // Empty widget has zero size
  }
  
  @override
  void paint(PaintingContext context, Offset offset) {
    // Empty widget paints nothing
  }
}