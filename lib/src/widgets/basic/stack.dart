import '../../../radartui.dart';

class Stack extends MultiChildRenderObjectWidget {
  const Stack({
    super.key,
    required super.children,
  });

  @override
  RenderStack createRenderObject(BuildContext context) => RenderStack();

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}
}

class StackParentData extends ParentData {
  int? left;
  int? top;
  int? right;
  int? bottom;
  int? width;
  int? height;
  Offset offset = Offset.zero;
}

class RenderStack extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, StackParentData> {
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    int stackWidth = 0;
    int stackHeight = 0;

    final childConstraints = boxConstraints.loosen();

    for (final child in children) {
      setupParentData(child);

      final childParentData = child.parentData as StackParentData;

      if (childParentData.width != null && childParentData.height != null) {
        child.layout(BoxConstraints.tight(
          Size(childParentData.width!, childParentData.height!),
        ));
      } else if (childParentData.width != null) {
        child.layout(BoxConstraints(
          minWidth: childParentData.width!,
          maxWidth: childParentData.width!,
          minHeight: 0,
          maxHeight: boxConstraints.maxHeight,
        ));
      } else if (childParentData.height != null) {
        child.layout(BoxConstraints(
          minWidth: 0,
          maxWidth: boxConstraints.maxWidth,
          minHeight: childParentData.height!,
          maxHeight: childParentData.height!,
        ));
      } else {
        child.layout(childConstraints);
      }

      stackWidth = stackWidth > child.size!.width ? stackWidth : child.size!.width;
      stackHeight = stackHeight > child.size!.height ? stackHeight : child.size!.height;
    }

    final finalWidth = stackWidth > 0 ? stackWidth : boxConstraints.minWidth;
    final finalHeight = stackHeight > 0 ? stackHeight : boxConstraints.minHeight;
    size = boxConstraints.constrain(Size(finalWidth, finalHeight));

    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      final childWidth = child.size!.width;
      final childHeight = child.size!.height;

      int left;
      int top;

      if (childParentData.left != null && childParentData.right != null) {
        final width = finalWidth - childParentData.right! - childParentData.left!;
        left = childParentData.left!;
        if (width != childWidth) {
          child.layout(BoxConstraints.tightFor(width: width, height: childHeight));
        }
      } else if (childParentData.left != null) {
        left = childParentData.left!;
      } else if (childParentData.right != null) {
        left = (finalWidth - childParentData.right! - childWidth).clamp(0, finalWidth);
      } else {
        left = 0;
      }

      if (childParentData.top != null && childParentData.bottom != null) {
        final height = finalHeight - childParentData.bottom! - childParentData.top!;
        top = childParentData.top!;
        if (height != childHeight) {
          child.layout(BoxConstraints.tightFor(width: child.size!.width, height: height));
        }
      } else if (childParentData.top != null) {
        top = childParentData.top!;
      } else if (childParentData.bottom != null) {
        top = (finalHeight - childParentData.bottom! - childHeight).clamp(0, finalHeight);
      } else {
        top = 0;
      }

      childParentData.offset = Offset(left, top);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }
}
