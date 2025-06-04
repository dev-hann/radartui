import 'package:radartui/widget/focus_manager.dart';

abstract class State {
  final focusManager = FocusManager.instance;

  String get currentFocusID {
    final index = focusManager.currentIndex;
    if (index == -1) {
      return "";
    }
    return focusManager.focusList[focusManager.currentIndex];
  }

  void nextFocus() {
    focusManager.focusNext();
  }

  void previousFocus() {
    focusManager.focusPrevious();
  }
}
