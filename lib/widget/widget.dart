import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/element.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:meta/meta.dart';

export './text.dart';
export './column.dart';
export './card.dart';
export './list_view.dart';

abstract class Widget {
  const Widget();

  Element createElement();

  bool shouldUpdate(covariant Widget oldWidget) => true;
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget();

  Widget build();

  @override
  StatelessElement createElement() => StatelessElement(this);
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget();

  State createState();

  @override
  StatefulElement createElement() => StatefulElement(this);
}

abstract class State<T extends StatefulWidget> {
  late T widget;

  void initState() {}
  void dispose() {}

  Widget build();
}

///
///
///
///

abstract class WidgetOld {
  WidgetOld({this.key, this.focusID = ""});
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

  bool shouldUpdate(covariant WidgetOld oldWidget);
}

abstract class SingleChildWidget extends WidgetOld {
  SingleChildWidget({required this.child, required super.focusID});
  final WidgetOld child;

  @override
  bool shouldUpdate(covariant SingleChildWidget oldWidget) {
    return child.shouldUpdate(oldWidget.child);
  }
}

abstract class MultiChildWidget extends WidgetOld {
  MultiChildWidget({required this.children, required super.focusID});
  final List<WidgetOld> children;

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

abstract class LeafWidget extends WidgetOld {
  LeafWidget({required super.focusID});

  @override
  bool shouldUpdate(covariant LeafWidget oldWidget);
}
