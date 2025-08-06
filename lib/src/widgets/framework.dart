
import 'package:radartui/src/widgets/element.dart';
import 'package:radartui/src/widgets/state.dart';
import 'package:radartui/src/widgets/widget.dart';

// This file will contain the concrete implementations of Element subclasses.

/// An element that uses a [StatelessWidget] as its configuration.
class StatelessElement extends ComponentElement {
  StatelessElement(StatelessWidget widget) : super(widget);

  @override
  Widget build() => (widget as StatelessWidget).build(this);
}

/// An element that uses a [StatefulWidget] as its configuration.
class StatefulElement extends ComponentElement {
  StatefulElement(StatefulWidget widget) : super(widget);

  late final State _state;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    // TODO: Create the state object and call initState.
  }

  @override
  Widget build() => _state.build(this);

  @override
  void unmount() {
    super.unmount();
    // TODO: Call dispose on the state object.
  }
}

/// A base class for elements that compose other widgets.
///
/// This type of element does not have its own RenderObject.
/// Its RenderObject is the one from its child.
abstract class ComponentElement extends Element implements BuildContext {
  ComponentElement(Widget widget) : super(widget);

  Element? _child;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    // TODO: Call build() and mount the resulting child element.
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    // TODO: Call build() and update the child element.
  }

  /// The core method that builds the child widget.
  Widget build();
}
