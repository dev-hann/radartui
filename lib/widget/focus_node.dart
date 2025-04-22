import 'dart:async';

import 'package:radartui/widget/focus_manager.dart';

class FocusNode {
  FocusNode() {
    FocusManager.instance.registerFocusNode(this);
  }
  final StreamController<String> keyStreamController =
      StreamController<String>();
  Stream<String> get keyStream => keyStreamController.stream;

  bool _focused = false;
  bool get isFocused => _focused;

  void requestFocus() {
    _focused = true;
  }

  void unfocus() {
    _focused = false;
  }

  void dispose() {
    FocusManager.instance.unregisterFocusNode(this);
  }
}
