import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

class TextEditingController {
  TextEditingController({String? text}) : _text = text ?? '';

  String _text;
  int _cursorIndex = 0;

  String get text => _text;
  set text(String value) {
    _text = value;
    _cursorIndex = value.length;
  }

  int get cursorIndex => _cursorIndex;
  set cursorIndex(int index) {
    _cursorIndex = index.clamp(0, _text.length);
  }

  void insert(String char) {
    _text =
        _text.substring(0, _cursorIndex) + char + _text.substring(_cursorIndex);
    _cursorIndex++;
  }

  void deleteBack() {
    if (_cursorIndex > 0) {
      _text =
          _text.substring(0, _cursorIndex - 1) + _text.substring(_cursorIndex);
      _cursorIndex--;
    }
  }

  void moveLeft() {
    if (_cursorIndex > 0) _cursorIndex--;
  }

  void moveRight() {
    if (_cursorIndex < _text.length) _cursorIndex++;
  }

  void onKey(Key key) {
    switch (key.type) {
      case KeyType.tab:
        break;
      case KeyType.char:
        if (!key.ctrl && !key.alt && !key.meta) {
          insert(key.label);
          // onChanged?.call(_ctrl.text);
        }
        break;
      case KeyType.backspace:
        deleteBack();
        // onChanged?.call(_ctrl.text);
        break;
      case KeyType.left:
        moveLeft();
        break;
      case KeyType.right:
        moveRight();
        break;
      case KeyType.enter:
        // onSubmitted?.call(_ctrl.text);
        break;
      default:
        break;
    }
  }
}

class TextField extends LeafWidget {
  TextField({
    required super.focusID,
    required this.controller,
    this.style = const Style(),
    this.focusedStyle = const Style(bold: true, underLine: true),
    this.onChanged,
    this.onSubmitted,
  });

  final Style style;
  final Style focusedStyle;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  void render(Canvas canvas, Rect rect) {
    super.render(canvas, rect);
    final displayText = controller.text;
    final cursorIndex = controller.cursorIndex.clamp(0, displayText.length);

    final renderText =
        isFocused
            ? '${displayText.substring(0, cursorIndex)}|${displayText.substring(cursorIndex)}'
            : displayText;

    canvas.move(rect.x, rect.y);
    canvas.setStyle(isFocused ? focusedStyle : style);
    for (int i = 0; i < renderText.length; i++) {
      canvas.drawChar(renderText[i], style: isFocused ? focusedStyle : style);
    }
    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => 1;

  String get value => controller.text;

  @override
  bool shouldUpdate(covariant TextField oldWidget) {
    return controller.text != oldWidget.controller.text ||
        style != oldWidget.style ||
        focusedStyle != oldWidget.focusedStyle;
  }
}
