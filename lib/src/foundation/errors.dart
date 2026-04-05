/// The base error type for RadarTUI framework exceptions.
class RadartuiError extends Error {
  /// Creates a [RadartuiError] with the given [message].
  RadartuiError(this.message);

  /// A human-readable description of the error.
  final String message;

  @override
  String toString() => 'RadartuiError: $message';
}
