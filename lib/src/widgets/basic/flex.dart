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
    
    int totalFlex = 0;
    int nonFlexExtent = 0;
    int maxCrossAxisExtent = 0;
    
    for (final child in children) {
      final flex = _getFlex(child);
      if (flex > 0) {
        totalFlex += flex;
      }
    }
    
    final maxMainAxisExtent = isHorizontal ? boxConstraints.maxWidth : boxConstraints.maxHeight;
    final crossAxisExtent = isHorizontal ? boxConstraints.maxHeight : boxConstraints.maxWidth;
    
    final nonFlexChildren = <RenderBox>[];
    for (final child in children) {
      final flex = _getFlex(child);
      if (flex == 0) {
        nonFlexChildren.add(child);
      }
    }
    
    for (final child in nonFlexChildren) {
      final innerConstraints = _getConstraintsForNonFlexChild(boxConstraints);
      child.layout(innerConstraints);
      final childExtent = isHorizontal ? child.size!.width : child.size!.height;
      nonFlexExtent += childExtent;
      final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
      if (childCrossExtent > maxCrossAxisExtent) {
        maxCrossAxisExtent = childCrossExtent;
      }
    }
    
    final freeSpace = maxMainAxisExtent - nonFlexExtent;
    final spacePerFlex = totalFlex > 0 ? freeSpace ~/ totalFlex : 0;
    int allocatedFlexSpace = 0;
    
    for (final child in children) {
      final flex = _getFlex(child);
      if (flex > 0) {
        final maxChildExtent = spacePerFlex * flex;
        final innerConstraints = _getConstraintsForFlexChild(boxConstraints, maxChildExtent, _getFit(child));
        child.layout(innerConstraints);
        final childExtent = isHorizontal ? child.size!.width : child.size!.height;
        allocatedFlexSpace += childExtent;
        final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
        if (childCrossExtent > maxCrossAxisExtent) {
          maxCrossAxisExtent = childCrossExtent;
        }
      }
    }
    
    int totalMainAxisExtent = nonFlexExtent + allocatedFlexSpace;
    
    if (mainAxisSize == MainAxisSize.max) {
      totalMainAxisExtent = maxMainAxisExtent;
    }
    
    final effectiveCrossAxisExtent = crossAxisExtent < 0 ? 0 : crossAxisExtent;
    final actualSize = isHorizontal
        ? Size(totalMainAxisExtent, maxCrossAxisExtent.clamp(0, effectiveCrossAxisExtent))
        : Size(maxCrossAxisExtent.clamp(0, effectiveCrossAxisExtent), totalMainAxisExtent);
    
    final actualCrossAxisExtent = isHorizontal ? actualSize.height : actualSize.width;
    final actualMainAxisExtent = isHorizontal ? actualSize.width : actualSize.height;
    
    int leadingSpace = 0;
    int betweenSpace = 0;
    final freeMainAxisSpace = actualMainAxisExtent - nonFlexExtent - allocatedFlexSpace;
    
    switch (mainAxisAlignment) {
      case MainAxisAlignment.start:
        break;
      case MainAxisAlignment.end:
        leadingSpace = freeMainAxisSpace;
        break;
      case MainAxisAlignment.center:
        leadingSpace = freeMainAxisSpace ~/ 2;
        break;
      case MainAxisAlignment.spaceBetween:
        if (children.length > 1) {
          betweenSpace = freeMainAxisSpace ~/ (children.length - 1);
        }
        break;
      case MainAxisAlignment.spaceAround:
        if (children.isNotEmpty) {
          betweenSpace = freeMainAxisSpace ~/ children.length;
          leadingSpace = betweenSpace ~/ 2;
        }
        break;
      case MainAxisAlignment.spaceEvenly:
        if (children.isNotEmpty) {
          betweenSpace = freeMainAxisSpace ~/ (children.length + 1);
          leadingSpace = betweenSpace;
        }
        break;
    }
    
    int mainAxisPosition = leadingSpace;
    for (final child in children) {
      final childParentData = child.parentData as FlexParentData;
      final childMainExtent = isHorizontal ? child.size!.width : child.size!.height;
      final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
      
      int crossAxisPosition;
      switch (crossAxisAlignment) {
        case CrossAxisAlignment.start:
          crossAxisPosition = 0;
          break;
        case CrossAxisAlignment.end:
          crossAxisPosition = actualCrossAxisExtent - childCrossExtent;
          break;
        case CrossAxisAlignment.center:
          crossAxisPosition = (actualCrossAxisExtent - childCrossExtent) ~/ 2;
          break;
        case CrossAxisAlignment.stretch:
          crossAxisPosition = 0;
          break;
      }
      
      if (isHorizontal) {
        childParentData.offset = Offset(mainAxisPosition, crossAxisPosition);
      } else {
        childParentData.offset = Offset(crossAxisPosition, mainAxisPosition);
      }
      
      mainAxisPosition += childMainExtent + betweenSpace;
    }
    
    size = actualSize;
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

  BoxConstraints _getConstraintsForFlexChild(BoxConstraints constraints, int maxExtent, FlexFit fit) {
    if (direction == Axis.horizontal) {
      if (fit == FlexFit.tight) {
        return BoxConstraints.tightFor(width: maxExtent, height: constraints.maxHeight);
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
        return BoxConstraints.tightFor(width: constraints.maxWidth, height: maxExtent);
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
