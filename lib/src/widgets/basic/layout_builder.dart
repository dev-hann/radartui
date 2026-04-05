import '../../../radartui.dart';

/// Signature for a function that builds a widget tree given [BoxConstraints].
typedef LayoutWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints);

/// Builds its child widget tree based on the parent's [BoxConstraints].
///
/// The [builder] callback receives the current constraints and returns a
/// widget. Useful for widgets that need to know their available size before
/// choosing how to render.
class LayoutBuilder extends StatelessWidget {
  /// Creates a [LayoutBuilder] with the given [builder] callback.
  const LayoutBuilder({super.key, required this.builder});

  /// Called at layout time with the current [BoxConstraints].
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

/// The render object for [LayoutBuilder], which invokes a builder callback
/// with the parent's [BoxConstraints] during layout.
class RenderLayoutBuilder extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  /// Creates a [RenderLayoutBuilder] with the given [builder] and [buildContext].
  RenderLayoutBuilder({required this.builder, required this.buildContext});

  /// The builder callback invoked during layout.
  LayoutWidgetBuilder builder;

  /// The build context passed to the builder.
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
