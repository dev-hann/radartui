import '../foundation.dart';
import '../services.dart';

class PaintingContext {
  PaintingContext(this.buffer);
  final OutputBuffer buffer;
  void paintChild(RenderObject child, Offset offset) =>
      child.paint(this, offset);
}

class ParentData {}

abstract class RenderObject {
  RenderObject? _parent;
  RenderObject? get parent => _parent;
  set parent(RenderObject? value) => _parent = value;
  ParentData? parentData;
  Size? size;
  bool _needsLayout = true;
  bool _needsPaint = true;
  Constraints? _constraints;
  bool _relayoutBoundary = false;

  bool get isRelayoutBoundary => _relayoutBoundary;

  bool get needsPaint => _needsPaint;

  void setRelayoutBoundary(bool value) {
    _relayoutBoundary = value;
  }

  void setupParentData(RenderObject child) {
    child.parentData ??= ParentData();
  }

  void markNeedsLayout() {
    _needsLayout = true;
    _needsPaint = true;
    if (!_relayoutBoundary && _parent != null) {
      _parent!.markNeedsLayout();
    }
  }

  void markNeedsPaint() {
    _needsPaint = true;
  }

  void clearNeedsPaint() {
    _needsPaint = false;
  }

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

  void performLayout(Constraints constraints);
  void paint(PaintingContext context, Offset offset);
}

abstract class Constraints {
  const Constraints();

  static const int infinity = 999999;

  BoxConstraints get asBoxConstraints {
    if (this is BoxConstraints) {
      return this as BoxConstraints;
    }
    throw StateError('Constraints is not a BoxConstraints');
  }
}
