import '../../../radartui.dart';

class Wrap extends MultiChildRenderObjectWidget {
  const Wrap({
    super.key,
    required super.children,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  final Axis direction;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final int spacing;
  final int runSpacing;

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

enum WrapCrossAlignment { start, end, center }

class WrapParentData extends ParentData {
  Offset offset = Offset.zero;
}

class _WrapRun {
  _WrapRun({
    required this.children,
    required this.mainExtent,
    required this.crossExtent,
  });
  final List<RenderBox> children;
  final int mainExtent;
  final int crossExtent;
}

class RenderWrap extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, WrapParentData> {
  RenderWrap({
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  Axis direction;
  WrapAlignment alignment;
  WrapCrossAlignment crossAxisAlignment;
  int spacing;
  int runSpacing;

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
    final mainAxisLimit =
        isHorizontal ? boxConstraints.maxWidth : boxConstraints.maxHeight;

    final runs = _buildRuns(isHorizontal, mainAxisLimit);
    final overall = _computeOverallDimensions(isHorizontal, runs);

    size = boxConstraints.constrain(
      Size(
        isHorizontal ? overall.mainAxisExtent : overall.crossAxisExtent,
        isHorizontal ? overall.crossAxisExtent : overall.mainAxisExtent,
      ),
    );

    _positionChildren(isHorizontal, runs);
  }

  List<_WrapRun> _buildRuns(bool isHorizontal, int mainAxisLimit) {
    final runs = <_WrapRun>[];
    List<RenderBox> currentRun = <RenderBox>[];
    int currentRunExtent = 0;
    int runMaxCrossExtent = 0;

    for (final child in children) {
      final childMainExtent =
          isHorizontal ? child.size!.width : child.size!.height;
      final childCrossExtent =
          isHorizontal ? child.size!.height : child.size!.width;
      final spacingToAdd = currentRun.isEmpty ? 0 : spacing;

      if (currentRunExtent + spacingToAdd + childMainExtent > mainAxisLimit &&
          currentRun.isNotEmpty) {
        runs.add(_computeRunExtent(isHorizontal, currentRun));
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
      runs.add(_computeRunExtent(isHorizontal, currentRun));
    }

    return runs;
  }

  _WrapRun _computeRunExtent(bool isHorizontal, List<RenderBox> run) {
    int runMainExtent = 0;
    int runCrossExtent = 0;

    for (final child in run) {
      final childMainExtent =
          isHorizontal ? child.size!.width : child.size!.height;
      final childCrossExtent =
          isHorizontal ? child.size!.height : child.size!.width;
      runMainExtent += childMainExtent;
      if (childCrossExtent > runCrossExtent) {
        runCrossExtent = childCrossExtent;
      }
    }

    if (run.length > 1) {
      runMainExtent += spacing * (run.length - 1);
    }

    return _WrapRun(
      children: run,
      mainExtent: runMainExtent,
      crossExtent: runCrossExtent,
    );
  }

  ({int mainAxisExtent, int crossAxisExtent}) _computeOverallDimensions(
    bool isHorizontal,
    List<_WrapRun> runs,
  ) {
    int totalCrossExtent = 0;
    int maxMainExtent = 0;

    for (final run in runs) {
      totalCrossExtent += run.crossExtent;
      if (run.mainExtent > maxMainExtent) {
        maxMainExtent = run.mainExtent;
      }
    }

    if (runs.length > 1) {
      totalCrossExtent += runSpacing * (runs.length - 1);
    }

    return (
      mainAxisExtent: isHorizontal ? maxMainExtent : totalCrossExtent,
      crossAxisExtent: isHorizontal ? totalCrossExtent : maxMainExtent,
    );
  }

  int _mainAxisOffsetForAlignment(int freeSpace, int childCount) {
    return switch (alignment) {
      WrapAlignment.start => 0,
      WrapAlignment.end => freeSpace,
      WrapAlignment.center => freeSpace ~/ 2,
      WrapAlignment.spaceAround => freeSpace ~/ (childCount * 2),
      WrapAlignment.spaceEvenly => freeSpace ~/ (childCount + 1),
      WrapAlignment.spaceBetween => 0,
    };
  }

  int _extraSpacingForAlignment(int freeSpace, int childCount) {
    if (alignment == WrapAlignment.spaceBetween && childCount > 1) {
      return freeSpace ~/ (childCount - 1);
    }
    return 0;
  }

  int _childCrossOffset(int runCrossExtent, int childCrossExtent) {
    return switch (crossAxisAlignment) {
      WrapCrossAlignment.start => 0,
      WrapCrossAlignment.end => runCrossExtent - childCrossExtent,
      WrapCrossAlignment.center => (runCrossExtent - childCrossExtent) ~/ 2,
    };
  }

  void _setChildOffset(
    RenderBox child,
    bool isHorizontal,
    int mainAxisOffset,
    int crossAxisOffset,
  ) {
    final parentData = child.parentData as WrapParentData;
    if (isHorizontal) {
      parentData.offset = Offset(mainAxisOffset, crossAxisOffset);
    } else {
      parentData.offset = Offset(crossAxisOffset, mainAxisOffset);
    }
  }

  void _positionChildren(bool isHorizontal, List<_WrapRun> runs) {
    final mainAxisLimit = isHorizontal ? size!.width : size!.height;

    int crossAxisOffset = 0;

    for (final run in runs) {
      final freeSpace = mainAxisLimit - run.mainExtent;
      final mainAxisStart = _mainAxisOffsetForAlignment(
        freeSpace,
        run.children.length,
      );
      final extraSpacing = _extraSpacingForAlignment(
        freeSpace,
        run.children.length,
      );

      int mainAxisOffset = mainAxisStart;

      for (final child in run.children) {
        final childMainExtent =
            isHorizontal ? child.size!.width : child.size!.height;
        final childCrossExtent =
            isHorizontal ? child.size!.height : child.size!.width;
        final childCrossOffset = _childCrossOffset(
          run.crossExtent,
          childCrossExtent,
        );

        _setChildOffset(
          child,
          isHorizontal,
          mainAxisOffset,
          crossAxisOffset + childCrossOffset,
        );
        mainAxisOffset += childMainExtent + spacing + extraSpacing;
      }

      crossAxisOffset += run.crossExtent + runSpacing;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final parentData = child.parentData as WrapParentData;
      context.paintChild(child, offset + parentData.offset);
    }
  }
}
