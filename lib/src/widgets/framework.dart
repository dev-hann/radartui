import '../rendering.dart';
import '../scheduler.dart';

abstract class Key {
  const Key();
  const Key.empty();
  const factory Key.value(String value) = ValueKey<String>;
}

abstract class LocalKey extends Key {
  const LocalKey();
}

class ValueKey<T> extends LocalKey {
  final T value;
  const ValueKey(this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueKey<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;
  @override
  int get hashCode => Object.hash(runtimeType, value);
  @override
  String toString() => "ValueKey<$T>($value)";
}

class GlobalKey extends Key {
  Element? _currentElement;
  Widget? get currentWidget => _currentElement?.widget;
  Element? get currentElement => _currentElement;
  void _register(Element element) {
    _currentElement = element;
  }
  void _unregister(Element element) {
    if (_currentElement == element) {
      _currentElement = null;
    }
  }
  @override
  String toString() => 'GlobalKey#${hashCode.toRadixString(16)}';
}

class UniqueKey extends LocalKey {
  const UniqueKey();
  @override
  bool operator ==(Object other) => identical(this, other);
  @override
  int get hashCode => identityHashCode(this);
  @override
  String toString() => 'UniqueKey#${hashCode.toRadixString(16)}';
}

abstract class Widget {
  final Key? key;
  const Widget({this.key});
  Element createElement();
  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key;
  }
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
    if (widget.key case GlobalKey key) {
      key._register(this);
    }
  }
  
  void update(Widget newWidget) {
    if (widget.key != newWidget.key) {
      if (widget.key case GlobalKey key) {
        key._unregister(this);
      }
      if (newWidget.key case GlobalKey key) {
        key._register(this);
      }
    }
    widget = newWidget;
  }
  void unmount() {
    if (widget.key case GlobalKey key) {
      key._unregister(this);
    }
    _clearDependencies();
  }
  
  void _clearDependencies() {
    if (_dependencies != null) {
      for (final inherited in _dependencies!) {
        inherited._dependents.remove(this);
      }
      _dependencies = null;
    }
  }
  void visitChildren(void Function(Element e) visitor) {}

  void markNeedsBuild() {
    if (dirty) return;
    dirty = true;
    SchedulerBinding.instance.scheduleFrame();
  }

  Element? updateChild(Element? child, Widget newWidget) {
    if (child != null && Widget.canUpdate(child.widget, newWidget)) {
      child.update(newWidget);
      return child;
    }
    if (child != null) {
      child.unmount();
    }
    final newChild = newWidget.createElement();
    newChild.mount(this);
    return newChild;
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

  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() {
    final element = findAncestorElementOfExactType<T>();
    if (element != null) {
      _dependencies ??= {};
      element._dependents.add(this);
      _dependencies!.add(element);
      return element.widget as T;
    }
    return null;
  }

  InheritedElement? findAncestorElementOfExactType<T extends InheritedWidget>() {
    Element? current = _parent;
    while (current != null) {
      if (current.widget is T && current is InheritedElement) {
        return current;
      }
      current = current._parent;
    }
    return null;
  }

  Set<InheritedElement>? _dependencies;
}

abstract class BuildContext {
  T? findAncestorWidgetOfExactType<T extends Widget>();
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();
  InheritedElement? findAncestorElementOfExactType<T extends InheritedWidget>();
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
  @override
  StatelessElement createElement() => StatelessElement(this);
  Widget build(BuildContext context);
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key});
  @override
  StatefulElement createElement() => StatefulElement(this);
  State createState();
}

abstract class State<T extends StatefulWidget> {
  T get widget => _widget!;
  T? _widget;
  StatefulElement? _element;

  BuildContext get context => _element!;

  bool get mounted => _element != null;

  void initState() {}

  void didUpdateWidget(T oldWidget) {}

  void dispose() {}

