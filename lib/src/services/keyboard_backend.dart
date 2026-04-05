import '../services/key_parser.dart';

/// Abstract interface for keyboard input backends.
abstract class KeyboardBackend {
  /// A stream of parsed keyboard events.
  Stream<KeyEvent> get keyEvents;

  /// Initializes the keyboard backend for capturing input.
  void initialize() {}

  /// Releases resources used by the keyboard backend.
  void dispose();
}
