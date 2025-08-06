
/// An interface for classes that can provide detailed diagnostic information.
///
/// This is used for debugging and introspection.
abstract class Diagnosticable {
  /// Returns a debug representation of the object.
  String toDiagnosticsNode();
}
