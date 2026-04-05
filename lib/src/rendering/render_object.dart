import '../foundation.dart';
import '../services.dart';

/// A context used for painting render objects into an [OutputBuffer].
class PaintingContext {
  /// Creates a [PaintingContext] backed by the given [buffer].
  PaintingContext(this.buffer);

  /// The output buffer that painted content is written to.
  final OutputBuffer buffer;

  /// Paints the [child] render object at the given [offset].
  void paintChild(RenderObject child, Offset offset) =>
      child.paint(this, offset);
}

/// Opaque data attached to a child render object by its parent.
class ParentData {}

/// The base class for all render objects in the rendering tree.
///
/// Render objects perform layout and painting to produce visual output.
abstract class RenderObject {
  RenderObject? _parent;

  /// The parent of this render object, or `null` if this is the root.
  RenderObject? get parent => _parent;

  /// Sets the parent of this render object.
  set parent(RenderObject? value) => _parent = value;

  /// Optional data associated with this render object by its parent.
  ParentData? parentData;

  /// The current size of this render object after layout.
  Size? size;
  bool _needsLayout = true;
  bool _needsPaint = true;
  Constraints? _constraints;
  bool _relayoutBoundary = false;

  /// Whether this render object acts as a relayout boundary.
  bool get isRelayoutBoundary => _relayoutBoundary;

  /// Whether this render object needs to be repainted.
  bool get needsPaint => _needsPaint;

  /// Marks this render object as a relayout boundary or not.
  void setRelayoutBoundary(bool value) {
    _relayoutBoundary = value;
  }

  /// Initializes [parentData] for the given [child] if not already set.
  void setupParentData(RenderObject child) {
    child.parentData ??= ParentData();
  }

  /// Marks this render object as needing layout and paint.
  void markNeedsLayout() {
    _needsLayout = true;
    _needsPaint = true;
    if (!_relayoutBoundary && _parent != null) {
      _parent!.markNeedsLayout();
    }
  }

  /// Marks this render object as needing to be repainted.
  void markNeedsPaint() {
    _needsPaint = true;
  }

  /// Clears the needs-paint flag, indicating painting is up to date.
  void clearNeedsPaint() {
    _needsPaint = false;
  }

  /// Performs layout on this render object using the given [constraints].
  ///
  /// If [parentUsesSize] is true, the parent will be notified when this
  /// render object's size changes.
  void layout(Constraints constraints, {bool parentUsesSize = true}) {
    if (!_needsLayout && _constraints == constraints) return;
    _constraints = constraints;
    performLayout(constraints);
    _needsLayout = false;
    _needsPaint = true;

    if (parentUsesSize && _parent != null && !_relayoutBoundary) {
      _parent!._needsLayout = true;
      _parent!._needsPaint = true;
    }
  }

  /// Called to perform the actual layout computation for this render object.
  void performLayout(Constraints constraints);

  /// Paints this render object into the given [context] at [offset].
  void paint(PaintingContext context, Offset offset);
}

/// Abstract layout constraints passed to render objects during layout.
abstract class Constraints {
  /// Creates a [Constraints].
  const Constraints();

  /// A sentinel value representing unbounded space.
  static const int infinity = 999999;

  /// Returns this as [BoxConstraints], or throws if it is not.
  BoxConstraints get asBoxConstraints {
    if (this is BoxConstraints) {
      return this as BoxConstraints;
    }
    throw StateError('Constraints is not a BoxConstraints');
  }
}
