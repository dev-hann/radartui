import 'package:radartui/widget/focus_node.dart';

class FocusManager {
  static final FocusManager instance = FocusManager._();

  FocusManager._();

  final List<FocusNode> focusNodeList = [];
  int _currentIndex = -1;

  void registerFocusNode(FocusNode node) {
    if (focusNodeList.any((e) => e.focusID == node.focusID)) return;
    focusNodeList.add(node);

    // 만약 아무것도 포커스 안 되어 있다면, 자동으로 첫 번째 노드를 포커스
    if (_currentIndex == -1) {
      requestFocus(node);
    }
  }

  void unregisterFocusNode(FocusNode node) {
    final index = focusNodeList.indexOf(node);
    if (index == -1) return;

    focusNodeList.removeAt(index);
    // 만약 지운 노드가 현재 포커스 노드였다면
    if (_currentIndex == index) {
      _currentIndex = -1;
      if (focusNodeList.isNotEmpty) {
        requestFocus(focusNodeList.first);
      }
    } else if (_currentIndex > index) {
      _currentIndex--; // 리스트가 줄어들었으니까 인덱스 보정
    }
  }

  void requestFocus(FocusNode node) {
    unfocusAll();
    node.requestFocus();
    _currentIndex = focusNodeList.indexOf(node);
  }

  void unfocusAll() {
    for (final node in focusNodeList) {
      node.unfocus();
    }
  }

  void focusNext() {
    if (focusNodeList.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % focusNodeList.length;
    requestFocus(focusNodeList[_currentIndex]);
  }

  void focusPrevious() {
    if (focusNodeList.isEmpty) return;

    _currentIndex =
        (_currentIndex - 1 + focusNodeList.length) % focusNodeList.length;
    requestFocus(focusNodeList[_currentIndex]);
  }
}
