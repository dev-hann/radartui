import '../../../radartui.dart';

class Stack extends MultiChildRenderObjectWidget {
  const Stack({
    required super.children,
  });

  @override
  RenderStack createRenderObject(BuildContext context) => RenderStack();

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    // No properties to update for basic Stack
  }
}

class StackParentData extends ParentData {
  Offset offset = Offset.zero;
}

class RenderStack extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, StackParentData> {

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    int stackWidth = 0;
    int stackHeight = 0;

    // Give children loose constraints so they can size themselves
    final childConstraints = boxConstraints.loosen();

    // Layout all children and determine the stack size
    for (final child in children) {
      // Setup parent data if needed
      if (child.parentData is! StackParentData) {
        child.parentData = StackParentData();
      }

      child.layout(childConstraints);
      stackWidth = stackWidth > child.size!.width ? stackWidth : child.size!.width;
      stackHeight = stackHeight > child.size!.height ? stackHeight : child.size!.height;

      // All children are positioned at (0, 0) for basic stacking
      final childParentData = child.parentData as StackParentData;
      childParentData.offset = const Offset(0, 0);
    }

    // Stack takes the size from constraints, not children
    size = boxConstraints.constrain(Size(
      stackWidth > 0 ? stackWidth : boxConstraints.minWidth,
      stackHeight > 0 ? stackHeight : boxConstraints.minHeight,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint children in order (first child at bottom, last child on top)
    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }
}