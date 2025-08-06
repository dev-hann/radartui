import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart' as input_key;
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

typedef VoidCallback = void Function();

class Button extends StatefulWidget {
  Button({
    super.key,
    required this.label,
    this.isFocused = false,
    this.style = const Style(),
    this.focusedStyle = const Style(inverted: true),
    this.onTap,
  });
  final String label;
  final bool isFocused;
  final Style style;
  final Style focusedStyle;
  final VoidCallback? onTap;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final ButtonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ButtonController(onTap: widget.onTap);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onKey: _handleKey,
      child: ButtonRenderWidget(
        label: widget.label,
        isFocused: widget.isFocused,
        style: widget.style,
        focusedStyle: widget.focusedStyle,
      ),
    );
  }

  void _handleKey(input_key.Key key) {
    _controller.onKey(key);
  }
}

class ButtonRenderWidget extends RenderObjectWidget {
  ButtonRenderWidget({
    super.key,
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
    (renderObject as ButtonRenderObject)
      ..label = label
      ..isFocused = isFocused
      ..style = style
      ..focusedStyle = focusedStyle;
  }

  @override
  void render(Canvas canvas, Rect rect) {
    (createRenderObject() as ButtonRenderObject).paint(canvas);
  }

  @override
  int preferredHeight(int width) {
    return 1;
  }

  @override
  int preferredWidth(int height) {
    return label.length + 4;
  }
}

class ButtonRenderObject extends RenderObject {
  ButtonRenderObject({
    required this.label,
    required this.isFocused,
    required this.style,
    required this.focusedStyle,
  });
  String label;
  bool isFocused;
  Style style;
  Style focusedStyle;

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

  @override
  int preferredHeight(int width) => 1;

  @override
  int preferredWidth(int height) => label.length + 4;
}

class ButtonController {
  ButtonController({this.onTap});
  final void Function()? onTap;

  void onKey(input_key.Key key) {
    if (key.type == KeyType.enter || key.label == ' ') {
      onTap?.call();
    }
  }
}


