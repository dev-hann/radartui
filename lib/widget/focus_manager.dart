import 'package:radartui/widget/focus_node.dart';

class FocusManager {
  static final FocusManager instance = FocusManager._();

  FocusManager._();
  final List<FocusNode> _focusNodeList = [];
  int _currentIndex = -1;

  void registerFocusNode(FocusNode node) {
    _focusNodeList.add(node);
  }

  void unregisterFocusNode(FocusNode node) {
    _focusNodeList.remove(node);
  }

  void requestFocus(FocusNode node) {
    unfocusAll();
    node.requestFocus();
  }

  void unfocusAll() {
    for (final node in _focusNodeList) {
      node.unfocus();
    }
  }

  void focusNext() {
    if (_focusNodeList.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _focusNodeList.length;
    requestFocus(_focusNodeList[_currentIndex]);
  }

  void focusPrevious() {
    if (_focusNodeList.isEmpty) return;
    _currentIndex =
        (_currentIndex - 1 + _focusNodeList.length) % _focusNodeList.length;
    requestFocus(_focusNodeList[_currentIndex]);
  }
}
