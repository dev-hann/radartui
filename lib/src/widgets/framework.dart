import '../rendering.dart';
import '../scheduler.dart';

/// An identification key for widgets, analogous to Flutter's [Key].
///
/// Keys control how the framework replaces widgets in the tree when
/// reconfiguring, enabling preservation of state across widget changes.
abstract class Key {
  /// Creates a [Key].
  const Key();

  /// Creates a const key with an empty value.
  const Key.empty();

  /// Creates a [ValueKey] with the given [value].
  const factory Key.value(String value) = ValueKey<String>;
}

/// A key that is unique to the widget tree, analogous to Flutter's [LocalKey].
abstract class LocalKey extends Key {
  /// Creates a [LocalKey].
  const LocalKey();
}

/// A key that uses a value for equality comparison, analogous to Flutter's [ValueKey].
class ValueKey<T> extends LocalKey {
  /// Creates a [ValueKey] with the given [value].
  const ValueKey(this.value);

  /// The value used for equality comparison.
  final T value;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueKey<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;
  @override
  int get hashCode => Object.hash(runtimeType, value);
  @override
  String toString() => 'ValueKey<$T>($value)';
}

/// A key that is unique across the entire app, analogous to Flutter's [GlobalKey].
///
/// Provides access to the associated element and widget from anywhere in the
/// widget tree.
class GlobalKey extends Key {
  Element? _currentElement;

  /// The current widget associated with this key, or null if unmounted.
  Widget? get currentWidget => _currentElement?.widget;

  /// The current element associated with this key, or null if unmounted.
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

/// A key that is unique by identity, analogous to Flutter's [UniqueKey].
///
/// Each instance is only equal to itself, useful for forcing the framework to
/// treat a widget as new.
class UniqueKey extends LocalKey {
  /// Creates a [UniqueKey].
  // ignore: prefer_const_constructors
  factory UniqueKey() => UniqueKey._internal();
  const UniqueKey._internal();
  @override
  bool operator ==(Object other) => identical(this, other);
  @override
  int get hashCode => identityHashCode(this);
  @override
  String toString() => 'UniqueKey#${hashCode.toRadixString(16)}';
}

/// The base class for all widgets, analogous to Flutter's [Widget].
///
/// Widgets are immutable descriptions of part of a user interface. Each widget
/// describes its own [createElement] method which creates an [Element] that
/// manages the widget's position in the tree.
abstract class Widget {
  /// Creates a [Widget].
  const Widget({this.key});

  /// Controls how one widget replaces another in the tree.
  final Key? key;

  /// Creates the [Element] for this widget.
  Element createElement();

  /// Whether [newWidget] can be used to update an element that currently
  /// has [oldWidget] as its configuration.
  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key;
  }
}

/// A node in the widget tree, analogous to Flutter's [Element].
///
/// Elements represent the instantiation of a [Widget] at a particular location
/// in the tree. They manage the lifecycle and state of their associated widget.
abstract class Element {
  /// Creates an [Element] for the given [widget].
  Element(this.widget);

  /// The current configuration of this element.
  Widget widget;

  RenderObject? _renderObject;

  /// The [RenderObject] associated with this element, if any.
  RenderObject? get renderObject => _renderObject;

  /// Whether this element has been marked as needing to be rebuilt.
  bool dirty = true;

  Element? _parent;

  /// The parent of this element in the tree, or null if this is the root.
  Element? get parent => _parent;

  /// Adds this element to the tree at the given [parent].
  void mount(Element? parent) {
    _parent = parent;
    if (widget.key case final GlobalKey key) {
      key._register(this);
    }
  }

  /// Updates the widget configuration to [newWidget].
  void update(Widget newWidget) {
    if (widget.key != newWidget.key) {
      if (widget.key case final GlobalKey key) {
        key._unregister(this);
      }
      if (newWidget.key case final GlobalKey key) {
        key._register(this);
      }
    }
    widget = newWidget;
  }

