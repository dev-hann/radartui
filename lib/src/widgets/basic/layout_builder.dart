import '../../../radartui.dart';

typedef LayoutWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints);

class LayoutBuilder extends StatelessWidget {
  const LayoutBuilder({super.key, required this.builder});

  final LayoutWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return _LayoutBuilderWidget(builder: builder);
  }
}

class _LayoutBuilderWidget extends SingleChildRenderObjectWidget {
  const _LayoutBuilderWidget({required this.builder});

  final LayoutWidgetBuilder builder;

  @override
  RenderLayoutBuilder createRenderObject(BuildContext context) =>
      RenderLayoutBuilder(builder: builder, buildContext: context);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final ro = renderObject as RenderLayoutBuilder;
    ro
      ..builder = builder
      ..buildContext = context;
  }
}

class RenderLayoutBuilder extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderLayoutBuilder({required this.builder, required this.buildContext});

  LayoutWidgetBuilder builder;
  BuildContext buildContext;
  Element? _childElement;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final childWidget = builder(buildContext, boxConstraints);

    _childElement?.unmount();
    _childElement = childWidget.createElement()..mount(null);

    final childRender = _childElement?.renderObject;
    if (childRender != null) {
      childRender.layout(constraints, parentUsesSize: true);
      size = childRender.size ?? Size.zero;
      child = childRender as RenderBox;
    } else {
      size = Size.zero;
      child = null;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
