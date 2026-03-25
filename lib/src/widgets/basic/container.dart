import '../../../radartui.dart';

class Container extends SingleChildRenderObjectWidget {

  const Container({
    super.key,
    Widget? child,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.margin,
  }) : super(child: child ?? const SizedBox());
  final Color? color;
  final int? width;
  final int? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  RenderContainer createRenderObject(BuildContext context) => RenderContainer(
    color: color,
    width: width,
    height: height,
    padding: padding,
    margin: margin,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final container = renderObject as RenderContainer;
    container.color = color;
    container.containerWidth = width;
    container.containerHeight = height;
    container.padding = padding;
    container.margin = margin;
  }
}

class RenderContainer extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {

  RenderContainer({
    this.color,
    int? width,
    int? height,
    this.padding,
    this.margin,
  })  : _width = width, _height = height;
  Color? color;
  int? _width;
  int? _height;
  EdgeInsets? padding;
  EdgeInsets? margin;

  int? get containerWidth => _width;
  set containerWidth(int? value) => _width = value;

  int? get containerHeight => _height;
  set containerHeight(int? value) => _height = value;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalMargin = margin ?? const EdgeInsets.all(0);
    final totalPadding = padding ?? const EdgeInsets.all(0);

    int containerW = _width ?? boxConstraints.maxWidth;
    int containerH = _height ?? LayoutConstants.defaultContainerHeight;

    if (child != null) {
      final childConstraint = BoxConstraints(
        maxWidth: containerW - totalPadding.left - totalPadding.right,
        maxHeight: containerH - totalPadding.top - totalPadding.bottom,
      );
      child!.layout(childConstraint);

      if (_width == null) {
        containerW =
            child!.size!.width + totalPadding.left + totalPadding.right;
      }
      if (_height == null) {
        containerH =
            child!.size!.height + totalPadding.top + totalPadding.bottom;
      }
    }

    size = Size(
      containerW + totalMargin.left + totalMargin.right,
      containerH + totalMargin.top + totalMargin.bottom,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalMargin = margin ?? const EdgeInsets.all(0);
    final totalPadding = padding ?? const EdgeInsets.all(0);
    final innerOffset = offset + Offset(totalMargin.left, totalMargin.top);

    // Fill background FIRST if color is specified
    if (color != null) {
      final bgStyle = TextStyle(backgroundColor: color);
      final bgWidth = size!.width - totalMargin.left - totalMargin.right;
      final bgHeight = size!.height - totalMargin.top - totalMargin.bottom;

      for (int y = 0; y < bgHeight; y++) {
        for (int x = 0; x < bgWidth; x++) {
          context.buffer.writeStyled(
            innerOffset.x + x,
            innerOffset.y + y,
            ' ',
            bgStyle,
          );
        }
      }
    }

    // Paint child AFTER background with padding offset
    if (child != null) {
      context.paintChild(
        child!,
        innerOffset + Offset(totalPadding.left, totalPadding.top),
      );
    }
  }
}
