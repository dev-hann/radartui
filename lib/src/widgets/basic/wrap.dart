import '../../../radartui.dart';

class Wrap extends MultiChildRenderObjectWidget {
  final Axis direction;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final int spacing;
  final int runSpacing;
  
  const Wrap({
    super.key,
    required super.children,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
  });
  
  @override
  RenderWrap createRenderObject(BuildContext context) => RenderWrap(
    direction: direction,
    alignment: alignment,
    crossAxisAlignment: crossAxisAlignment,
    spacing: spacing,
    runSpacing: runSpacing,
  );
  
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderWrap = renderObject as RenderWrap;
    renderWrap.direction = direction;
    renderWrap.alignment = alignment;
    renderWrap.crossAxisAlignment = crossAxisAlignment;
    renderWrap.spacing = spacing;
    renderWrap.runSpacing = runSpacing;
  }
}

enum WrapAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum WrapCrossAlignment {
  start,
  end,
  center,
}

class WrapParentData extends ParentData {
  Offset offset = Offset.zero;
}

class RenderWrap extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, WrapParentData> {
  
  Axis direction;
  WrapAlignment alignment;
  WrapCrossAlignment crossAxisAlignment;
  int spacing;
  int runSpacing;
  
  RenderWrap({
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
  });
  
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! WrapParentData) {
      child.parentData = WrapParentData();
    }
  }
  
  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    
    for (final child in children) {
      setupParentData(child);
      child.layout(boxConstraints.loosen());
    }
    
    if (children.isEmpty) {
      size = boxConstraints.constrain(const Size(0, 0));
      return;
    }
    
    final isHorizontal = direction == Axis.horizontal;
    final mainAxisLimit = isHorizontal ? boxConstraints.maxWidth : boxConstraints.maxHeight;
    
    final runs = <List<RenderBox>>[];
    var currentRun = <RenderBox>[];
    int currentRunExtent = 0;
    int runMaxCrossExtent = 0;
    
    for (final child in children) {
      final childMainExtent = isHorizontal ? child.size!.width : child.size!.height;
      final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
      
      final spacingToAdd = currentRun.isEmpty ? 0 : spacing;
      
      if (currentRunExtent + spacingToAdd + childMainExtent > mainAxisLimit && currentRun.isNotEmpty) {
        runs.add(currentRun);
        currentRun = <RenderBox>[];
        currentRunExtent = 0;
        runMaxCrossExtent = 0;
      }
      
      currentRun.add(child);
      currentRunExtent += spacingToAdd + childMainExtent;
      if (childCrossExtent > runMaxCrossExtent) {
        runMaxCrossExtent = childCrossExtent;
      }
    }
    
    if (currentRun.isNotEmpty) {
      runs.add(currentRun);
    }
    
    int totalCrossExtent = 0;
    final runCrossExtents = <int>[];
    final runMainExtents = <int>[];
    
    for (final run in runs) {
      int runMainExtent = 0;
      int runCrossExtent = 0;
      
      for (final child in run) {
        final childMainExtent = isHorizontal ? child.size!.width : child.size!.height;
        final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
        
        runMainExtent += childMainExtent;
        if (childCrossExtent > runCrossExtent) {
          runCrossExtent = childCrossExtent;
        }
      }
      
      if (run.length > 1) {
        runMainExtent += spacing * (run.length - 1);
      }
      
      runMainExtents.add(runMainExtent);
      runCrossExtents.add(runCrossExtent);
      totalCrossExtent += runCrossExtent;
    }
    
    if (runs.length > 1) {
      totalCrossExtent += runSpacing * (runs.length - 1);
    }
    
    final mainAxisExtent = isHorizontal 
        ? runMainExtents.fold<int>(0, (max, extent) => extent > max ? extent : max)
        : totalCrossExtent;
    final crossAxisExtent = isHorizontal
        ? totalCrossExtent
        : runMainExtents.fold<int>(0, (max, extent) => extent > max ? extent : max);
    
    int crossAxisOffset = 0;
    
    for (int runIndex = 0; runIndex < runs.length; runIndex++) {
      final run = runs[runIndex];
      final runMainExtent = runMainExtents[runIndex];
      final runCrossExtent = runCrossExtents[runIndex];
      
      int mainAxisOffset = 0;
      
      final freeMainSpace = mainAxisLimit - runMainExtent;
      switch (alignment) {
        case WrapAlignment.start:
          mainAxisOffset = 0;
          break;
        case WrapAlignment.end:
          mainAxisOffset = freeMainSpace;
          break;
        case WrapAlignment.center:
          mainAxisOffset = freeMainSpace ~/ 2;
          break;
        case WrapAlignment.spaceBetween:
          if (run.length > 1) {
            final extraSpacing = freeMainSpace ~/ (run.length - 1);
            for (int i = 0; i < run.length; i++) {
              final child = run[i];
              final childMainExtent = isHorizontal ? child.size!.width : child.size!.height;
              final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
              
              int childCrossOffset;
              switch (crossAxisAlignment) {
                case WrapCrossAlignment.start:
                  childCrossOffset = 0;
                  break;
                case WrapCrossAlignment.end:
                  childCrossOffset = runCrossExtent - childCrossExtent;
                  break;
                case WrapCrossAlignment.center:
                  childCrossOffset = (runCrossExtent - childCrossExtent) ~/ 2;
                  break;
              }
              
              final parentData = child.parentData as WrapParentData;
              if (isHorizontal) {
                parentData.offset = Offset(mainAxisOffset, crossAxisOffset + childCrossOffset);
              } else {
                parentData.offset = Offset(crossAxisOffset + childCrossOffset, mainAxisOffset);
              }
              
              mainAxisOffset += childMainExtent + spacing + extraSpacing;
            }
            crossAxisOffset += runCrossExtent + runSpacing;
            continue;
          }
          break;
        case WrapAlignment.spaceAround:
          mainAxisOffset = freeMainSpace ~/ (run.length * 2);
          break;
        case WrapAlignment.spaceEvenly:
          mainAxisOffset = freeMainSpace ~/ (run.length + 1);
          break;
      }
      
      for (int i = 0; i < run.length; i++) {
        final child = run[i];
        final childMainExtent = isHorizontal ? child.size!.width : child.size!.height;
        final childCrossExtent = isHorizontal ? child.size!.height : child.size!.width;
        
        int childCrossOffset;
        switch (crossAxisAlignment) {
          case WrapCrossAlignment.start:
            childCrossOffset = 0;
            break;
          case WrapCrossAlignment.end:
            childCrossOffset = runCrossExtent - childCrossExtent;
            break;
          case WrapCrossAlignment.center:
            childCrossOffset = (runCrossExtent - childCrossExtent) ~/ 2;
            break;
        }
        
        final parentData = child.parentData as WrapParentData;
        if (isHorizontal) {
          parentData.offset = Offset(mainAxisOffset, crossAxisOffset + childCrossOffset);
        } else {
          parentData.offset = Offset(crossAxisOffset + childCrossOffset, mainAxisOffset);
        }
        
        mainAxisOffset += childMainExtent + spacing;
      }
      
      crossAxisOffset += runCrossExtent + runSpacing;
    }
    
    size = boxConstraints.constrain(Size(
      isHorizontal ? mainAxisExtent : crossAxisExtent,
      isHorizontal ? crossAxisExtent : mainAxisExtent,
    ));
  }
  
  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final parentData = child.parentData as WrapParentData;
      context.paintChild(child, offset + parentData.offset);
    }
  }
}
