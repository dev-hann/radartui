import '../../../radartui.dart';

/// A [Flex] that lays out children in a horizontal line.
///
/// Use [MainAxisAlignment] and [CrossAxisAlignment] to control spacing.
/// Children can be wrapped in [Expanded] or [Flexible] to distribute space.
/// A [Flex] that lays out children in a horizontal line.
///
/// Use [MainAxisAlignment] and [CrossAxisAlignment] to control spacing.
/// Children can be wrapped in [Expanded] or [Flexible] to distribute space.
class Row extends Flex {
  const Row({
    super.key,
    required super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
  }) : super(direction: Axis.horizontal);
}

/// A [Flex] that lays out children in a vertical line.
///
/// Use [MainAxisAlignment] and [CrossAxisAlignment] to control spacing.
/// Children can be wrapped in [Expanded] or [Flexible] to distribute space.
/// A [Flex] that lays out children in a vertical line.
///
/// Use [MainAxisAlignment] and [CrossAxisAlignment] to control spacing.
/// Children can be wrapped in [Expanded] or [Flexible] to distribute space.
class Column extends Flex {
  const Column({
    super.key,
    required super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
  }) : super(direction: Axis.vertical);
}

abstract class Flexible extends ParentDataWidget<FlexParentData> {
  const Flexible({
    super.key,
    required super.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });
  final int flex;
  final FlexFit fit;

  @override
  void applyParentData(RenderObject renderObject) {
    renderObject.parentData ??= FlexParentData();
    if (renderObject.parentData is! FlexParentData) {
      renderObject.parentData = FlexParentData();
    }
    final parentData = renderObject.parentData as FlexParentData;
    if (parentData.flex != flex || parentData.fit != fit) {
      parentData.flex = flex;
      parentData.fit = fit;
      renderObject.markNeedsLayout();
    }
  }
}

class Expanded extends Flexible {
  const Expanded({super.key, required super.child, super.flex})
      : super(fit: FlexFit.tight);
}
