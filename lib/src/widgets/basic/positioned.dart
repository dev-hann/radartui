import '../../../radartui.dart';

class Positioned extends ParentDataWidget<StackParentData> {
  const Positioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required super.child,
  });

  const Positioned.fill({super.key, required super.child})
    : left = 0,
      top = 0,
      right = 0,
      bottom = 0,
      width = null,
      height = null;
  final int? left;
  final int? top;
  final int? right;
  final int? bottom;
  final int? width;
  final int? height;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData;
    if (parentData is StackParentData) {
      bool needsLayout = false;
      if (parentData.left != left) {
        parentData.left = left;
        needsLayout = true;
      }
      if (parentData.top != top) {
        parentData.top = top;
        needsLayout = true;
      }
      if (parentData.right != right) {
        parentData.right = right;
        needsLayout = true;
      }
      if (parentData.bottom != bottom) {
        parentData.bottom = bottom;
        needsLayout = true;
      }
      if (parentData.width != width) {
        parentData.width = width;
        needsLayout = true;
      }
      if (parentData.height != height) {
        parentData.height = height;
        needsLayout = true;
      }
      if (needsLayout) {
        renderObject.markNeedsLayout();
      }
    }
  }
}