  void setState(void Function() fn) {
    try {
      fn();
      _element?.markNeedsBuild();
    } on Exception catch (e) {
      assert(() {
        throw StateError('setState() callback failed: $e');
      }());
    }
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
  late final State<StatefulWidget> _state;
  State<StatefulWidget> get state => _state;
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

  @override
  void unmount() {
    _state.dispose();
    super.unmount();
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

abstract class InheritedWidget extends Widget {
  final Widget child;
  const InheritedWidget({super.key, required this.child});
  @override
  InheritedElement createElement() => InheritedElement(this);
  bool updateShouldNotify(covariant InheritedWidget oldWidget);
}

class InheritedElement extends ComponentElement {
  final Set<Element> _dependents = {};
  InheritedElement(InheritedWidget super.widget);
  
  @override
  void unmount() {
    for (final dependent in _dependents) {
      dependent._dependencies?.remove(this);
    }
    _dependents.clear();
    super.unmount();
  }
  
  @override
  Widget build() => (widget as InheritedWidget).child;
  @override
  void update(Widget newWidget) {
    final oldWidget = widget;
    super.update(newWidget);
    if ((oldWidget as InheritedWidget).updateShouldNotify(newWidget as InheritedWidget)) {
      for (final dependent in _dependents) {
        dependent.markNeedsBuild();
      }
    }
    rebuild();
  }
}

abstract class ParentDataWidget<T extends ParentData> extends Widget {
  final Widget child;
  const ParentDataWidget({super.key, required this.child});
  void applyParentData(RenderObject renderObject);
  @override
  ParentDataElement createElement() => ParentDataElement(this);
}

class ParentDataElement extends ComponentElement {
  ParentDataElement(ParentDataWidget super.widget);
  Element? _child;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = (widget as ParentDataWidget).child;
    _child = updateChild(null, childWidget);
    _applyParentData();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final childWidget = (widget as ParentDataWidget).child;
    _child = updateChild(_child, childWidget);
    _applyParentData();
  }

  void _applyParentData() {
    final ro = _child?.renderObject;
    if (ro != null) {
      (widget as ParentDataWidget).applyParentData(ro);
    }
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    if (_child != null) visitor(_child!);
  }

  @override
  Widget build() => (widget as ParentDataWidget).child;

  @override
  RenderObject? get renderObject => _child?.renderObject;
}

abstract class RenderObjectWidget extends Widget {
  const RenderObjectWidget({super.key});
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
  const SingleChildRenderObjectWidget({super.key, this.child});
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
        (renderObject as RenderObjectWithChildMixin<RenderObject>).child = _child!.renderObject!;
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
        final container = renderObject as RenderObjectWithChildMixin<RenderObject>;
        container.child = _child!.renderObject!;
      }
    } else if (oldChild != null) {
      _child = null;
      (renderObject as RenderObjectWithChildMixin<RenderObject>).child = null;
    }
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    if (_child != null) visitor(_child!);
  }
}

abstract class MultiChildRenderObjectWidget extends RenderObjectWidget {
  final List<Widget> children;
  const MultiChildRenderObjectWidget({super.key, required this.children});
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
        renderObject.setupParentData(child.renderObject!);
        renderObject.add(child.renderObject!);
      }
      return child;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newWidgetList = (newWidget as MultiChildRenderObjectWidget).children;
    final container = renderObject as ContainerRenderObjectMixin<RenderObject, ParentData>;
    
    final newChildren = <Element>[];
    final oldChildren = List<Element?>.from(_children);
    
    container.clear();
    
    for (int i = 0; i < newWidgetList.length; i++) {
      final newWidgetChild = newWidgetList[i];
      Element? child;
      
      for (int j = 0; j < oldChildren.length; j++) {
        final oldChild = oldChildren[j];
        if (oldChild != null && 
            Widget.canUpdate(oldChild.widget, newWidgetChild)) {
          child = oldChild;
          child.update(newWidgetChild);
          oldChildren[j] = null;
          break;
        }
      }
      
      if (child == null) {
        child = newWidgetChild.createElement();
        child.mount(this);
      }
      
      newChildren.add(child);
      
      if (child.renderObject != null) {
        container.setupParentData(child.renderObject!);
        container.add(child.renderObject!);
      }
    }
    
    for (final oldChild in oldChildren) {
      if (oldChild != null) {
        oldChild.unmount();
      }
    }
    
    _children = newChildren;
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    for (final c in _children) visitor(c);
  }
}
