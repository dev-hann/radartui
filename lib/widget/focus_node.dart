import 'dart:async';

import 'package:radartui/model/key.dart';
import 'package:radartui/widget/focus_manager.dart';

class FocusNode {
  FocusNode() {
    FocusManager.instance.registerFocusNode(this);
  }

  final keyStreamController = StreamController<Key>.broadcast();
  bool _focused = false;

  bool get isFocused => _focused;

  void requestFocus() => _focused = true;
  void unfocus() => _focused = false;

  Stream<Key> get keyStream => keyStreamController.stream;

  void dispose() {
    FocusManager.instance.unregisterFocusNode(this);
    keyStreamController.close();
  }
}
