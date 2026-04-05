import '../../../radartui.dart';

/// A [Flex] that lays out children in a horizontal line.
///
/// Use [MainAxisAlignment] and [CrossAxisAlignment] to control spacing.
/// Children can be wrapped in [Expanded] or [Flexible] to distribute space.
class Row extends Flex {
  /// Creates a [Row] with the given children and alignment options.
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
class Column extends Flex {
  /// Creates a [Column] with the given children and alignment options.
  const Column({
    super.key,
    required super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
  }) : super(direction: Axis.vertical);
}

/// A widget that controls how a child of a [Flex] container is sized.
///
/// Use [Expanded] for a convenience subclass that uses [FlexFit.tight].
abstract class Flexible extends ParentDataWidget<FlexParentData> {
  /// Creates a [Flexible] widget with the given [flex] factor and [fit].
  const Flexible({
    super.key,
    required super.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  /// The flex factor controlling how much space this child takes relative to
  /// other flexible children.
  final int flex;

  /// How the child is constrained: [FlexFit.loose] allows the child to be
  /// smaller than the allocated space; [FlexFit.tight] forces it to fill it.
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

/// A [Flexible] child that is forced to fill its allocated space ([FlexFit.tight]).
class Expanded extends Flexible {
  /// Creates an [Expanded] widget with the given [flex] factor.
  const Expanded({super.key, required super.child, super.flex})
      : super(fit: FlexFit.tight);
}
