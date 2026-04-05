import '../../../radartui.dart';

/// How text overflow should be handled.
enum TextOverflow { clip, ellipsis, fade }

/// A run of text with optional styling.
///
/// Displays [data] in the terminal using the given [style]. Supports
/// [softWrap], [maxLines], and [TextOverflow] modes.
class Text extends RenderObjectWidget {
  /// Creates a [Text] widget displaying [data] with optional [style].
  const Text(
    this.data, {
    super.key,
    this.style,
    this.softWrap = true,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  /// The text string to display.
  final String data;

  /// The style applied to the text.
  final TextStyle? style;

  /// Whether the text should wrap at word boundaries.
  final bool softWrap;

  /// The maximum number of lines to display, or `null` for unlimited.
  final int? maxLines;

  /// How visual overflow should be handled.
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

/// Render object that lays out and paints plain text with wrapping and overflow.
class RenderText extends RenderBox {
  /// Creates a [RenderText] with the given text content and display configuration.
  RenderText({
    required String text,
    TextStyle? style,
    bool softWrap = true,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  })  : _text = text,
        _style = style,
        _softWrap = softWrap,
        _maxLines = maxLines,
        _overflow = overflow;

  String _text;

  /// The text string to render.
  String get text => _text;

  /// Sets the text and marks the render object as needing layout.
  set text(String v) {
    if (_text == v) return;
    _text = v;
    markNeedsLayout();
  }

  TextStyle? _style;

  /// The text style to apply.
  TextStyle? get style => _style;

  /// Sets the text style and marks the render object as needing paint.
  set style(TextStyle? v) {
    if (_style == v) return;
    _style = v;
    markNeedsPaint();
  }

  bool _softWrap;

  /// Whether to wrap text at word boundaries.
  bool get softWrap => _softWrap;

  /// Sets the soft wrap flag and marks the render object as needing layout.
  set softWrap(bool v) {
    if (_softWrap == v) return;
    _softWrap = v;
    markNeedsLayout();
  }

  int? _maxLines;

  /// The maximum number of lines, or `null` for unlimited.
  int? get maxLines => _maxLines;

  /// Sets the max lines and marks the render object as needing layout.
  set maxLines(int? v) {
    if (_maxLines == v) return;
    _maxLines = v;
    markNeedsLayout();
  }

  TextOverflow _overflow;

  /// How visual overflow is handled.
  TextOverflow get overflow => _overflow;

  /// Sets the overflow mode and marks the render object as needing layout.
  set overflow(TextOverflow v) {
    if (_overflow == v) return;
    _overflow = v;
    markNeedsLayout();
  }

  List<String> _lines = [];

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final maxWidth = boxConstraints.maxWidth;

    _lines = _wrapText(text, maxWidth);
    _applyOverflow();

    final computedWidth = _maxLineWidth();
    final effectiveMaxHeight =
        boxConstraints.maxHeight > 0 ? boxConstraints.maxHeight : 1;
    final width = computedWidth.clamp(
      boxConstraints.minWidth,
      boxConstraints.maxWidth,
    );
    final height = _lines.length.clamp(1, effectiveMaxHeight);

    size = Size(width, height);
  }

  void _applyOverflow() {
    if (maxLines == null || _lines.length <= maxLines!) return;
    _lines = _lines.sublist(0, maxLines!);
    if (overflow != TextOverflow.ellipsis || _lines.isEmpty) return;

    final lastLine = _lines.last;
    if (lastLine.length >= 3) {
      _lines[_lines.length - 1] =
          '${lastLine.substring(0, lastLine.length - 3)}...';
    } else {
      _lines[_lines.length - 1] = '...';
    }
  }

  int _maxLineWidth() {
    int computedWidth = 0;
    for (final line in _lines) {
      if (line.length > computedWidth) {
        computedWidth = line.length;
      }
    }
    return computedWidth;
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
    final TextStyle effectiveStyle = style ?? const TextStyle();
    for (int lineIndex = 0; lineIndex < _lines.length; lineIndex++) {
      final line = _lines[lineIndex];
      if (line.isNotEmpty) {
        context.writeString(
          offset.x,
          offset.y + lineIndex,
          line,
          effectiveStyle,
        );
      }
    }
  }
}
