import '../rendering.dart';
import '../scheduler.dart';

abstract class Widget {
  const Widget();
  Element createElement();
}

abstract class Element {
  Element(this.widget);
  Widget widget;
  RenderObject? _renderObject;
  RenderObject? get renderObject => _renderObject;
  bool dirty = true;
  Element? _parent;

  void mount(Element? parent) {
    _parent = parent;
  }
  
  void update(Widget newWidget) => widget = newWidget;
  void unmount() {}
  void visitChildren(void Function(Element e) visitor) {}

  void markNeedsBuild() {
    if (dirty) return;
    dirty = true;
    SchedulerBinding.instance.scheduleFrame();
  }

  Element? updateChild(Element? child, Widget newWidget) {
    if (child != null && child.widget.runtimeType == newWidget.runtimeType) {
      child.update(newWidget);
      return child;
    } else {
      final newChild = newWidget.createElement();
      newChild.mount(this);
      return newChild;
    }
  }

  T? findAncestorWidgetOfExactType<T extends Widget>() {
    Element? current = _parent;
    while (current != null) {
      if (current.widget.runtimeType == T) {
        return current.widget as T;
      }
      current = current._parent;
    }
    return null;
  }
}

abstract class BuildContext {
  T? findAncestorWidgetOfExactType<T extends Widget>();
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget();
  @override
  StatelessElement createElement() => StatelessElement(this);
  Widget build(BuildContext context);
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget();
  @override
  StatefulElement createElement() => StatefulElement(this);
  State createState();
}

abstract class State<T extends StatefulWidget> {
  T get widget => _widget!;
  T? _widget;
  StatefulElement? _element;
  
  BuildContext get context => _element!;

  void initState() {}

  void didUpdateWidget(T oldWidget) {}

  void dispose() {}

  void setState(void Function() fn) {
    fn();
    _element?.markNeedsBuild();
  }

  Widget build(BuildContext context);
}

class StatelessElement extends ComponentElement {
  StatelessElement(StatelessWidget super.widget);
  @override
  Widget build() => (widget as StatelessWidget).build(this);
}

class StatefulElement extends ComponentElement {
  StatefulElement(StatefulWidget super.widget) {
    _state = (widget as StatefulWidget).createState();
    _state._widget = widget as StatefulWidget;
    _state._element = this;
  }
  late final State _state;
  @override
  Widget build() => _state.build(this);
  @override
  void mount(Element? parent) {
    _state.initState();
    super.mount(parent);
  }

  @override
  void update(Widget newWidget) {
    final oldWidget = widget;
    super.update(newWidget);
    _state._widget = newWidget as StatefulWidget;
    _state.didUpdateWidget(oldWidget as StatefulWidget);
  }
}

abstract class ComponentElement extends Element implements BuildContext {
  ComponentElement(super.widget);
  Element? _child;
  
  @override
  void mount(Element? parent) {
    super.mount(parent);
    rebuild();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    rebuild();
  }

  void rebuild() => _child = updateChild(_child, build());

  @override
  RenderObject? get renderObject => _child?.renderObject;
  @override
  void visitChildren(void Function(Element e) visitor) {
    if (_child != null) visitor(_child!);
  }

  Widget build();
}

abstract class RenderObjectWidget extends Widget {
  const RenderObjectWidget();
  @override
  RenderObjectElement createElement();
  RenderObject createRenderObject(BuildContext context);
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}
}

class RenderObjectElement extends Element implements BuildContext {
  RenderObjectElement(RenderObjectWidget super.widget);
  
  @override
  void mount(Element? parent) {
    super.mount(parent);
    _renderObject = (widget as RenderObjectWidget).createRenderObject(this);
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    (widget as RenderObjectWidget).updateRenderObject(this, renderObject!);
    renderObject!.markNeedsLayout();
  }
}

abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {
  final Widget? child;
  const SingleChildRenderObjectWidget({this.child});
  @override
  SingleChildRenderObjectElement createElement() =>
      SingleChildRenderObjectElement(this);
}

class SingleChildRenderObjectElement extends RenderObjectElement {
  SingleChildRenderObjectElement(SingleChildRenderObjectWidget super.widget);
  Element? _child;
  
  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = (widget as SingleChildRenderObjectWidget).child;
    if (childWidget != null) {
      _child = updateChild(null, childWidget);
      if (_child?.renderObject != null) {
        (renderObject as ContainerRenderObjectMixin).add(_child!.renderObject!);
      }
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final oldChild = _child;
    final childWidget = (widget as SingleChildRenderObjectWidget).child;
    if (childWidget != null) {
      _child = updateChild(_child, childWidget);
      if (oldChild != _child && _child?.renderObject != null) {
        final container = renderObject as ContainerRenderObjectMixin;
        if (oldChild?.renderObject != null) {
          container.clear();
        }
        container.add(_child!.renderObject!);
      }
    } else if (oldChild != null) {
      _child = null;
      (renderObject as ContainerRenderObjectMixin).clear();
    }
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    if (_child != null) visitor(_child!);
  }
}

abstract class MultiChildRenderObjectWidget extends RenderObjectWidget {
  final List<Widget> children;
  const MultiChildRenderObjectWidget({required this.children});
  @override
  MultiChildRenderObjectElement createElement() =>
      MultiChildRenderObjectElement(this);
}

class MultiChildRenderObjectElement extends RenderObjectElement {
  MultiChildRenderObjectElement(MultiChildRenderObjectWidget super.widget);
  List<Element> _children = [];
  
  @override
  void mount(Element? parent) {
    super.mount(parent);
    var renderObject = this.renderObject
        as ContainerRenderObjectMixin<RenderObject, ParentData>;
    _children = (widget as MultiChildRenderObjectWidget).children.map((w) {
      final child = w.createElement();
      child.mount(this);
      if (child.renderObject != null) {
        child.renderObject!.parentData = FlexParentData();
        renderObject.add(child.renderObject!);
      }
      return child;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newChildren = (newWidget as MultiChildRenderObjectWidget).children;
    for (int i = 0; i < newChildren.length && i < _children.length; i++) {
      _children[i] = updateChild(_children[i], newChildren[i])!;
    }
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    for (final c in _children) visitor(c);
  }
}
