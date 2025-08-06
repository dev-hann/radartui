import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/key.dart' as input_key;
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

import 'package:radartui/widget/focus_manager.dart';

abstract class BuildContext {
  Widget get widget;
  Element? get parent;
  void markNeedsBuild();
}

abstract class Element implements BuildContext {
  @override
  final Widget widget;
  Element? _parent;
  bool _needsBuild = false;
  String? focusID;

  Element(this.widget);

  @override
  Element? get parent => _parent;

  void _setParent(Element? parent) {
    _parent = parent;
  }
  
  void setParent(Element? parent) {
    _parent = parent;
  }

  @override
  void markNeedsBuild() {
    if (_needsBuild) return;
    _needsBuild = true;
    // In a real implementation, this would schedule a rebuild
    // For now, we'll rebuild immediately
    if (this is StatefulElement) {
      (this as StatefulElement).rebuild();
    }
  }

  void mount(Element? parent) {
    _parent = parent;
    if (widget.key != null) {
      focusID = widget.key!.value;
      FocusManager.instance.registerFocus(focusID!, this);
    }
  }

  void onKey(input_key.Key key);

  void render(Canvas canvas, Rect rect);

  void unmount() {
    if (focusID != null) {
      FocusManager.instance.unregisterFocus(focusID!);
    }
  }
  void update(covariant Widget newWidget);
}

class RenderObjectElement extends Element {
  late RenderObject renderObject;

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
  void onKey(input_key.Key key) {}

  @override
  void unmount() {}
}

class StatefulElement extends Element {
  late final State state;
  Element? _child;

  StatefulElement(StatefulWidget widget) : super(widget) {
    state = widget.createState();
    state.widget = widget;
    state.setElement(this);
  }

  Widget build() => state.build(this);

  void rebuild() {
    _needsBuild = false;
    final newWidget = build();
    if (_child == null) {
      _child = newWidget.createElement();
      _child!.mount(this);
    } else {
      _child!.update(newWidget);
    }
  }

  @override
  void mount() {
    super.mount();
    state.initState();
    rebuild();
  }

  @override
  void render(Canvas canvas, Rect rect) {
    _child?.render(canvas, rect);
  }

  @override
  void onKey(input_key.Key key) {
    // Key events are now handled by FocusManager
  }

  @override
  void update(Widget newWidget) {
    if (widget.runtimeType != newWidget.runtimeType) {
      throw Exception("Can't update widget with different type");
    }
    final oldWidget = state.widget;
    state.widget = newWidget as StatefulWidget;
    state.didUpdateWidget(oldWidget);
    rebuild();
  }

  @override
  void unmount() {
    state.dispose();
    _child?.unmount();
  }
}

class StatelessElement extends Element {
  StatelessElement(StatelessWidget super.widget);

  late Element _childElement;

  Widget build() {
    return (widget as StatelessWidget).build(this);
  }

  @override
  void mount() {
    super.mount();
    final built = build();
    _childElement = built.createElement();
    _childElement._setParent(this);
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
  void onKey(input_key.Key key) {
    // Key events are now handled by FocusManager
  }

  @override
  void unmount() {
    _childElement.unmount();
  }

  @override
  void update(Widget newWidget) {
    if (widget.runtimeType != newWidget.runtimeType) {
      throw Exception("Can't update widget with different type");
    }
    
    // Check if we need to rebuild
    if (widget.shouldUpdate(newWidget)) {
      // Create a new element with the new widget
      final newElement = newWidget.createElement();
      newElement._setParent(_parent);
      newElement.mount();
      
      // Replace the child element
      _childElement.unmount();
      _childElement = newElement;
    }
  }
}
