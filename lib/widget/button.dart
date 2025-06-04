import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

class ButtonController {
  ButtonController({this.onTap});
  final void Function()? onTap;

  void onKey(Key key) {
    if (key.type == KeyType.enter || key.label == ' ') {
      onTap?.call();
    }
  }
}

class Button extends LeafWidget {
  Button({
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
  bool shouldUpdate(covariant Button oldWidget) {
    return label != oldWidget.label ||
        style != oldWidget.style ||
        focusedStyle != oldWidget.focusedStyle;
  }
}
