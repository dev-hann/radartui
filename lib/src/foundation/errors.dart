/// The base error type for RadarTUI framework exceptions.
class RadartuiError extends Error {
  RadartuiError(this.message);
  final String message;

  @override
  String toString() => 'RadartuiError: $message';
}
