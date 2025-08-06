
abstract class Constraints {
  // TODO: Define properties of constraints (e.g., min/max width and height)
}

/// The base class for all objects in the render tree.
///
/// RenderObjects are responsible for layout and painting.
abstract class RenderObject {
  /// The parent of this render object in the tree.
  RenderObject? parent;

  /// The constraints given by the parent.
  Constraints? constraints;

  /// The size of this render object, computed during layout.
  Size? size;

  /// The offset of this render object relative to its parent.
  Offset? offset;

  /// Performs the layout for this render object.
  ///
  /// This is where the object determines its size based on the given constraints.
  void layout(Constraints constraints);

  /// Paints this render object into the given context.
  ///
  /// The `context` is typically a canvas or a buffer.
  void paint(PaintingContext context, Offset offset);

  // TODO: Add methods for handling children (attach, detach, visitChildren).
  // TODO: Add dirty flags for layout and paint to optimize the pipeline.
}

/// A context for painting, which provides access to a canvas-like surface.
class PaintingContext {
  // This will likely hold an instance of the OutputBuffer from the services layer.
  // TODO: Define the API for the painting context (e.g., drawRect, drawText).
}
