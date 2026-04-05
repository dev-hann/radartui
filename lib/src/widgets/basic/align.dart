import '../../../radartui.dart';

/// Positions its child within itself according to [alignment].
///
/// For example, `Align(alignment: Alignment.center, child: Text('hello'))`
/// centers the child within the Align widget's bounds.
class Align extends SingleChildRenderObjectWidget {
  /// Creates an [Align] widget with the given [alignment].
  const Align({super.key, required this.alignment, super.child});

  /// The alignment determining the child's position within this widget.
  final Alignment alignment;

  @override
  RenderAlign createRenderObject(BuildContext context) {
    return RenderAlign(alignment: alignment);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderAlign renderObject,
  ) {
    renderObject.alignment = alignment;
  }
}

/// The render object for [Align], which positions its child according to an
/// [Alignment] value.
class RenderAlign extends SingleChildRenderBox {
  /// Creates a [RenderAlign] with the given [alignment].
  RenderAlign({required Alignment alignment}) : _alignment = alignment;

  /// The current alignment.
  Alignment get alignment => _alignment;
  Alignment _alignment;

  /// Sets the alignment and marks the layout dirty if it changed.
  set alignment(Alignment value) {
    if (_alignment == value) {
      return;
    }
    _alignment = value;
    markNeedsLayout();
  }

  /// Computes the final size, shrinking to the child when aligned away from
  /// start or when constraints are unbounded.
  @override
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) {
    final bool shrinkWrapWidth =
        _alignment.x != 0 || constraints.maxWidth == Constraints.infinity;
    final bool shrinkWrapHeight =
        _alignment.y != 0 || constraints.maxHeight == Constraints.infinity;

    final int width = shrinkWrapWidth ? childSize.width : constraints.maxWidth;
    final int height =
        shrinkWrapHeight ? childSize.height : constraints.maxHeight;

    return Size(width, height);
  }

  /// Computes the child's paint offset based on the alignment.
  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) {
    final double x = parentOffset.x +
        (size!.width - childSize.width) * (alignment.x + 1) / 2;
    final double y = parentOffset.y +
        (size!.height - childSize.height) * (alignment.y + 1) / 2;
    return Offset(x.round(), y.round());
  }
}
