import '../services/key_parser.dart';

abstract class KeyboardBackend {
  Stream<KeyEvent> get keyEvents;
  void initialize() {}
  void dispose();
}
