import 'dart:math' as math;

import '../../../radartui.dart';

/// A widget that layers its children on top of each other.
///
/// The first child is the base; subsequent children are painted on top.
/// Use [Positioned] to place children at specific offsets within the stack.
class Stack extends MultiChildRenderObjectWidget {
  const Stack({super.key, required super.children});

  @override
  RenderStack createRenderObject(BuildContext context) => RenderStack();

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}
}

/// Parent data used by [Positioned] to specify a child's placement in a [Stack].
class StackParentData extends ParentData {
  /// The offset from the left edge of the stack.
  int? left;

  /// The offset from the top edge of the stack.
  int? top;

  /// The offset from the right edge of the stack.
  int? right;

  /// The offset from the bottom edge of the stack.
  int? bottom;

  /// An explicit width for the child.
  int? width;

  /// An explicit height for the child.
  int? height;

  /// The resolved paint offset computed during layout.
  Offset offset = Offset.zero;
}

/// The render object for [Stack], which layers children on top of each other
/// and positions them via [StackParentData].
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
    final childConstraints = boxConstraints.loosen();

    final dimensions = _layoutChildren(boxConstraints, childConstraints);

    final int finalWidth =
        dimensions.width > 0 ? dimensions.width : boxConstraints.minWidth;
    final int finalHeight =
        dimensions.height > 0 ? dimensions.height : boxConstraints.minHeight;
    size = boxConstraints.constrain(Size(finalWidth, finalHeight));

    _positionChildren(finalWidth, finalHeight);
  }

  Size _layoutChildren(
    BoxConstraints boxConstraints,
    BoxConstraints childConstraints,
  ) {
    int maxWidth = 0;
    int maxHeight = 0;
    for (final child in children) {
      setupParentData(child);
      final childParentData = child.parentData as StackParentData;
      _layoutChild(child, childParentData, boxConstraints, childConstraints);
      maxWidth = math.max(maxWidth, child.size!.width);
      maxHeight = math.max(maxHeight, child.size!.height);
    }
    return Size(maxWidth, maxHeight);
  }

  void _layoutChild(
    RenderBox child,
    StackParentData data,
    BoxConstraints boxConstraints,
    BoxConstraints childConstraints,
  ) {
    if (data.width != null && data.height != null) {
      child.layout(BoxConstraints.tight(Size(data.width!, data.height!)));
    } else if (data.width != null) {
      child.layout(BoxConstraints(
        minWidth: data.width!,
        maxWidth: data.width!,
        minHeight: 0,
        maxHeight: boxConstraints.maxHeight,
      ));
    } else if (data.height != null) {
      child.layout(BoxConstraints(
        minWidth: 0,
        maxWidth: boxConstraints.maxWidth,
        minHeight: data.height!,
        maxHeight: data.height!,
      ));
    } else {
      child.layout(childConstraints);
    }
  }

  void _positionChildren(int finalWidth, int finalHeight) {
    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      final left = _computeHorizontalPosition(
        child,
        childParentData,
        finalWidth,
      );
      final top = _computeVerticalPosition(
        child,
        childParentData,
        finalHeight,
      );
      childParentData.offset = Offset(left, top);
    }
  }

  int _computeHorizontalPosition(
    RenderBox child,
    StackParentData data,
    int finalWidth,
  ) {
    if (data.left != null && data.right != null) {
      final width = finalWidth - data.right! - data.left!;
      if (width != child.size!.width) {
        child.layout(
          BoxConstraints.tightFor(width: width, height: child.size!.height),
        );
      }
      return data.left!;
    } else if (data.left != null) {
      return data.left!;
    } else if (data.right != null) {
      return (finalWidth - data.right! - child.size!.width)
          .clamp(0, finalWidth);
    }
    return 0;
  }

  int _computeVerticalPosition(
    RenderBox child,
    StackParentData data,
    int finalHeight,
  ) {
    if (data.top != null && data.bottom != null) {
      final height = finalHeight - data.bottom! - data.top!;
      if (height != child.size!.height) {
        child.layout(
          BoxConstraints.tightFor(width: child.size!.width, height: height),
        );
      }
      return data.top!;
    } else if (data.top != null) {
      return data.top!;
    } else if (data.bottom != null) {
      return (finalHeight - data.bottom! - child.size!.height)
          .clamp(0, finalHeight);
    }
    return 0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }
}
