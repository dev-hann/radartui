import '../foundation.dart';
import '../rendering.dart';
import '../services.dart';
import '../widgets.dart';
import 'binding_base.dart';
import 'services_binding.dart';

mixin RendererBinding on BindingBase, ServicesBinding {
  static RendererBinding? _instance;

  static RendererBinding get instance => BindingBase.checkInstance(_instance);

  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  OutputBuffer get outputBuffer;

  void paintElement(Element element) {
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}
