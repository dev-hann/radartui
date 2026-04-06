import '../foundation.dart';
import 'render_object.dart';

/// How a flex child should be sized within its parent.
enum FlexFit { tight, loose }

/// Parent data for children of flex-based render objects.
class FlexParentData extends ParentData {
  /// The flex factor controlling how space is distributed.
  int flex = 0;

  /// Whether the child should be tightly or loosely fitted.
  FlexFit fit = FlexFit.loose;

  /// The position of this child within its parent.
  Offset offset = Offset.zero;
}

/// A render object with a 2D size in terminal cell units.
abstract class RenderBox extends RenderObject {
  /// Whether this render object has been laid out and has a [size].
  bool get hasSize => size != null;

  /// The width of this render box in terminal columns.
  int get width => size?.width ?? 0;

  /// The height of this render box in terminal rows.
  int get height => size?.height ?? 0;
}

/// A mixin that provides a single [child] to a [RenderObject].
mixin RenderObjectWithChildMixin<C extends RenderObject> on RenderObject {
  C? _child;

  /// The single child of this render object, or `null` if none.
  C? get child => _child;

  /// Sets the single child of this render object.
  set child(C? value) {
    _child?.parent = null;
    _child = value;
    _child?.parent = this;
  }

  /// Whether this render object currently has a child.
  bool get hasChild => _child != null;
}

/// A mixin that provides a list of children to a [RenderObject].
mixin ContainerRenderObjectMixin<C extends RenderObject, D extends ParentData>
    on RenderObject {
  final List<C> _children = [];

  /// Adds a [child] to the end of the children list.
  void add(C child) {
    setupParentData(child);
    child.parent = this;
    _children.add(child);
  }

  /// Removes a [child] from the children list.
  void remove(C child) {
    _children.remove(child);
    child.parent = null;
  }

  /// Removes all children from this render object.
  void clear() => _children.clear();

  /// An unmodifiable view of the current children.
  List<C> get children => _children;
}
