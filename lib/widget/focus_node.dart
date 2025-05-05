import 'package:radartui/model/key.dart';

class FocusNode {
  bool _focused = false;

  bool get hasFocus => _focused;
  final List<Function(Key)> _listeners = [];

  void requestFocus() => _focused = true;
  void unfocus() => _focused = false;

  void addListener(Function(Key) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(Key) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(Key key) {
    for (final listener in _listeners) {
      listener(key);
    }
  }
}
