import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/widget.dart';

abstract class View extends Widget {
  late Canvas _canvas;
  late Rect _rect;
  Widget? _oldWidget;

  @override
  void onMount() {
    super.onMount();
    _oldWidget = build();
    _oldWidget!.onMount();
  }

  @override
  void onUnmount() {
    _oldWidget!.onUnmount();
  }

  void update() {
    render(_canvas, _rect);
  }

  Widget _reconcile(Widget? oldWidget, Widget newWidget) {
    if (oldWidget == null) {
      newWidget.onMount();
      return newWidget;
    }

    if (oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key &&
        !newWidget.shouldUpdate(oldWidget)) {
      return oldWidget; // 재사용
    } else {
      oldWidget.onUnmount();
      newWidget.onMount();
      return newWidget;
    }
  }

  @override
  void render(Canvas canvas, Rect rect) {
    _canvas = canvas;
    _rect = rect;

    final newWidget = build();
    _oldWidget = _reconcile(_oldWidget, newWidget);

    _oldWidget!.render(canvas, rect);
  }

  @override
  int preferredHeight(int width) {
    final newWidget = build();
    _oldWidget = _reconcile(_oldWidget, newWidget);

    return _oldWidget!.preferredHeight(width);
  }

  Widget build();

  @override
  bool shouldUpdate(covariant View oldWidget) {
    return true;
  }
}
