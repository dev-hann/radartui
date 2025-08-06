import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart' as input_key;
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/widget/widget.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';

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

  void onKey(input_key.Key key) {
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

class TextField extends RenderObjectWidget {
  const TextField({
    super.key,
    required this.controller,
    this.style,
    this.cursorStyle,
  });

  final TextEditingController controller;
  final Style? style;
  final Style? cursorStyle;

  @override
  RenderObject createRenderObject() {
    return RenderTextField(
      controller: controller,
      style: style,
      cursorStyle: cursorStyle,
    );
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderTextField).controller = controller;
    (renderObject as RenderTextField).style = style;
    (renderObject as RenderTextField).cursorStyle = cursorStyle;
  }
}

class RenderTextField extends RenderObject {
  RenderTextField({required this.controller, this.style, this.cursorStyle});

  TextEditingController controller;
  Style? style;
  Style? cursorStyle;

  @override
  void paint(Canvas canvas) {
    final displayText = controller.text;
    final cursorIndex = controller.cursorIndex.clamp(0, displayText.length);

    final renderText =
        '${displayText.substring(0, cursorIndex)}|${displayText.substring(cursorIndex)}';

    canvas.move(layoutRect.x, layoutRect.y);
    canvas.setStyle(style ?? Style());
    for (int i = 0; i < renderText.length; i++) {
      canvas.drawChar(renderText[i], style: style ?? Style());
    }
    canvas.clearStyle();
  }
}
