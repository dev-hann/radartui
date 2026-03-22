import '../services.dart';
import 'binding_base.dart';

mixin ServicesBinding on BindingBase {
  static ServicesBinding? _instance;

  static ServicesBinding get instance => BindingBase.checkInstance(_instance);

  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  Terminal get terminal;
  KeyboardBackend get keyboard;

  void initializeServices() {
    keyboard.initialize();
  }

  void disposeServices() {
    keyboard.dispose();
  }
}
