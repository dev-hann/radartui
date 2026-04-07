import '../foundation.dart';

/// A cache for TextStyle objects with lazy evaluation.
///
/// Used by RenderObject classes to avoid recreating TextStyles
/// on every paint call. Styles are built only when first accessed
/// and cleared explicitly when dependencies change.
class StyleCache {
  /// Creates a new style cache.
  StyleCache();

  final Map<String, TextStyle> _cache = {};
  bool _isValid = true;

  /// Retrieves or creates a cached style for the given [key].
  ///
  /// If the style is not cached, [builder] is called to create it.
  /// The result is stored and returned on subsequent calls.
  TextStyle get(String key, TextStyle Function() builder) {
    TextStyle? cached = _cache[key];
    if (cached == null) {
      cached = builder();
      _cache[key] = cached;
    }
    return cached;
  }

  /// Clears all cached styles.
  ///
  /// Call this when style dependencies (colors, flags, etc.) change.
  void clear() {
    _cache.clear();
    _isValid = false;
  }

  /// Whether the cache is valid (not cleared since last access).
  bool get isValid => _isValid;
}
