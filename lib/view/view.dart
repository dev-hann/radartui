import 'dart:async';

import 'package:radartui/input/input.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/state/state.dart';
import 'package:radartui/widget/widget.dart' hide State;

abstract class View<T extends State> {
  T? state;
  StreamSubscription? _subscription;

  void initState() {
    _subscription = Input.instance.stream.listen((key) {
      onKey(key);
    });
  }

  void onKey(Key key) {}

  void dispose() {
    _subscription?.cancel();
  }

  void update(T? newState) {
    state = newState;
  }

  WidgetOld build();
}
