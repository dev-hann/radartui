import '../../../radartui.dart';

class Align extends SingleChildRenderObjectWidget {
  const Align({
    required this.alignment,
    super.child,
  });

  final Alignment alignment;

  @override
  RenderAlign createRenderObject(BuildContext context) {
    return RenderAlign(alignment: alignment);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderAlign renderObject) {
    renderObject.alignment = alignment;
  }
}

class RenderAlign extends SingleChildRenderBox {
  RenderAlign({required Alignment alignment}) : _alignment = alignment;

  Alignment get alignment => _alignment;
  Alignment _alignment;
  set alignment(Alignment value) {
    if (_alignment == value) {
      return;
    }
    _alignment = value;
    markNeedsLayout();
  }

  @override
  Size computeSizeFromChild(BoxConstraints constraints, Size childSize) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) {
    final double x =
        parentOffset.x + (size!.width - childSize.width) * (alignment.x + 1) / 2;
    final double y = parentOffset.y +
        (size!.height - childSize.height) * (alignment.y + 1) / 2;
    return Offset(x.round(), y.round());
  }
}
