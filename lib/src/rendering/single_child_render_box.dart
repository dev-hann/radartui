import '../foundation/offset.dart';
import '../foundation/size.dart';
import 'render_box.dart';
import 'render_object.dart';

abstract class SingleChildRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ParentData> {
  
  RenderBox? get child => children.isNotEmpty ? children.first : null;
  
  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    
    if (child != null) {
      final childConstraints = getConstraintsForChild(boxConstraints);
      child!.layout(childConstraints);
      size = computeSizeFromChild(boxConstraints, child!.size!);
    } else {
      size = computeSizeWithoutChild(boxConstraints);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final childOffset = computeChildOffset(offset, child!.size!);
      context.paintChild(child!, childOffset);
    }
  }

  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints;
  
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) => childSize;
  
  Size computeSizeWithoutChild(BoxConstraints constraints) => 
      Size(constraints.maxWidth, constraints.maxHeight);
  
  Offset computeChildOffset(Offset parentOffset, Size childSize) => parentOffset;
}