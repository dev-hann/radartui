import '../../../radartui.dart';

class IndexedStack extends MultiChildRenderObjectWidget {
  const IndexedStack({this.index = 0, required super.children});

  final int index;

  @override
  RenderIndexedStack createRenderObject(BuildContext context) {
    return RenderIndexedStack(index: index);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderIndexedStack).index = index;
  }
}

class RenderIndexedStack extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, StackParentData> {
  RenderIndexedStack({int index = 0}) : _index = index;

  int _index;

  int get index => _index;
  set index(int value) {
    if (_index != value) {
      _index = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;

    int maxWidth = 0;
    int maxHeight = 0;

    for (final child in children) {
      setupParentData(child);
      child.layout(boxConstraints.loosen());
      if (child.size!.width > maxWidth) maxWidth = child.size!.width;
      if (child.size!.height > maxHeight) maxHeight = child.size!.height;
    }

    size = boxConstraints.constrain(Size(maxWidth, maxHeight));

    for (final child in children) {
      final childParentData = child.parentData as StackParentData;
      childParentData.offset = Offset.zero;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (children.isEmpty) return;
    final validIndex = index.clamp(0, children.length - 1);
    final child = children[validIndex];
    final childParentData = child.parentData as StackParentData;
    context.paintChild(child, offset + childParentData.offset);
  }
}
