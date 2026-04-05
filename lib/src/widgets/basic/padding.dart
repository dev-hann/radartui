import '../../../radartui.dart';

/// Insets its child by the given [padding].
///
/// For example, `Padding(padding: EdgeInsets.all(2), child: Text('hi'))`
/// adds 2 cells of padding on all sides of the text.
class Padding extends SingleChildRenderObjectWidget {
  /// Creates a [Padding] widget with the given [padding] and [child].
  const Padding({super.key, required this.padding, required super.child});

  /// The amount of space to inset the child.
  final EdgeInsets padding;
  @override
  RenderPadding createRenderObject(BuildContext context) =>
      RenderPadding(padding: padding);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderPadding).padding = padding;
  }
}

/// The render object for [Padding], which insets its child by the given [EdgeInsets].
class RenderPadding extends SingleChildRenderBox {
  /// Creates a [RenderPadding] with the given [padding].
  RenderPadding({required EdgeInsets padding}) : _padding = padding;

  EdgeInsets _padding;

  /// The amount of inset to apply.
  EdgeInsets get padding => _padding;

  /// Sets the padding and marks the render object as needing layout.
  set padding(EdgeInsets v) {
    if (_padding == v) return;
    _padding = v;
    markNeedsLayout();
  }

  /// Deflates the incoming constraints by the padding amount.
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.deflate(padding);

  /// Expands the child size by adding the padding.
  @override
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) {
    return Size(
      childSize.width + padding.left + padding.right,
      childSize.height + padding.top + padding.bottom,
    );
  }

  /// Returns the size when there is no child (just the padding dimensions).
  @override
  Size computeSizeWithoutChild(BoxConstraints constraints) =>
      Size(padding.left + padding.right, padding.top + padding.bottom);

  /// Offsets the child by the left and top padding.
  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) =>
      parentOffset + Offset(padding.left, padding.top);
}
