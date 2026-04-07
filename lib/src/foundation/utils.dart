library radartui.foundation.utils;

/// Common utility functions for use across the framework.

/// Compares two lists for equality.
///
/// Returns true if [a] and [b] have the same length and all
/// corresponding elements are equal.
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Compares two iterables for equality.
///
/// Returns true if [a] and [b] have the same length and all
/// corresponding elements are equal. Does not require Set allocation.
bool iterableEquals<T>(Iterable<T>? a, Iterable<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  final aIterator = a.iterator;
  final bIterator = b.iterator;
  while (aIterator.moveNext()) {
    if (!bIterator.moveNext() || aIterator.current != bIterator.current) {
      return false;
    }
  }
  return !bIterator.moveNext();
}

/// Compares two sets for equality.
///
/// Returns true if [a] and [b] have the same elements.
bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (final element in a) {
    if (!b.contains(element)) return false;
  }
  return true;
}

/// Compares two maps for equality.
///
/// Returns true if [a] and [b] have the same keys and all
/// corresponding values are equal.
bool mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
