import '../../../radartui.dart';

/// A widget that displays its children in a horizontal or vertical line.
///
/// Use [Row] for horizontal or [Column] for vertical instead of using [Flex]
/// directly. Controls alignment via [MainAxisAlignment] and [CrossAxisAlignment].
class Flex extends MultiChildRenderObjectWidget {
  /// Creates a [Flex] layout widget.
  ///
  /// Prefer using [Row] or [Column] instead of [Flex] directly.
  const Flex({
    super.key,
    required super.children,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  /// The direction along which children are laid out.
  final Axis direction;

  /// How children are distributed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How children are aligned on the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// How much space the flex should occupy on the main axis.
  final MainAxisSize mainAxisSize;

  @override
  RenderFlex createRenderObject(BuildContext context) => RenderFlex(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderFlex = renderObject as RenderFlex;
    renderFlex.direction = direction;
    renderFlex.mainAxisAlignment = mainAxisAlignment;
    renderFlex.crossAxisAlignment = crossAxisAlignment;
    renderFlex.mainAxisSize = mainAxisSize;
  }
}

/// The render object for [Flex], responsible for measuring and positioning
/// children along a main axis with flex expansion support.
class RenderFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, FlexParentData> {
  /// Creates a [RenderFlex] with the given layout parameters.
  RenderFlex({
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  /// The direction along which children are laid out.
  Axis direction;

  /// How children are distributed along the main axis.
  MainAxisAlignment mainAxisAlignment;

  /// How children are aligned on the cross axis.
  CrossAxisAlignment crossAxisAlignment;

  /// How much space the flex should occupy on the main axis.
  MainAxisSize mainAxisSize;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final isHorizontal = direction == Axis.horizontal;
    final axisExtents = _axisExtents(isHorizontal, boxConstraints);
    final totalFlex = _computeTotalFlex();

    final measurement = _measureChildren(
      isHorizontal,
      boxConstraints,
      totalFlex,
      axisExtents.main,
    );

    size = _computeSize(
      isHorizontal,
      measurement.nonFlexExtent,
      measurement.flexExtent,
      axisExtents.main,
      axisExtents.cross,
      measurement.crossExtent,
    );

    _resolveAndPositionChildren(
      isHorizontal,
      measurement.nonFlexExtent,
      measurement.flexExtent,
    );
  }

  ({int main, int cross}) _axisExtents(
    bool isHorizontal,
    BoxConstraints boxConstraints,
  ) {
    return (
      main: isHorizontal ? boxConstraints.maxWidth : boxConstraints.maxHeight,
      cross: isHorizontal ? boxConstraints.maxHeight : boxConstraints.maxWidth,
    );
  }

  ({int nonFlexExtent, int flexExtent, int crossExtent}) _measureChildren(
    bool isHorizontal,
    BoxConstraints boxConstraints,
    int totalFlex,
    int maxMainAxisExtent,
  ) {
    final nonFlexResult = _measureNonFlexChildren(isHorizontal, boxConstraints);
    final flexResult = _measureFlexChildren(
      isHorizontal,
      boxConstraints,
      totalFlex,
      maxMainAxisExtent - nonFlexResult.mainExtent,
      nonFlexResult.crossExtent,
    );

    return (
      nonFlexExtent: nonFlexResult.mainExtent,
      flexExtent: flexResult.mainExtent,
      crossExtent: flexResult.crossExtent,
    );
  }

  void _resolveAndPositionChildren(
    bool isHorizontal,
    int totalNonFlexExtent,
    int totalFlexExtent,
  ) {
    final actualCrossAxisExtent = isHorizontal ? size!.height : size!.width;
    final actualMainAxisExtent = isHorizontal ? size!.width : size!.height;
    final alignment = _computeMainAxisAlignment(
      actualMainAxisExtent - totalNonFlexExtent - totalFlexExtent,
    );

    _positionChildren(
      isHorizontal,
      actualCrossAxisExtent,
      alignment.leading,
      alignment.between,
    );
  }

  int _computeTotalFlex() {
    int total = 0;
    for (final child in children) {
      final flex = _getFlex(child);
      if (flex > 0) {
        total += flex;
      }
    }
    return total;
  }

  int _childMainExtent(bool isHorizontal, RenderBox child) =>
      isHorizontal ? child.size!.width : child.size!.height;

  int _childCrossExtent(bool isHorizontal, RenderBox child) =>
      isHorizontal ? child.size!.height : child.size!.width;

  _FlexMeasurement _measureNonFlexChildren(
    bool isHorizontal,
    BoxConstraints boxConstraints,
  ) {
    int mainExtent = 0;
    int crossExtent = 0;
    for (final child in children) {
      if (_getFlex(child) != 0) continue;
      child.layout(boxConstraints.loosen());
      mainExtent += _childMainExtent(isHorizontal, child);
      final childCross = _childCrossExtent(isHorizontal, child);
      if (childCross > crossExtent) {
        crossExtent = childCross;
      }
    }
    return _FlexMeasurement(mainExtent: mainExtent, crossExtent: crossExtent);
  }

  _FlexMeasurement _measureFlexChildren(
    bool isHorizontal,
    BoxConstraints boxConstraints,
    int totalFlex,
    int freeSpace,
    int initialCrossExtent,
  ) {
    final spacePerFlex = totalFlex > 0 ? freeSpace ~/ totalFlex : 0;
    int allocatedSpace = 0;
    int maxCrossExtent = initialCrossExtent;

    for (final child in children) {
      final flex = _getFlex(child);
      if (flex <= 0) continue;
      child.layout(_getConstraintsForFlexChild(
        boxConstraints,
        spacePerFlex * flex,
        _getFit(child),
      ));
      allocatedSpace += _childMainExtent(isHorizontal, child);
      final childCross = _childCrossExtent(isHorizontal, child);
      if (childCross > maxCrossExtent) {
        maxCrossExtent = childCross;
      }
    }
    return _FlexMeasurement(
      mainExtent: allocatedSpace,
      crossExtent: maxCrossExtent,
    );
  }

  Size _computeSize(
    bool isHorizontal,
    int nonFlexExtent,
    int flexExtent,
    int maxMainAxisExtent,
    int crossAxisExtent,
    int maxCrossExtent,
  ) {
    int totalMain = nonFlexExtent + flexExtent;
    if (mainAxisSize == MainAxisSize.max) {
      totalMain = maxMainAxisExtent;
    }
    final effectiveCross = crossAxisExtent < 0 ? 0 : crossAxisExtent;
    if (isHorizontal) {
      return Size(totalMain, maxCrossExtent.clamp(0, effectiveCross));
    }
    return Size(maxCrossExtent.clamp(0, effectiveCross), totalMain);
  }

  ({int leading, int between}) _computeMainAxisAlignment(int freeSpace) {
    int leading = 0;
    int between = 0;
    switch (mainAxisAlignment) {
      case MainAxisAlignment.start:
        break;
      case MainAxisAlignment.end:
        leading = freeSpace;
      case MainAxisAlignment.center:
        leading = freeSpace ~/ 2;
      case MainAxisAlignment.spaceBetween:
        if (children.length > 1) {
          between = freeSpace ~/ (children.length - 1);
        }
      case MainAxisAlignment.spaceAround:
        if (children.isNotEmpty) {
          between = freeSpace ~/ children.length;
          leading = between ~/ 2;
        }
      case MainAxisAlignment.spaceEvenly:
        if (children.isNotEmpty) {
          between = freeSpace ~/ (children.length + 1);
          leading = between;
        }
    }
    return (leading: leading, between: between);
  }

  void _positionChildren(
    bool isHorizontal,
    int actualCrossAxisExtent,
    int leadingSpace,
    int betweenSpace,
  ) {
    int mainAxisPosition = leadingSpace;
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      final childMain = _childMainExtent(isHorizontal, child);
      final childCross = _childCrossExtent(isHorizontal, child);
      final crossPos = _crossAxisPosition(actualCrossAxisExtent, childCross);

      childParentData.offset = isHorizontal
          ? Offset(mainAxisPosition, crossPos)
          : Offset(crossPos, mainAxisPosition);
      mainAxisPosition += childMain + betweenSpace;
    }
  }

  int _crossAxisPosition(int actualCrossExtent, int childCrossExtent) {
    switch (crossAxisAlignment) {
      case CrossAxisAlignment.start:
        return 0;
      case CrossAxisAlignment.end:
        return actualCrossExtent - childCrossExtent;
      case CrossAxisAlignment.center:
        return (actualCrossExtent - childCrossExtent) ~/ 2;
      case CrossAxisAlignment.stretch:
        return 0;
    }
  }

  int _getFlex(RenderBox child) {
    final parentData = child.parentData as FlexParentData;
    return parentData.flex;
  }

  FlexFit _getFit(RenderBox child) {
    final parentData = child.parentData as FlexParentData;
    return parentData.fit;
  }

  BoxConstraints _getConstraintsForFlexChild(
    BoxConstraints constraints,
    int maxExtent,
    FlexFit fit,
  ) {
    final bool isHorizontal = direction == Axis.horizontal;
    final int mainExtent = maxExtent;
    final int crossExtent =
        isHorizontal ? constraints.maxHeight : constraints.maxWidth;

    if (fit == FlexFit.tight) {
      return BoxConstraints.tightFor(
        width: isHorizontal ? mainExtent : crossExtent,
        height: isHorizontal ? crossExtent : mainExtent,
      );
    }
    return BoxConstraints(
      minWidth: 0,
      maxWidth: isHorizontal ? mainExtent : crossExtent,
      minHeight: 0,
      maxHeight: isHorizontal ? crossExtent : mainExtent,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }
}

class _FlexMeasurement {
  const _FlexMeasurement({required this.mainExtent, required this.crossExtent});
  final int mainExtent;
  final int crossExtent;
}