  /// Removes this element from the tree and releases resources.
  void unmount() {
    if (widget.key case final GlobalKey key) {
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

  /// Calls [visitor] for each direct child of this element.
  void visitChildren(void Function(Element e) visitor) {}

  /// Marks this element as needing to be rebuilt in the next frame.
  void markNeedsBuild() {
    if (dirty) return;
    dirty = true;
    SchedulerBinding.instance.scheduleFrame();
  }

  /// Updates the given [child] to use the given [newWidget], returning the
  /// updated or newly created child element.
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

  /// Returns the nearest ancestor widget of the given type [T].
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

  /// Obtains the nearest [InheritedWidget] of type [T] and registers this
  /// element as a dependent so it rebuilds when the inherited widget changes.
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

  /// Returns the nearest [InheritedElement] of type [T].
  InheritedElement?
      findAncestorElementOfExactType<T extends InheritedWidget>() {
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

/// An abstract interface for locating ancestor widgets, analogous to Flutter's [BuildContext].
///
/// BuildContext objects are passed to [Widget.build] methods and can be used to
/// look up inherited widgets and other ancestors in the tree.
abstract class BuildContext {
  /// Returns the nearest ancestor widget of the given type [T].
  T? findAncestorWidgetOfExactType<T extends Widget>();

  /// Obtains the nearest [InheritedWidget] of type [T], registering the caller
  /// as a dependent.
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();

  /// Returns the nearest [InheritedElement] of type [T].
  InheritedElement? findAncestorElementOfExactType<T extends InheritedWidget>();
}

/// A widget that does not require mutable state, analogous to Flutter's [StatelessWidget].
///
/// Subclasses must implement [build] to describe the widget's UI.
abstract class StatelessWidget extends Widget {
  /// Creates a [StatelessWidget].
  const StatelessWidget({super.key});
  @override
  StatelessElement createElement() => StatelessElement(this);

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);
}

/// A widget that has mutable state, analogous to Flutter's [StatefulWidget].
///
/// Subclasses must implement [createState] to provide a [State] object.
abstract class StatefulWidget extends Widget {
  /// Creates a [StatefulWidget].
  const StatefulWidget({super.key});
  @override
  StatefulElement createElement() => StatefulElement(this);

  /// Creates the mutable state for this widget.
  State createState();
}

/// The logic and internal state for a [StatefulWidget], analogous to Flutter's [State].
///
/// Override [initState], [build], and [dispose] to manage the widget's lifecycle.
abstract class State<T extends StatefulWidget> {
  /// The current widget configuration.
  T get widget => _widget!;
  T? _widget;
  StatefulElement? _element;

  /// The [BuildContext] for this state object.
  BuildContext get context => _element!;

  /// Whether this state object is currently in the tree.
  bool get mounted => _element != null;

  /// Called when this state object is first inserted into the tree.
  void initState() {}

  /// Called when the widget configuration changes.
  void didUpdateWidget(T oldWidget) {}

  /// Called when this state object is removed from the tree permanently.
  void dispose() {}

  /// Notifies the framework that the internal state has changed, triggering a rebuild.
  void setState(void Function() fn) {
    assert(mounted, 'setState() called after dispose()');
    try {
      fn();
      _element?.markNeedsBuild();
    } on Exception catch (e) {
      assert(() {
        throw StateError('setState() callback failed: $e');
      }());
    }
  }

  /// Describes the part of the user interface represented by this state.
  Widget build(BuildContext context);
}

/// An [Element] that owns a [StatelessWidget], analogous to Flutter's [StatelessElement].
class StatelessElement extends ComponentElement {
  /// Creates a [StatelessElement] for the given [widget].
  StatelessElement(StatelessWidget super.widget);
  @override
  Widget build() => (widget as StatelessWidget).build(this);
}

/// An [Element] that owns a [StatefulWidget], analogous to Flutter's [StatefulElement].
///
/// Manages the lifecycle of the associated [State] object.
class StatefulElement extends ComponentElement {
  /// Creates a [StatefulElement] for the given [widget].
  StatefulElement(StatefulWidget super.widget) {
    _state = (widget as StatefulWidget).createState();
    _state._widget = widget as StatefulWidget;
    _state._element = this;
  }
  late final State<StatefulWidget> _state;

  /// The [State] object managed by this element.
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
    _state._widget = newWidget as StatefulWidget;
    super.update(newWidget);
    _state.didUpdateWidget(oldWidget as StatefulWidget);
  }

  @override
  void unmount() {
    _state.dispose();
    super.unmount();
  }
}

/// An [Element] that composes other widgets but does not create a render object.
///
/// Analogous to Flutter's [ComponentElement]. Subclasses must implement [build].
abstract class ComponentElement extends Element implements BuildContext {
  /// Creates a [ComponentElement] for the given [widget].
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

  /// Rebuilds the element by calling [build] and updating the child.
  void rebuild() => _child = updateChild(_child, build());

  @override
  RenderObject? get renderObject => _child?.renderObject;
  @override
  void visitChildren(void Function(Element e) visitor) {
    if (_child != null) visitor(_child!);
  }

  /// Builds the widget tree below this element.
  Widget build();
}

/// A widget that propagates information down the tree, analogous to Flutter's [InheritedWidget].
///
/// When an [InheritedWidget] changes, all descendants that registered a
/// dependency via [BuildContext.dependOnInheritedWidgetOfExactType] are rebuilt.
abstract class InheritedWidget extends Widget {
  /// Creates an [InheritedWidget].
  const InheritedWidget({super.key, required this.child});

  /// The widget below this inherited widget in the tree.
  final Widget child;
  @override
  InheritedElement createElement() => InheritedElement(this);

  /// Whether the widgets that depend on this widget should be rebuilt when
  /// [oldWidget] is replaced by this widget.
  bool updateShouldNotify(covariant InheritedWidget oldWidget);
}

/// An [Element] that owns an [InheritedWidget], analogous to Flutter's [InheritedElement].
///
/// Tracks dependent elements and notifies them when the inherited widget changes.
class InheritedElement extends ComponentElement {
  /// Creates an [InheritedElement] for the given [widget].
  InheritedElement(InheritedWidget super.widget);
  final Set<Element> _dependents = {};

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
    if ((oldWidget as InheritedWidget).updateShouldNotify(
      newWidget as InheritedWidget,
    )) {
      for (final dependent in _dependents) {
        dependent.markNeedsBuild();
      }
    }
    rebuild();
  }
}

/// A widget that applies [ParentData] to its child's render object, analogous
/// to Flutter's [ParentDataWidget].
abstract class ParentDataWidget<T extends ParentData> extends Widget {
  /// Creates a [ParentDataWidget].
  const ParentDataWidget({super.key, required this.child});

