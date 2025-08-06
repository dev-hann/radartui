
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/widget.dart';

/// An instantiation of a [Widget] at a particular location in the tree.
///
/// Elements are the mutable glue between the immutable Widget tree and the
/// stateful RenderObject tree.
abstract class Element {
  Element(this.widget);

  final Widget widget;
  Element? _parent;
  RenderObject? _renderObject;

  /// Mounts the element in the tree at the given parent and slot.
  void mount(Element? parent) {
    _parent = parent;
    // TODO: Create the associated RenderObject and attach it to the render tree.
  }

  /// Called when the widget configuration has changed.
  void update(Widget newWidget) {
    // TODO: Update the associated RenderObject with the new configuration.
  }

  /// Unmounts the element from the tree.
  void unmount() {
    // TODO: Detach the RenderObject from the render tree.
  }

  // TODO: Add methods for managing children (updateChildren).
}

/// A handle to the location of a widget in the tree.
///
/// This is what is passed to the `build` method of widgets.
abstract class BuildContext {
  // This is typically implemented by the Element class itself.
  // TODO: Add methods to look up inherited widgets (e.g., Theme.of(context)).
}
