import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/widget/text_field_controller.dart';
import 'package:radartui/widget/widget.dart';

class TextField extends FocusableWidget {
  TextField({
    this.hintText = '',
    this.controller,
    this.style = const Style(),
    this.focusedStyle = const Style(bold: true, underLine: true),
    this.onChanged,
    this.onSubmitted,
  });

  final String hintText;
  final Style style;
  final Style focusedStyle;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  late final _internalController =
      controller ?? TextEditingController(); // 내부 컨트롤러

  TextEditingController get _ctrl => _internalController;

  @override
  void render(Canvas canvas, Rect rect) {
    final hasFocus = focusNode.hasFocus;
    final displayText = _ctrl.text.isEmpty ? hintText : _ctrl.text;
    final cursorIndex = _ctrl.cursorIndex.clamp(0, displayText.length);

    final renderText =
        hasFocus
            ? '${displayText.substring(0, cursorIndex)}|${displayText.substring(cursorIndex)}'
            : displayText;

    canvas.move(rect.x, rect.y);
    canvas.setStyle(hasFocus ? focusedStyle : style);
    for (int i = 0; i < renderText.length; i++) {
      canvas.drawChar(renderText[i], style: hasFocus ? focusedStyle : style);
    }
    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => 1;

  @override
  void onKey(Key key) {
    if (!focusNode.hasFocus) return;

    switch (key.type) {
      case KeyType.tab:
        break;
      case KeyType.char:
        if (!key.ctrl && !key.alt && !key.meta) {
          _ctrl.insert(key.label);
          onChanged?.call(_ctrl.text);
        }
        break;
      case KeyType.backspace:
        _ctrl.deleteBack();
        onChanged?.call(_ctrl.text);
        break;
      case KeyType.left:
        _ctrl.moveLeft();
        break;
      case KeyType.right:
        _ctrl.moveRight();
        break;
      case KeyType.enter:
        onSubmitted?.call(_ctrl.text);
        break;
      default:
        break;
    }
  }

  String get value => _ctrl.text;

  @override
  bool shouldUpdate(covariant TextField oldWidget) {
    return _ctrl.text != oldWidget._ctrl.text ||
        style != oldWidget.style ||
        focusedStyle != oldWidget.focusedStyle;
  }
}
