
import 'package:radartui/src/rendering/render_object.dart';

/// Manages the rendering pipeline.
///
/// This class owns the render tree and is responsible for initiating the
/// build, layout, and paint phases of each frame.
class PipelineOwner {
  /// The root of the render tree.
  RenderObject? get rootRenderObject => _rootRenderObject;
  RenderObject? _rootRenderObject;

  /// Sets the root of the render tree.
  void setRoot(RenderObject root) {
    _rootRenderObject = root;
    // TODO: Mark the entire tree as needing layout and paint.
  }

  /// Kicks off the layout phase for the entire render tree.
  void flushLayout() {
    // TODO: Start layout from the root of the render tree.
    // _rootRenderObject?.layout(initialConstraints);
  }

  /// Kicks off the paint phase for the entire render tree.
  void flushPaint() {
    // TODO: Start painting from the root of the render tree.
    // _rootRenderObject?.paint(paintingContext, Offset.zero);
  }
}
