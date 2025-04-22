import 'dart:async';

import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
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
  StreamSubscription<String>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = focusNode.keyStream.listen(onKey);
  }

  void onKey(String key);
  @override
  void dispose() {
    focusNode.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
