import 'dart:async';

import 'package:collection/collection.dart';
import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/input/input.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:radartui/widget/focus_node.dart';

export './text.dart';
export './column.dart';
export './card.dart';
export './list_view.dart';

abstract class Widget {
  Widget({this.key, this.focusID = ''});
  final String? key;
  FocusNode get _focusNode => FocusNode(focusID: focusID);
  bool get hasFocus {
    final focusNode = FocusManager.instance.focusNodeList.firstWhereOrNull(
      (element) => element.focusID == focusID,
    );
    return focusNode?.hasFocus ?? false;
  }

  bool get isFocusable => focusID.isNotEmpty;
  final String focusID;

  void render(Canvas canvs, Rect rect);

  int preferredHeight(int width);

  bool shouldUpdate(covariant Widget oldWidget);

  StreamSubscription? _subscription;

  void onKey(Key key) {}

  void onMount() {
    if (focusID.isNotEmpty) {
      _subscription?.cancel();
      _subscription = Input.instance.stream.listen(onKey);
      FocusManager.instance.registerFocusNode(_focusNode);
    }
  }

  void onUnmount() {
    if (focusID.isNotEmpty) {
      _subscription?.cancel();
      FocusManager.instance.unregisterFocusNode(_focusNode);
    }
  }
}

abstract class SingleChildWidget extends Widget {
  SingleChildWidget({required this.child, super.focusID = ''});
  final Widget child;

  @override
  void onMount() {
    child.onMount();
  }

  @override
  void onUnmount() {
    child.onUnmount();
  }

  @override
  bool shouldUpdate(covariant SingleChildWidget oldWidget) {
    return child.shouldUpdate(oldWidget.child);
  }
}

abstract class MultiChildWidget extends Widget {
  MultiChildWidget({required this.children, super.focusID = ''});
  final List<Widget> children;

  @override
  bool shouldUpdate(covariant MultiChildWidget oldWidget) {
    if (children.length != oldWidget.children.length) return true;
    for (int i = 0; i < children.length; i++) {
      if (children[i].shouldUpdate(oldWidget.children[i])) {
        return true;
      }
    }
    return false;
  }

  @override
  void onMount() {
    for (final child in children) {
      child.onMount();
    }
  }

  @override
  void onUnmount() {
    for (final child in children) {
      child.onUnmount();
    }
  }
}

abstract class LeafWidget extends Widget {
  LeafWidget({super.focusID = ''});

  @override
  void onMount();

  @override
  void onUnmount();

  @override
  bool shouldUpdate(covariant LeafWidget oldWidget);
}
