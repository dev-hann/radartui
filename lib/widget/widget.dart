import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:meta/meta.dart';

export './text.dart';
export './column.dart';
export './card.dart';
export './list_view.dart';

abstract class Widget {
  Widget({this.key, this.focusID = ""});
  final String? key;
  final String focusID;
  bool get isFocused => FocusManager.instance.isFocused(focusID);

  @mustCallSuper
  void render(Canvas canvas, Rect rect) {
    if (focusID.isNotEmpty) {
      FocusManager.instance.registerFocus(focusID);
    }
  }

  int preferredHeight(int width);

  bool shouldUpdate(covariant Widget oldWidget);
}

abstract class SingleChildWidget extends Widget {
  SingleChildWidget({required this.child, required super.focusID});
  final Widget child;

  @override
  bool shouldUpdate(covariant SingleChildWidget oldWidget) {
    return child.shouldUpdate(oldWidget.child);
  }
}

abstract class MultiChildWidget extends Widget {
  MultiChildWidget({required this.children, required super.focusID});
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
}

abstract class LeafWidget extends Widget {
  LeafWidget({required super.focusID});

  @override
  bool shouldUpdate(covariant LeafWidget oldWidget);
}
