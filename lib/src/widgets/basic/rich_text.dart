import '../../../radartui.dart';

/// An immutable span of styled text with optional children.
///
/// Forms a tree of styled text segments. Each span can override [style]
/// from its parent. Use [plainText] to get the unstyled concatenation.
class TextSpan {
  const TextSpan({this.text, this.children, this.style});

  final String? text;
  final List<TextSpan>? children;
  final TextStyle? style;

  String get plainText {
    final buffer = StringBuffer();
    _collectPlainText(buffer);
    return buffer.toString();
  }

  void _collectPlainText(StringBuffer buffer) {
    if (text != null) {
      buffer.write(text);
    }
    if (children != null) {
      for (final child in children!) {
        child._collectPlainText(buffer);
      }
    }
  }

  void visitChildren(void Function(TextSpan) visitor) {
    if (children != null) {
      for (final child in children!) {
        visitor(child);
        child.visitChildren(visitor);
      }
    }
  }

  void _collectStyledSegments(
    List<_StyledSegment> segments,
    TextStyle? parentStyle,
  ) {
    final effectiveStyle = _mergeStyles(parentStyle, style);

    if (text != null && text!.isNotEmpty) {
      segments.add(_StyledSegment(text!, effectiveStyle));
    }

    if (children != null) {
      for (final child in children!) {
        child._collectStyledSegments(segments, effectiveStyle);
      }
    }
  }

  static TextStyle? _mergeStyles(TextStyle? base, TextStyle? overlay) {
    if (base == null) return overlay;
    if (overlay == null) return base;

    return TextStyle(
      color: overlay.color ?? base.color,
      backgroundColor: overlay.backgroundColor ?? base.backgroundColor,
      bold: overlay.bold || base.bold,
      italic: overlay.italic || base.italic,
      underline: overlay.underline || base.underline,
      fontFamily: overlay.fontFamily != FontFamily.monospace
          ? overlay.fontFamily
          : base.fontFamily,
    );
  }
}

class _StyledSegment {
  _StyledSegment(this.text, this.style);
  final String text;
  final TextStyle? style;
}

class RichText extends RenderObjectWidget {
  const RichText({
    super.key,
    required this.text,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  final TextSpan text;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRichText(text: text, maxLines: maxLines, overflow: overflow);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderRichText = renderObject as RenderRichText;
    renderRichText.text = text;
    renderRichText.maxLines = maxLines;
    renderRichText.overflow = overflow;
  }
}

class RenderRichText extends RenderBox {
  RenderRichText({
    required TextSpan text,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  })  : _text = text,
        _maxLines = maxLines,
        _overflow = overflow;

  TextSpan _text;
  TextSpan get text => _text;
  set text(TextSpan value) {
    if (_text != value) {
      _text = value;
      markNeedsLayout();
    }
  }

  int? _maxLines;
  int? get maxLines => _maxLines;
  set maxLines(int? value) {
    if (_maxLines != value) {
      _maxLines = value;
      markNeedsLayout();
    }
  }

  TextOverflow _overflow;
  TextOverflow get overflow => _overflow;
  set overflow(TextOverflow value) {
    if (_overflow != value) {
      _overflow = value;
      markNeedsLayout();
    }
  }

  List<_StyledSegment> _segments = [];
  List<_StyledLine> _lines = [];

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final maxWidth = boxConstraints.maxWidth;

    _segments = [];
    _text._collectStyledSegments(_segments, null);

    _lines = _wrapLines(_segments, maxWidth);
    _applyOverflow();

    final computedWidth = _computeMaxLineWidth();
    final effectiveMaxHeight =
        boxConstraints.maxHeight > 0 ? boxConstraints.maxHeight : 1;
    final width = computedWidth.clamp(
      boxConstraints.minWidth,
      boxConstraints.maxWidth,
    );
    final height =
        _lines.isEmpty ? 1 : _lines.length.clamp(1, effectiveMaxHeight);

    size = Size(width, height);
  }

  void _applyOverflow() {
    if (_maxLines == null || _lines.length <= _maxLines!) return;
    _lines = _lines.sublist(0, _maxLines!);
    if (_overflow != TextOverflow.ellipsis || _lines.isEmpty) return;
    final lastLine = _lines.last;
    if (lastLine.length >= 3) {
      _lines[_lines.length - 1] = lastLine.copyWithEllipsis();
    } else {
      _lines[_lines.length - 1] = _StyledLine.ellipsis();
    }
  }

