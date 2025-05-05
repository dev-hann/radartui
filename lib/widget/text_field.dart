import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/widget/focusable_mixin.dart';
import 'package:radartui/widget/widget.dart';

class TextField extends Widget with FocusableMixin {
  TextField({
    this.hintText = '',
    this.style = const Style(),
    this.focusedStyle = const Style(bold: true, underLine: true),
  });

  final String hintText;
  final Style style;
  final Style focusedStyle;

  String _text = '';
  int _cursorIndex = 0;

  @override
  void render(Canvas canvas, Rect rect) {
    final hasFocus = focusNode.hasFocus;
    final displayText = _text.isEmpty ? hintText : _text;

    String renderText;
    if (hasFocus) {
      // 커서를 표시
      renderText =
          '${displayText.substring(0, _cursorIndex)}|${displayText.substring(_cursorIndex)}';
    } else {
      renderText = displayText;
    }

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
        _text =
            _text.substring(0, _cursorIndex) +
            key.label +
            _text.substring(_cursorIndex);
        _cursorIndex++;
        break;
      case KeyType.backspace:
        if (_cursorIndex > 0) {
          _text =
              _text.substring(0, _cursorIndex - 1) +
              _text.substring(_cursorIndex);
          _cursorIndex--;
        }
        break;
      case KeyType.left:
        if (_cursorIndex > 0) _cursorIndex--;
        break;
      case KeyType.right:
        if (_cursorIndex < _text.length) _cursorIndex++;
        break;
      default:
        break;
    }
  }

  String get value => _text;
}
