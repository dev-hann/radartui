import 'dart:async';
import 'dart:io';
import 'keyboard_backend.dart';
import 'key_parser.dart';
import 'logger.dart';

class RawKeyboard implements KeyboardBackend {
  final StreamController<KeyEvent> _controller =
      StreamController<KeyEvent>.broadcast();
  StreamSubscription<String>? _subscription;

  Stream<KeyEvent> get keyEvents => _controller.stream;

  void initialize() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    _subscription = stdin.transform(const SystemEncoding().decoder).listen(
      _handleInput,
    );
  }

  void _handleInput(String input) {
    try {
      final rawBytes = input.codeUnits.toList();
      final event = KeyParser.parse(rawBytes);
      _controller.add(event);
    } catch (e) {
      AppLogger.log('Error parsing keyboard input: $e');
    }
  }

  void inputTest(String input) {
    final rawBytes = input.codeUnits.toList();
    final event = KeyParser.parse(rawBytes);
    _controller.add(event);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    if (!_controller.isClosed) {
      _controller.close();
    }
    try {
      stdin.echoMode = true;
      stdin.lineMode = true;
    } catch (_) {}
  }
}
