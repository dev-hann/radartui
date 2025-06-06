import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Button extends RenderObjectWidget {
  Button({
    required this.label,
    this.isFocused = false,
    this.style = const Style(),
    this.focusedStyle = const Style(inverted: true),
  });
  final String label;
  final bool isFocused;
  final Style style;
  final Style focusedStyle;

  @override
  RenderObject createRenderObject() {
    return ButtonRenderObject(
      label: label,
      isFocused: isFocused,
      style: style,
      focusedStyle: focusedStyle,
    );
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    // TODO: implement updateRenderObject
  }
}

class ButtonRenderObject extends RenderObject {
  ButtonRenderObject({
    required this.label,
    required this.isFocused,
    required this.style,
    required this.focusedStyle,
  });
  final String label;
  final bool isFocused;
  final Style style;
  final Style focusedStyle;

  @override
  void paint(Canvas canvas) {
    final text = '[ $label ]';
    final displayStyle = isFocused ? focusedStyle : style;

    canvas.move(layoutRect.x, layoutRect.y);
    canvas.setStyle(displayStyle);
    for (int i = 0; i < text.length; i++) {
      canvas.drawChar(text[i], style: displayStyle);
    }
    canvas.clearStyle();
  }
}

class ButtonController {
  ButtonController({this.onTap});
  final void Function()? onTap;

  void onKey(Key key) {
    if (key.type == KeyType.enter || key.label == ' ') {
      onTap?.call();
    }
  }
}

class ButtonOld extends LeafWidget {
  ButtonOld({
    required super.focusID,
    required this.label,
    required this.controller,
    this.style = const Style(),
    this.focusedStyle = const Style(inverted: true),
  });

  final String label;
  final Style style;
  final Style focusedStyle;
  final ButtonController controller;

  @override
  void render(Canvas canvas, Rect rect) {
    super.render(canvas, rect);
    final text = '[ $label ]';
    final displayStyle = isFocused ? focusedStyle : style;

    canvas.move(rect.x, rect.y);
    canvas.setStyle(displayStyle);
    for (int i = 0; i < text.length; i++) {
      canvas.drawChar(text[i], style: displayStyle);
    }
    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => 1;

  @override
  bool shouldUpdate(covariant ButtonOld oldWidget) {
    return label != oldWidget.label ||
        style != oldWidget.style ||
        focusedStyle != oldWidget.focusedStyle;
  }
}
