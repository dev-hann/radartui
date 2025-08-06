import 'package:radartui/widget/element.dart';
import 'package:radartui/model/key.dart' as input_key;

class FocusManager {
  FocusManager._();
  static final FocusManager instance = FocusManager._();

  final Map<String, Element> _focusElements = {};
  final List<String> focusList = <String>[];
  int currentIndex = -1;

  bool isFocused(String focusID) {
    if (currentIndex == -1) {
      return false;
    }
    return focusList[currentIndex] == focusID;
  }

  void registerFocus(String focusID, Element element) {
    if (focusList.contains(focusID)) return;
    focusList.add(focusID);
    _focusElements[focusID] = element;

    // 만약 아무것도 포커스 안 되어 있다면, 자동으로 첫 번째 노드를 포커스
    if (currentIndex == -1) {
      requestFocus(focusID);
    }
  }

  void unregisterFocus(String focusID) {
    final index = focusList.indexOf(focusID);
    if (index == -1) return;

    focusList.removeAt(index);
    _focusElements.remove(focusID);
    // 만약 지운 노드가 현재 포커스 노드였다면
    if (currentIndex == index) {
      currentIndex = -1;
      if (focusList.isNotEmpty) {
        requestFocus(focusList.first);
      }
    } else if (currentIndex > index) {
      currentIndex--; // 리스트가 줄어들었으니까 인덱스 보정
    }
  }

  void requestFocus(String focusID) {
    unfocusAll();
    currentIndex = focusList.indexOf(focusID);
  }

  void unfocusAll() {
    currentIndex = -1;
  }

  void focusNext() {
    if (focusList.isEmpty) return;

    currentIndex = (currentIndex + 1) % focusList.length;
    requestFocus(focusList[currentIndex]);
  }

  void focusPrevious() {
    if (focusList.isEmpty) return;

    currentIndex = (currentIndex - 1 + focusList.length) % focusList.length;
    requestFocus(focusList[currentIndex]);
  }

  void handleKey(input_key.Key key) {
    if (currentIndex != -1 && _focusElements.containsKey(focusList[currentIndex])) {
      _focusElements[focusList[currentIndex]]?.onKey(key);
    }
  }
}