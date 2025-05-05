class TextEditingController {
  TextEditingController({String? text}) : _text = text ?? '';

  String _text;
  int _cursorIndex = 0;

  String get text => _text;
  set text(String value) {
    _text = value;
    _cursorIndex = value.length;
  }

  int get cursorIndex => _cursorIndex;
  set cursorIndex(int index) {
    _cursorIndex = index.clamp(0, _text.length);
  }

  void insert(String char) {
    _text =
        _text.substring(0, _cursorIndex) + char + _text.substring(_cursorIndex);
    _cursorIndex++;
  }

  void deleteBack() {
    if (_cursorIndex > 0) {
      _text =
          _text.substring(0, _cursorIndex - 1) + _text.substring(_cursorIndex);
      _cursorIndex--;
    }
  }

  void moveLeft() {
    if (_cursorIndex > 0) _cursorIndex--;
  }

  void moveRight() {
    if (_cursorIndex < _text.length) _cursorIndex++;
  }
}
