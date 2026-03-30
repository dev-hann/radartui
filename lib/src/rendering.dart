/// Rendering layer handling layout and painting.
///
/// This includes:
/// - [RenderObject] base class for render tree nodes
/// - [RenderBox] for box layout model
/// - [RenderObjectWithChildMixin] for single-child render objects
/// - [ContainerRenderObjectMixin] for multi-child render objects
/// - [PaintingContext] for painting operations
library rendering;

export 'rendering/render_box.dart';
export 'rendering/render_object.dart';
export 'rendering/single_child_render_box.dart';
