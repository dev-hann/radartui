import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';

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

abstract class SingleChildWidget extends Widget {
  SingleChildWidget({required this.child});
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

abstract class MultiChildWidget extends Widget {
  MultiChildWidget({required this.children});
  final List<Widget> children;

  @override
  void initState() {
    super.initState();
    for (final child in children) {
      child.initState();
    }
  }

  @override
  void dispose() {
    for (final child in children) {
      child.dispose();
    }
  }
}
