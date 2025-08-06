import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/enum/text/text_align.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Text extends RenderObjectWidget {
  const Text(this.data, {super.key, this.textAlign = TextAlign.left, this.style});
  final String data;
  final TextAlign textAlign;
  final Style? style;

  @override
  RenderObject createRenderObject() {
    return RenderText(
      data: data,
      textAlign: textAlign,
      style: style,
    );
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderText).data = data;
    (renderObject as RenderText).textAlign = textAlign;
    (renderObject as RenderText).style = style;
  }
}

class RenderText extends RenderObject {
  RenderText({
    required this.data,
    required this.textAlign,
    this.style,
  });
  String data;
  TextAlign textAlign;
  Style? style;

  @override
  void paint(Canvas canvas) {
    final maxWidth = layoutRect.width;
    final maxLines = layoutRect.height;
    int currentLine = 0;
    String remaining = data;

    final lines = <String>[];

    while (remaining.isNotEmpty && currentLine < maxLines) {
      if (remaining.length <= maxWidth) {
        lines.add(remaining);
        break;
      }
      lines.add(remaining.substring(0, maxWidth));
      remaining = remaining.substring(maxWidth);
      currentLine++;
    }

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final xOffset = switch (textAlign) {
        TextAlign.left => 0,
        TextAlign.center => ((maxWidth - line.length) / 2).floor(),
        TextAlign.right => maxWidth - line.length,
      };
      canvas.move(layoutRect.x + xOffset, layoutRect.y + i);
      canvas.drawChar(line, style: style);
    }
  }

  @override
  int preferredHeight(int width) {
    return (data.length / width).ceil();
  }
}