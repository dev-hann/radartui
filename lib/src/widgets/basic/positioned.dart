import '../../../radartui.dart';

/// Controls where a child is positioned within a [Stack].
///
/// Each of [left], [top], [right], [bottom] is an offset from the corresponding
/// edge of the stack. Use [Positioned.fill] to stretch to all edges.
class Positioned extends ParentDataWidget<StackParentData> {
  /// Creates a [Positioned] widget with optional offsets from each edge.
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

  /// Creates a [Positioned] that stretches to all four edges of the [Stack].
  const Positioned.fill({super.key, required super.child})
      : left = 0,
        top = 0,
        right = 0,
        bottom = 0,
        width = null,
        height = null;

  /// The offset from the left edge of the stack.
  final int? left;

  /// The offset from the top edge of the stack.
  final int? top;

  /// The offset from the right edge of the stack.
  final int? right;

  /// The offset from the bottom edge of the stack.
  final int? bottom;

  /// An explicit width for the child.
  final int? width;

  /// An explicit height for the child.
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
