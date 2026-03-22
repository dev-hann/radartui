import '../../../radartui.dart';

class Row extends Flex {
  const Row({
    super.key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) : super(
           children: children,
           direction: Axis.horizontal,
           mainAxisAlignment: mainAxisAlignment,
           crossAxisAlignment: crossAxisAlignment,
           mainAxisSize: mainAxisSize,
         );
}

class Column extends Flex {
  const Column({
    super.key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) : super(
           children: children,
           direction: Axis.vertical,
           mainAxisAlignment: mainAxisAlignment,
           crossAxisAlignment: crossAxisAlignment,
           mainAxisSize: mainAxisSize,
         );
}

abstract class Flexible extends ParentDataWidget<FlexParentData> {
  final int flex;
  final FlexFit fit;

  const Flexible({
    super.key,
    required super.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as FlexParentData;
    if (parentData.flex != flex || parentData.fit != fit) {
      parentData.flex = flex;
      parentData.fit = fit;
      renderObject.markNeedsLayout();
    }
  }
}

class Expanded extends Flexible {
  const Expanded({
    super.key,
    required super.child,
    int flex = 1,
  }) : super(flex: flex, fit: FlexFit.tight);
}