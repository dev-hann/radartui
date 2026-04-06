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
  return List.generate(a.length, (i) => a[i] == b[i]).every((equal) => equal);
}
