import 'package:radartui/radartui.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';

class Text extends RenderObjectWidget {
  final String data;
  final TextStyle? style;
  const Text(this.data, {this.style});
  @override
  RenderObjectElement createElement() => RenderObjectElement(this);
  @override
  RenderText createRenderObject(BuildContext context) =>
      RenderText(data, style);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderText = renderObject as RenderText;
    renderText.text = data;
    renderText.style = style;
  }
}

class RenderText extends RenderBox {
  String text;
  TextStyle? style;
  RenderText(this.text, this.style);

  @override
  void performLayout(Constraints constraints) {
    size = Size(text.length, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < text.length; i++) {
      context.buffer.writeStyled(offset.x + i, offset.y, text[i], style);
    }
  }
}
