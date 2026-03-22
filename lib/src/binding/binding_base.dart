abstract class BindingBase {
  BindingBase() {
    initInstances();
  }

  void initInstances() {}

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
