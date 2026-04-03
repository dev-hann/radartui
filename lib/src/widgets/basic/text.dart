import '../../../radartui.dart';

enum TextOverflow { clip, ellipsis, fade }

class Text extends RenderObjectWidget {
  const Text(
    this.data, {
    super.key,
    this.style,
    this.softWrap = true,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });
  final String data;
  final TextStyle? style;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderText createRenderObject(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context);
    final effectiveStyle = defaultStyle.merge(style);
    return RenderText(
      text: data,
      style: effectiveStyle,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final defaultStyle = DefaultTextStyle.of(context);
    final effectiveStyle = defaultStyle.merge(style);
    final renderText = renderObject as RenderText;
    renderText.text = data;
    renderText.style = effectiveStyle;
    renderText.softWrap = softWrap;
    renderText.maxLines = maxLines;
    renderText.overflow = overflow;
  }
}

class RenderText extends RenderBox {
  RenderText({
    required this.text,
    this.style,
    this.softWrap = true,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });
  String text;
  TextStyle? style;
  bool softWrap;
  int? maxLines;
  TextOverflow overflow;
  List<String> _lines = [];

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final maxWidth = boxConstraints.maxWidth;

    _lines = _wrapText(text, maxWidth);

    if (maxLines != null && _lines.length > maxLines!) {
      _lines = _lines.sublist(0, maxLines!);
      if (overflow == TextOverflow.ellipsis && _lines.isNotEmpty) {
        final lastLine = _lines.last;
        if (lastLine.length >= 3) {
          _lines[_lines.length - 1] =
              '${lastLine.substring(0, lastLine.length - 3)}...';
        } else {
          _lines[_lines.length - 1] = '...';
        }
      }
    }

    int computedWidth = 0;
    for (final line in _lines) {
      if (line.length > computedWidth) {
        computedWidth = line.length;
      }
    }

    final effectiveMaxHeight =
        boxConstraints.maxHeight > 0 ? boxConstraints.maxHeight : 1;
    final width = computedWidth.clamp(
      boxConstraints.minWidth,
      boxConstraints.maxWidth,
    );
    final height = _lines.length.clamp(1, effectiveMaxHeight);

    size = Size(width, height);
  }

  List<String> _wrapText(String text, int maxWidth) {
    if (maxWidth >= Constraints.infinity || maxWidth <= 0) {
      return text.isEmpty ? [''] : text.split('\n');
    }

    final lines = <String>[];
    final paragraphs = text.split('\n');

    for (final paragraph in paragraphs) {
      if (paragraph.isEmpty) {
        lines.add('');
      } else if (paragraph.length <= maxWidth) {
        lines.add(paragraph);
      } else if (softWrap) {
        lines.addAll(_wrapParagraph(paragraph, maxWidth));
      } else {
        lines.add(paragraph.substring(0, maxWidth));
      }
    }

    return lines.isEmpty ? [''] : lines;
  }

  List<String> _wrapParagraph(String paragraph, int maxWidth) {
    final wrappedLines = <String>[];
    int start = 0;
    while (start < paragraph.length) {
      final int end = start + maxWidth;
      if (end >= paragraph.length) {
        wrappedLines.add(paragraph.substring(start));
        break;
      }

      final int lastSpace = paragraph.lastIndexOf(' ', end);
      if (lastSpace > start) {
        wrappedLines.add(paragraph.substring(start, lastSpace));
        start = lastSpace + 1;
      } else {
        wrappedLines.add(paragraph.substring(start, end));
        start = end;
      }
    }
    return wrappedLines;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int lineIndex = 0; lineIndex < _lines.length; lineIndex++) {
      final line = _lines[lineIndex];
      for (int charIndex = 0; charIndex < line.length; charIndex++) {
        context.buffer.writeStyled(
          offset.x + charIndex,
          offset.y + lineIndex,
          line[charIndex],
          style,
        );
      }
    }
  }
}