  /// The child widget whose render object receives the parent data.
  final Widget child;

  /// Applies parent data to the given [renderObject].
  void applyParentData(RenderObject renderObject);
  @override
  ParentDataElement createElement() => ParentDataElement(this);
}

/// An [Element] that owns a [ParentDataWidget].
class ParentDataElement extends ComponentElement {
  /// Creates a [ParentDataElement] for the given [widget].
  ParentDataElement(ParentDataWidget super.widget);

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

/// A widget that creates and manages a [RenderObject], analogous to Flutter's [RenderObjectWidget].
///
/// Subclasses must implement [createRenderObject] and may override
/// [updateRenderObject] to synchronize widget properties with the render object.
abstract class RenderObjectWidget extends Widget {
  /// Creates a [RenderObjectWidget].
  const RenderObjectWidget({super.key});
  @override
  RenderObjectElement createElement();

  /// Creates the [RenderObject] for this widget.
  RenderObject createRenderObject(BuildContext context);

  /// Updates the [renderObject] to reflect the current widget configuration.
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}
}

/// An [Element] that owns a [RenderObjectWidget], analogous to Flutter's [RenderObjectElement].
///
/// Creates and manages the associated [RenderObject] lifecycle.
class RenderObjectElement extends Element implements BuildContext {
  /// Creates a [RenderObjectElement] for the given [widget].
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

/// A [RenderObjectWidget] with a single optional child, analogous to Flutter's [SingleChildRenderObjectWidget].
abstract class SingleChildRenderObjectWidget extends RenderObjectWidget {
  /// Creates a [SingleChildRenderObjectWidget].
  const SingleChildRenderObjectWidget({super.key, this.child});

