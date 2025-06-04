import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/model/key.dart';

export './text.dart';
export './column.dart';
export './card.dart';
export './list_view.dart';

abstract class Widget {
  Widget({this.key});
  final String? key;

  void render(Canvas canvs, Rect rect);

  int preferredHeight(int width);

  bool shouldUpdate(covariant Widget oldWidget);

  void onKey(Key key) {}

  void onMount() {}

  void onUnmount() {}
}

abstract class SingleChildWidget extends Widget {
  SingleChildWidget({required this.child});
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
  MultiChildWidget({required this.children});
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
  LeafWidget();

  @override
  void onMount();

  @override
  void onUnmount();

  @override
  bool shouldUpdate(covariant LeafWidget oldWidget);
}
