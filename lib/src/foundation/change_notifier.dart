/// A class that can be extended or mixed in that provides a change notification API.
///
/// This class maintains a list of listeners that can be notified when the object changes.
/// It's useful for implementing the observer pattern.
///
/// Example:
/// ```dart
/// class MyModel extends ChangeNotifier {
///   int _value = 0;
///
///   int get value => _value;
///
///   void increment() {
///     _value++;
///     notifyListeners();
///   }
/// }
/// ```
class ChangeNotifier {
  final List<Function()> _listeners = [];

  /// Register a closure to be called when the object changes.
  ///
  /// This method should not be called during a call to [notifyListeners].
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  /// Call all the registered listeners.
  ///
  /// Subclasses should call this method whenever the object changes in a way
  /// that requires notifying listeners.
  ///
  /// If a listener is added or removed during this method, the change will
  /// not affect the current notification.
  void notifyListeners() {
    // Create a copy to avoid concurrent modification issues
    final List<Function()> localListeners = List.from(_listeners);

    for (final Function() listener in localListeners) {
      listener();
    }
  }

  /// Discards any resources used by the object.
  ///
  /// This method should be called when the object is no longer needed.
  /// After calling this method, the object is no longer in a usable state.
  void dispose() {
    _listeners.clear();
  }

  /// Whether any listeners are currently registered.
  bool get hasListeners => _listeners.isNotEmpty;
}
