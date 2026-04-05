import '../services.dart';
import 'binding_base.dart';

/// Binding that provides access to terminal I/O and keyboard services.
mixin ServicesBinding on BindingBase {
  static ServicesBinding? _instance;

  /// The singleton instance of this binding.
  static ServicesBinding get instance => BindingBase.checkInstance(_instance);

  /// Resets the singleton instance, useful for testing.
  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  /// The terminal interface for screen operations.
  Terminal get terminal;

  /// The keyboard backend for reading user input.
  KeyboardBackend get keyboard;

  /// Initializes the keyboard and other platform services.
  void initializeServices() {
    keyboard.initialize();
  }

  /// Disposes the keyboard and other platform services.
  void disposeServices() {
    keyboard.dispose();
  }
}
