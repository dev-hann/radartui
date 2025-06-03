class FocusNode {
  FocusNode({required this.focusID});
  final String focusID;

  bool _focused = false;

  bool get hasFocus => _focused;

  void requestFocus() {
    _focused = true;
  }

  void unfocus() => _focused = false;
}
