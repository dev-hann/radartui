
import 'dart:io';

/// Represents a key press event.
class KeyEvent {
  // TODO: Define properties of a key event (e.g., character, control keys)
}

/// A service that captures raw key presses from stdin.
class RawKeyboard {
  /// Initializes the keyboard service.
  void initialize() {
    // TODO: Set stdin to raw mode to capture key presses without needing to press enter.
    // stdin.echoMode = false;
    // stdin.lineMode = false;
  }

  /// Disposes the keyboard service, restoring terminal settings.
  void dispose() {
    // TODO: Restore stdin to its original state.
    // stdin.echoMode = true;
    // stdin.lineMode = true;
  }

  /// A stream of key events.
  Stream<KeyEvent> get keyEvents {
    // TODO: Listen to stdin and transform the byte stream into KeyEvents.
    return Stream.empty();
  }
}
