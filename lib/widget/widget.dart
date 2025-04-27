import 'dart:async';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/focus_node.dart';

export './text.dart';
export './column.dart';
export './card.dart';
export './list_view.dart';

abstract class Widget {
  void render(Canvas canvs, Rect rect);

  int preferredHeight(int width);

  void initState() {}
  void dispose() {}
}

abstract class FocusableWidget extends Widget {
  final focusNode = FocusNode();
  StreamSubscription<Key>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    print("init!!");
    print(focusNode.hashCode);
    _streamSubscription = focusNode.keyStream.listen((key) {
      print("onKey");
      onKey(key);
    });
  }

  void onKey(Key key);
  @override
  void dispose() {
    focusNode.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}

abstract class WithChildWidget extends Widget {
  WithChildWidget({required this.child});
  final Widget child;

  @override
  void initState() {
    super.initState();
    child.initState();
  }

  @override
  void dispose() {
    child.dispose();
    super.dispose();
  }
}
