import 'dart:math' as math;

import '../../../radartui.dart';

/// An immutable span of styled text with optional children.
///
/// Forms a tree of styled text segments. Each span can override [style]
/// from its parent. Use [plainText] to get the unstyled concatenation.
class TextSpan {
  /// Creates a [TextSpan] with optional [text], [children], and [style].
  const TextSpan({this.text, this.children, this.style});

  /// The text content of this span, or `null` if this is a container span.
  final String? text;

  /// Child spans that inherit this span's style.
  final List<TextSpan>? children;

  /// The text style applied to this span and inherited by children.
  final TextStyle? style;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextSpan &&
        other.text == text &&
        other.style == style &&
        _listEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hash(text, style, children);

  static bool _listEquals(List<TextSpan>? a, List<TextSpan>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    return List.generate(a.length, (i) => a[i] == b[i]).every((equal) => equal);
  }

  /// Returns the unstyled plain-text content of this span and its descendants.
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

  /// Recursively visits all descendant spans, calling [visitor] on each.
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
    return base.merge(overlay);
  }
}

class _StyledSegment {
  _StyledSegment(this.text, this.style);
  final String text;
  final TextStyle? style;
}

/// A widget that renders a [TextSpan] tree with mixed styles and line wrapping.
class RichText extends RenderObjectWidget {
  /// Creates a [RichText] widget with the given styled [text] span.
  const RichText({
    super.key,
    required this.text,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  /// The root span of the styled text tree to render.
  final TextSpan text;

  /// The maximum number of lines to display, or `null` for unlimited.
  final int? maxLines;

  /// How to handle text that overflows the [maxLines] limit.
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

/// Render object that lays out and paints a [TextSpan] tree with line wrapping.
class RenderRichText extends RenderBox {
  /// Creates a [RenderRichText] with the given text and overflow configuration.
  RenderRichText({
    required TextSpan text,
    int? maxLines,
    TextOverflow overflow = TextOverflow.clip,
  })  : _text = text,
        _maxLines = maxLines,
        _overflow = overflow;

  TextSpan _text;

  /// The styled text span to render.
  TextSpan get text => _text;

  /// Sets the text span and marks layout as needed.
  set text(TextSpan value) {
    if (_text == value) return;
    _text = value;
    markNeedsLayout();
  }

  int? _maxLines;

  /// The maximum number of lines, or `null` for unlimited.
  int? get maxLines => _maxLines;

  /// Sets the max lines and marks layout as needed.
  set maxLines(int? value) {
    if (_maxLines == value) return;
    _maxLines = value;
    markNeedsLayout();
  }

  TextOverflow _overflow;

  /// The text overflow handling strategy.
  TextOverflow get overflow => _overflow;

  /// Sets the overflow strategy and marks layout as needed.
  set overflow(TextOverflow value) {
    if (_overflow == value) return;
    _overflow = value;
    markNeedsLayout();
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
    return _lines.fold(0, (max, line) => math.max(max, line.length));
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

    for (final entry in segmentLines.asMap().entries) {
      if (entry.key > 0) {
        lines.add(currentLine);
        currentLine = _StyledLine.empty();
        currentX = 0;
      }

      currentLine = _wrapSegmentText(
        entry.value,
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
      currentLine = _addSegmentLines(segment, lines, currentLine);
    }

    lines.add(currentLine);
    return lines;
  }

  _StyledLine _addSegmentLines(
    _StyledSegment segment,
    List<_StyledLine> lines,
    _StyledLine currentLine,
  ) {
    final segmentLines = segment.text.split('\n');
    for (final entry in segmentLines.asMap().entries) {
      if (entry.key > 0) {
        lines.add(currentLine);
        currentLine = _StyledLine.empty();
      }
      currentLine.add(entry.value, segment.style);
    }
    return currentLine;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final entry in _lines.asMap().entries) {
      final line = entry.value;
      int x = offset.x;
      final int y = offset.y + entry.key;
      for (final run in line.runs) {
        x = _paintRun(context, x, y, run);
      }
    }
  }

  int _paintRun(PaintingContext context, int x, int y, _StyledRun run) {
    return context.writeString(x, y, run.text, run.effectiveStyle);
  }
}

class _StyledRun {
  _StyledRun(this.text, this.style)
      : effectiveStyle = style ?? const TextStyle();
  final String text;
  final TextStyle? style;
  final TextStyle effectiveStyle;
}

class _StyledLine {
  _StyledLine._(this.runs, [this._length = 0]);

  factory _StyledLine.empty() => _StyledLine._([]);
  factory _StyledLine.ellipsis() => _StyledLine._([_StyledRun('...', null)], 3);

  final List<_StyledRun> runs;
  int _length;

  int get length => _length;

  void add(String text, TextStyle? style) {
    if (text.isEmpty) return;
    runs.add(_StyledRun(text, style));
    _length += text.length;
  }

  _StyledLine copyWithEllipsis() {
    int totalLength = _length;
    final newRuns = <_StyledRun>[];

    for (final run in runs) {
      if (totalLength <= 3) break;
      final result = _appendRunOrTrim(run, newRuns, totalLength);
      totalLength = result.$1;
      if (!result.$2) break;
    }

    newRuns.add(_StyledRun('...', null));
    return _StyledLine._(newRuns, 3);
  }

  (int, bool) _appendRunOrTrim(
    _StyledRun run,
    List<_StyledRun> newRuns,
    int totalLength,
  ) {
    if (run.text.length + 3 <= totalLength) {
      newRuns.add(run);
      return (totalLength - run.text.length, true);
    }
    final keep = run.text.length - (totalLength - 3);
    if (keep > 0) {
      newRuns.add(_StyledRun(run.text.substring(0, keep), run.style));
    }
    return (3, false);
  }
}
