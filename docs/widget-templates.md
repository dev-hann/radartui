# Widget Templates

Reference templates for implementing RadarTUI widgets.

## StatelessWidget

```dart
class MyWidget extends StatelessWidget {
  final Widget child;

  const MyWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
```

## StatefulWidget

```dart
class MyWidget extends StatefulWidget {
  final String value;

  const MyWidget({required this.value});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_value);
  }
}
```

## RenderObjectWidget

```dart
class MyRenderWidget extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;

  const MyRenderWidget({
    required this.padding,
    required Widget child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject() {
    return RenderMyRender(padding);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderMyRender).padding = padding;
  }
}

class RenderMyRender extends RenderBox with RenderObjectWithChildMixin {
  EdgeInsets _padding;

  RenderMyRender(this._padding);

  EdgeInsets get padding => _padding;
  set padding(EdgeInsets value) {
    if (_padding != value) {
      _padding = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    // Layout logic
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paint logic
  }
}
```
