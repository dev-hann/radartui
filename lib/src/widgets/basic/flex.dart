import '../../../radartui.dart';

class Flex extends MultiChildRenderObjectWidget {
  const Flex({
    super.key,
    required super.children,
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
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

class RenderFlex extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, FlexParentData> {
  RenderFlex({
    required this.direction,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });
  Axis direction;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
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
    final totalFlex = _computeTotalFlex();
    final maxMainAxisExtent =
        isHorizontal ? boxConstraints.maxWidth : boxConstraints.maxHeight;
    final crossAxisExtent =
        isHorizontal ? boxConstraints.maxHeight : boxConstraints.maxWidth;

    final nonFlexResult = _measureNonFlexChildren(
      isHorizontal,
      boxConstraints,
    );
    final flexResult = _measureFlexChildren(
      isHorizontal,
      boxConstraints,
      totalFlex,
      maxMainAxisExtent - nonFlexResult.mainExtent,
      nonFlexResult.crossExtent,
    );

    final totalNonFlexExtent = nonFlexResult.mainExtent;
    final totalFlexExtent = flexResult.mainExtent;
    final maxCrossExtent = flexResult.crossExtent;

    size = _computeSize(
      isHorizontal,
      totalNonFlexExtent,
      totalFlexExtent,
      maxMainAxisExtent,
      crossAxisExtent,
      maxCrossExtent,
    );

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

  _FlexMeasurement _measureNonFlexChildren(
    bool isHorizontal,
    BoxConstraints boxConstraints,
  ) {
    int mainExtent = 0;
    int crossExtent = 0;
    for (final child in children) {
      if (_getFlex(child) != 0) continue;
      child.layout(_getConstraintsForNonFlexChild(boxConstraints));
      mainExtent += isHorizontal ? child.size!.width : child.size!.height;
      final childCross = isHorizontal ? child.size!.height : child.size!.width;
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
      final maxChildExtent = spacePerFlex * flex;
      child.layout(
        _getConstraintsForFlexChild(
          boxConstraints,
          maxChildExtent,
          _getFit(child),
        ),
      );
      allocatedSpace += isHorizontal ? child.size!.width : child.size!.height;
      final childCross = isHorizontal ? child.size!.height : child.size!.width;
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
      final childMainExtent =
          isHorizontal ? child.size!.width : child.size!.height;
      final childCrossExtent =
          isHorizontal ? child.size!.height : child.size!.width;

      final crossAxisPosition = _crossAxisPosition(
        actualCrossAxisExtent,
        childCrossExtent,
      );

      if (isHorizontal) {
        childParentData.offset = Offset(mainAxisPosition, crossAxisPosition);
      } else {
        childParentData.offset = Offset(crossAxisPosition, mainAxisPosition);
      }
      mainAxisPosition += childMainExtent + betweenSpace;
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

  BoxConstraints _getConstraintsForNonFlexChild(BoxConstraints constraints) {
    if (direction == Axis.horizontal) {
      return BoxConstraints(
        minWidth: 0,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: constraints.maxHeight,
      );
    } else {
      return BoxConstraints(
        minWidth: 0,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: constraints.maxHeight,
      );
    }
  }

  BoxConstraints _getConstraintsForFlexChild(
    BoxConstraints constraints,
    int maxExtent,
    FlexFit fit,
  ) {
    if (direction == Axis.horizontal) {
      if (fit == FlexFit.tight) {
        return BoxConstraints.tightFor(
          width: maxExtent,
          height: constraints.maxHeight,
        );
      } else {
        return BoxConstraints(
          minWidth: 0,
          maxWidth: maxExtent,
          minHeight: 0,
          maxHeight: constraints.maxHeight,
        );
      }
    } else {
      if (fit == FlexFit.tight) {
        return BoxConstraints.tightFor(
          width: constraints.maxWidth,
          height: maxExtent,
        );
      } else {
        return BoxConstraints(
          minWidth: 0,
          maxWidth: constraints.maxWidth,
          minHeight: 0,
          maxHeight: maxExtent,
        );
      }
    }
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
  const _FlexMeasurement({
    required this.mainExtent,
    required this.crossExtent,
  });
  final int mainExtent;
  final int crossExtent;
}
