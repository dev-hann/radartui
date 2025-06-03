import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

class Button extends LeafWidget {
  Button({
    required super.focusID,
    required this.label,
    required this.onPressed,
    this.style = const Style(),
    this.focusedStyle = const Style(inverted: true),
  });

  final String label;
  final Function() onPressed;
  final Style style;
  final Style focusedStyle;

  @override
  void render(Canvas canvas, Rect rect) {
    final text = '[ $label ]';
    final displayStyle = hasFocus ? focusedStyle : style;

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
  void onKey(Key key) {
    if (!hasFocus) return;

    // Enter 또는 Space 누르면 onPressed 실행
    if (key.type == KeyType.enter || key.label == ' ') {
      onPressed();
    }
  }

  @override
  bool shouldUpdate(covariant Button oldWidget) {
    return label != oldWidget.label ||
        onPressed != oldWidget.onPressed ||
        style != oldWidget.style ||
        focusedStyle != oldWidget.focusedStyle;
  }
}
