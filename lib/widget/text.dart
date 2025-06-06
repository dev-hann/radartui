import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/enum/text/text_align.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Text extends RenderObjectWidget {
  Text(this.data);
  final String data;

  @override
  RenderObject createRenderObject() {
    return TextRenderObjectWidget(data);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    // TODO: implement updateRenderObject
  }
}

class TextRenderObjectWidget extends RenderObject {
  TextRenderObjectWidget(
    this.data, {
    this.textAlign = TextAlign.left,
    this.style,
  });
  final String data;
  final TextAlign textAlign;
  final Style? style;

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
}

class TextOld extends LeafWidget {
  TextOld(this.text, {this.style, this.textAlign = TextAlign.left})
    : super(focusID: "");

  final String text;
  final Style? style;
  final TextAlign textAlign;

  @override
  void render(Canvas canvas, Rect rect) {
    super.render(canvas, rect);
    final maxWidth = rect.width;
    final maxLines = rect.height;
    int currentLine = 0;
    String remaining = text;

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
      canvas.move(rect.x + xOffset, rect.y + i);
      canvas.drawChar(line, style: style);
    }
  }

  @override
  int preferredHeight(int width) {
    return (text.length / width).ceil();
  }

  @override
  bool shouldUpdate(TextOld oldWidget) {
    return text != oldWidget.text || style != oldWidget.style;
  }
}
