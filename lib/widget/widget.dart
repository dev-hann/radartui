import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/element.dart';
import 'package:radartui/widget/focus_manager.dart';
import 'package:meta/meta.dart';

export './text.dart';
export './column.dart';
export './row.dart';
export './card.dart';
export './list_view.dart';
export './layout_widget.dart';
export './inherited_widget.dart';
export './gesture_detector.dart';
export './element.dart' show BuildContext;

abstract class WidgetKey {
  const WidgetKey(this.value);
  final String value;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is WidgetKey && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class ValueKey<T> extends WidgetKey {
  ValueKey(T value) : super(value.toString());
}

class ObjectKey extends WidgetKey {
  ObjectKey(Object object) : super(object.toString());
}

abstract class Widget {
  const Widget({this.key});

  final WidgetKey? key;

  Element createElement();

  bool shouldUpdate(covariant Widget oldWidget) => 
      runtimeType == oldWidget.runtimeType && key == oldWidget.key;
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});

  Widget build(BuildContext context);

  @override
  StatelessElement createElement() => StatelessElement(this);
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key});

  State createState();

  @override
  StatefulElement createElement() => StatefulElement(this);
}

abstract class State<T extends StatefulWidget> {
  late T widget;
  StatefulElement? _element;

  BuildContext get context => _element!;

  bool get mounted => _element != null;

  void initState() {}
  void dispose() {
    _element = null;
  }
  void didUpdateWidget(covariant T oldWidget) {}

  Widget build(BuildContext context);

  void setState(VoidCallback fn) {
    fn();
    _element?.markNeedsBuild();
  }

  void setElement(StatefulElement element) {
    _element = element;
  }
}

typedef VoidCallback = void Function();


