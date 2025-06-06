import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

abstract class Element {
  final Widget widget;
  late RenderObject renderObject;

  Element(this.widget);

  void mount() {}

  void onKey(Key key);

  void render(Canvas canvas, Rect rect) {
    renderObject.layout(rect);
    renderObject.paint(canvas);
  }

  void unmount();
  void update(covariant Widget newWidget);
}

class RenderObjectElement extends Element {
  RenderObjectElement(super.widget);

  @override
  void mount() {
    renderObject = (widget as RenderObjectWidget).createRenderObject();
  }

  @override
  void update(covariant Widget newWidget) {
    if (widget.runtimeType != newWidget.runtimeType) {
      throw Exception("Widget type mismatch");
    }
    final renderWidget = newWidget as RenderObjectWidget;
    renderWidget.updateRenderObject(renderObject);
  }

  @override
  void render(Canvas canvas, Rect rect) {
    renderObject.layout(rect);
    renderObject.paint(canvas);
  }

  @override
  void onKey(Key key) {}

  @override
  void unmount() {}
}

class StatefulElement extends Element {
  late final State state;
  Element? _child;

  StatefulElement(StatefulWidget widget) : super(widget) {
    state = widget.createState();
    state.widget = widget;
  }

  Widget build() => state.build();

  void rebuild() {
    final newWidget = build();
    if (_child == null) {
      _child = newWidget.createElement();
      _child!.mount();
    } else {
      _child!.update(newWidget);
    }
  }

  @override
  void mount() {
    state.initState();
    rebuild();
  }

  @override
  void render(Canvas canvas, Rect rect) {
    _child?.render(canvas, rect);
  }

  @override
  void onKey(Key key) {
    _child?.onKey(key);
  }

  @override
  void update(Widget newWidget) {
    if (widget.runtimeType != newWidget.runtimeType) {
      throw Exception("Can't update widget with different type");
    }
    state.widget = newWidget as StatefulWidget;
    rebuild();
  }

  @override
  void unmount() {
    _child?.unmount();
  }
}

class StatelessElement extends Element {
  StatelessElement(StatelessWidget super.widget);

  late Element _childElement;

  Widget build() {
    return (widget as StatelessWidget).build();
  }

  @override
  void mount() {
    final built = build();
    _childElement = built.createElement();
    _childElement.mount();
  }

  void rebuild() {
    final newWidget = build();
    if (!_childElement.widget.shouldUpdate(newWidget)) return;
    _childElement.update(newWidget);
  }

  @override
  void render(Canvas canvas, Rect rect) {
    _childElement.render(canvas, rect);
  }

  @override
  void onKey(Key key) {
    _childElement.onKey(key);
  }

  @override
  void unmount() {
    _childElement.unmount();
  }

  @override
  void update(Widget newWidget) {
    widget == newWidget ? rebuild() : null;
  }
}
