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
    if (parentData is! StackParentData) return;

    bool needsLayout = false;
    needsLayout =
        _updateField(parentData.left, left, (v) => parentData.left = v) ||
            needsLayout;
    needsLayout =
        _updateField(parentData.top, top, (v) => parentData.top = v) ||
            needsLayout;
    needsLayout =
        _updateField(parentData.right, right, (v) => parentData.right = v) ||
            needsLayout;
    needsLayout =
        _updateField(parentData.bottom, bottom, (v) => parentData.bottom = v) ||
            needsLayout;
    needsLayout =
        _updateField(parentData.width, width, (v) => parentData.width = v) ||
            needsLayout;
    needsLayout =
        _updateField(parentData.height, height, (v) => parentData.height = v) ||
            needsLayout;

    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
  }

  bool _updateField(int? current, int? newValue, void Function(int?) setter) {
    if (current != newValue) {
      setter(newValue);
      return true;
    }
    return false;
  }
}
