
/// An identifier for widgets, elements, and render objects.
///
/// Used by the framework to match widgets and elements up during rebuilds,
/// which is crucial for preserving state.
abstract class Key {
  const Key(this.value);

  final String value;

  // TODO: Implement comparison operators (==, hashCode)
}