  /// The optional child widget.
  final Widget? child;
  @override
  SingleChildRenderObjectElement createElement() =>
      SingleChildRenderObjectElement(this);
}

/// An [Element] for [SingleChildRenderObjectWidget], managing a single child.
class SingleChildRenderObjectElement extends RenderObjectElement {
  /// Creates a [SingleChildRenderObjectElement] for the given [widget].
  SingleChildRenderObjectElement(SingleChildRenderObjectWidget super.widget);
  Element? _child;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = (widget as SingleChildRenderObjectWidget).child;
    if (childWidget != null) {
      _child = updateChild(null, childWidget);
      if (_child?.renderObject != null) {
        (renderObject as RenderObjectWithChildMixin<RenderObject>).child =
            _child!.renderObject!;
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
        final container =
            renderObject as RenderObjectWithChildMixin<RenderObject>;
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

/// A [RenderObjectWidget] with a list of children, analogous to Flutter's [MultiChildRenderObjectWidget].
abstract class MultiChildRenderObjectWidget extends RenderObjectWidget {
  /// Creates a [MultiChildRenderObjectWidget].
  const MultiChildRenderObjectWidget({super.key, required this.children});

  /// The list of child widgets.
  final List<Widget> children;
  @override
  MultiChildRenderObjectElement createElement() =>
      MultiChildRenderObjectElement(this);
}

/// An [Element] for [MultiChildRenderObjectWidget], managing a list of children.
class MultiChildRenderObjectElement extends RenderObjectElement {
  /// Creates a [MultiChildRenderObjectElement] for the given [widget].
  MultiChildRenderObjectElement(MultiChildRenderObjectWidget super.widget);
  List<Element> _children = [];

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final renderObject = this.renderObject
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
    final container =
        renderObject as ContainerRenderObjectMixin<RenderObject, ParentData>;

    final newChildren = <Element>[];
    final oldChildren = List<Element?>.from(_children);

    container.clear();

    final int newWidgetListLength = newWidgetList.length;
    for (int i = 0; i < newWidgetListLength; i++) {
      final newWidgetChild = newWidgetList[i];
      final child = _findOrCreateChild(newWidgetChild, oldChildren);
      newChildren.add(child);

      if (child.renderObject != null) {
        container.setupParentData(child.renderObject!);
        container.add(child.renderObject!);
      }
    }

    _unmountOldChildren(oldChildren);
    _children = newChildren;
  }

  Element _findOrCreateChild(
    Widget newWidgetChild,
    List<Element?> oldChildren,
  ) {
    final int oldChildCount = oldChildren.length;
    for (int j = 0; j < oldChildCount; j++) {
      final oldChild = oldChildren[j];
      if (oldChild != null &&
          Widget.canUpdate(oldChild.widget, newWidgetChild)) {
        oldChild.update(newWidgetChild);
        oldChildren[j] = null;
        return oldChild;
      }
    }

    final child = newWidgetChild.createElement();
    child.mount(this);
    return child;
  }

  void _unmountOldChildren(List<Element?> oldChildren) {
    for (final oldChild in oldChildren) {
      if (oldChild != null) {
        oldChild.unmount();
      }
    }
  }

  @override
  void visitChildren(void Function(Element e) visitor) {
    for (final c in _children) {
      visitor(c);
    }
  }
}
