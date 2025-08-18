import '../../foundation/offset.dart';
import '../../foundation/size.dart';
import '../../rendering/single_child_render_box.dart';
import '../framework.dart';

class Center extends SingleChildRenderObjectWidget {
  const Center({required Widget child}) : super(child: child);

  @override
  RenderCenter createRenderObject(BuildContext context) => RenderCenter();
}

class RenderCenter extends SingleChildRenderBox {
  @override
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) {
    return Offset(
      parentOffset.x + (size!.width - childSize.width) ~/ 2,
      parentOffset.y + (size!.height - childSize.height) ~/ 2,
    );
  }
}
