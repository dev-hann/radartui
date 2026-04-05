import '../foundation.dart';
import '../rendering.dart';
import '../services.dart';
import '../widgets.dart';
import 'binding_base.dart';
import 'services_binding.dart';

/// Binding that connects the rendering pipeline to the output buffer.
mixin RendererBinding on BindingBase, ServicesBinding {
  static RendererBinding? _instance;

  /// The singleton instance of this binding.
  static RendererBinding get instance => BindingBase.checkInstance(_instance);

  /// Resets the singleton instance, useful for testing.
  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  /// The output buffer that render objects paint into.
  OutputBuffer get outputBuffer;

  /// Paints the render object belonging to [element] into the output buffer.
  void paintElement(Element element) {
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}
