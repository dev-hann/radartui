/// The abstract base class for all bindings.
///
/// Bindings are singletons that glue the framework to platform services.
abstract class BindingBase {
  /// Creates a [BindingBase] and immediately calls [initInstances].
  BindingBase() {
    initInstances();
  }

  /// Called during construction to initialize binding singletons.
  void initInstances() {}

  /// Throws if [instance] is `null`, otherwise returns it.
  static T checkInstance<T>(T? instance) {
    if (instance == null) {
      throw StateError(
        'Binding has not yet been initialized.\n'
        'The binding must be initialized before accessing this property.\n'
        'Ensure that runApp() has been called first.',
      );
    }
    return instance;
  }
}