  int _computeMaxLineWidth() {
    int computedWidth = 0;
    for (final line in _lines) {
      if (line.length > computedWidth) {
        computedWidth = line.length;
      }
    }
    return computedWidth;
  }

  List<_StyledLine> _wrapLines(List<_StyledSegment> segments, int maxWidth) {
    if (maxWidth >= Constraints.infinity || maxWidth <= 0) {
      return _buildLinesWithoutWrap(segments);
    }

    final lines = <_StyledLine>[];
    _StyledLine currentLine = _StyledLine.empty();
    int currentX = 0;

    for (final segment in segments) {
      final result = _processSegment(
        segment,
        maxWidth,
        lines,
        currentLine,
        currentX,
      );
      currentLine = result.$1;
      currentX = result.$2;
    }

    if (currentLine.runs.isNotEmpty || lines.isEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  (_StyledLine, int) _processSegment(
    _StyledSegment segment,
    int maxWidth,
    List<_StyledLine> lines,
    _StyledLine currentLine,
    int currentX,
  ) {
    final segmentLines = segment.text.split('\n');

    for (int lineIdx = 0; lineIdx < segmentLines.length; lineIdx++) {
      if (lineIdx > 0) {
        lines.add(currentLine);
        currentLine = _StyledLine.empty();
        currentX = 0;
      }

      currentLine = _wrapSegmentText(
        segmentLines[lineIdx],
        segment.style,
        maxWidth,
        lines,
        currentLine,
        currentX,
      );
      currentX = currentLine.length;
    }

    return (currentLine, currentX);
  }

  _StyledLine _wrapSegmentText(
    String text,
    TextStyle? style,
    int maxWidth,
    List<_StyledLine> lines,
    _StyledLine currentLine,
    int currentX,
  ) {
    String remaining = text;
    while (remaining.isNotEmpty) {
      final available = maxWidth - currentX;

      if (remaining.length <= available) {
        currentLine.add(remaining, style);
        currentX += remaining.length;
        remaining = '';
      } else {
        if (available > 0) {
          currentLine.add(remaining.substring(0, available), style);
          remaining = remaining.substring(available);
        }
        lines.add(currentLine);
        currentLine = _StyledLine.empty();
        currentX = 0;
      }
    }
    return currentLine;
  }

  List<_StyledLine> _buildLinesWithoutWrap(List<_StyledSegment> segments) {
    final lines = <_StyledLine>[];
    _StyledLine currentLine = _StyledLine.empty();

    for (final segment in segments) {
      final segmentLines = segment.text.split('\n');

      for (int lineIdx = 0; lineIdx < segmentLines.length; lineIdx++) {
        if (lineIdx > 0) {
          lines.add(currentLine);
          currentLine = _StyledLine.empty();
        }
        currentLine.add(segmentLines[lineIdx], segment.style);
      }
    }

    lines.add(currentLine);
    return lines;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int lineIndex = 0; lineIndex < _lines.length; lineIndex++) {
      final line = _lines[lineIndex];
      int x = offset.x;

      for (final run in line.runs) {
        for (int charIdx = 0; charIdx < run.text.length; charIdx++) {
          context.buffer.writeStyled(
            x + charIdx,
            offset.y + lineIndex,
            run.text[charIdx],
            run.style,
          );
        }
        x += run.text.length;
      }
    }
  }
}

class _StyledRun {
  _StyledRun(this.text, this.style);
  final String text;
  final TextStyle? style;
}

class _StyledLine {
  _StyledLine._(this.runs);

  factory _StyledLine.empty() => _StyledLine._([]);
  factory _StyledLine.ellipsis() => _StyledLine._([_StyledRun('...', null)]);

  final List<_StyledRun> runs;

  int get length => runs.fold(0, (sum, run) => sum + run.text.length);

  void add(String text, TextStyle? style) {
    if (text.isEmpty) return;
    runs.add(_StyledRun(text, style));
  }

  _StyledLine copyWithEllipsis() {
    int totalLength = length;
    final newRuns = <_StyledRun>[];

    for (final run in runs) {
      if (totalLength <= 3) break;
      if (run.text.length + 3 <= totalLength) {
        newRuns.add(run);
        totalLength -= run.text.length;
      } else {
        final keep = run.text.length - (totalLength - 3);
        if (keep > 0) {
          newRuns.add(_StyledRun(run.text.substring(0, keep), run.style));
        }
        break;
      }
    }

    newRuns.add(_StyledRun('...', null));
    return _StyledLine._(newRuns);
  }
}
