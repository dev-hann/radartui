import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('TextSpan', () {
    group('constructor', () {
      test('creates with text only', () {
        const span = TextSpan(text: 'Hello');
        expect(span.text, equals('Hello'));
        expect(span.children, isNull);
        expect(span.style, isNull);
      });

      test('creates with style only', () {
        const style = TextStyle(color: Color.red, bold: true);
        const span = TextSpan(style: style);
        expect(span.text, isNull);
        expect(span.style, equals(style));
      });

      test('creates with children only', () {
        const span = TextSpan(
          children: [
            TextSpan(text: 'Hello'),
            TextSpan(text: ' '),
            TextSpan(text: 'World'),
          ],
        );
        expect(span.text, isNull);
        expect(span.children?.length, equals(3));
      });

      test('creates with all properties', () {
        const style = TextStyle(color: Color.blue);
        const span = TextSpan(
          text: 'Root',
          style: style,
          children: [TextSpan(text: 'Child')],
        );
        expect(span.text, equals('Root'));
        expect(span.style, equals(style));
        expect(span.children?.length, equals(1));
      });
    });

    group('plainText', () {
      test('returns text for single span', () {
        const span = TextSpan(text: 'Hello');
        expect(span.plainText, equals('Hello'));
      });

      test('returns empty string for empty span', () {
        const span = TextSpan();
        expect(span.plainText, equals(''));
      });

      test('concatenates children text', () {
        const span = TextSpan(
          children: [
            TextSpan(text: 'Hello'),
            TextSpan(text: ' '),
            TextSpan(text: 'World'),
          ],
        );
        expect(span.plainText, equals('Hello World'));
      });

      test('concatenates root and children text', () {
        const span = TextSpan(
          text: 'Start ',
          children: [
            TextSpan(text: 'Middle '),
            TextSpan(text: 'End'),
          ],
        );
        expect(span.plainText, equals('Start Middle End'));
      });

      test('handles deeply nested spans', () {
        const span = TextSpan(
          children: [
            TextSpan(
              text: 'A',
              children: [
                TextSpan(
                  text: 'B',
                  children: [TextSpan(text: 'C')],
                ),
              ],
            ),
          ],
        );
        expect(span.plainText, equals('ABC'));
      });
    });

    group('visitChildren', () {
      test('does not call visitor for span without children', () {
        const span = TextSpan(text: 'Hello');
        int visitCount = 0;
        span.visitChildren((child) {
          visitCount++;
        });
        expect(visitCount, equals(0));
      });

      test('calls visitor for each child', () {
        const span = TextSpan(
          children: [
            TextSpan(text: 'A'),
            TextSpan(text: 'B'),
            TextSpan(text: 'C'),
          ],
        );
        final visited = <String>[];
        span.visitChildren((child) {
          if (child.text != null) {
            visited.add(child.text!);
          }
        });
        expect(visited, equals(['A', 'B', 'C']));
      });

      test('visits nested children recursively', () {
        const span = TextSpan(
          children: [
            TextSpan(
              text: 'A',
              children: [TextSpan(text: 'B')],
            ),
          ],
        );
        final visited = <String>[];
        span.visitChildren((child) {
          if (child.text != null) {
            visited.add(child.text!);
          }
        });
        expect(visited, equals(['A', 'B']));
      });
    });

    group('style inheritance', () {
      test('child inherits parent color', () {
        const span = TextSpan(
          style: TextStyle(color: Color.red),
          children: [TextSpan(text: 'Hello')],
        );
        final segments = <_StyledSegment>[];
        span._collectStyledSegments(segments, null);

        expect(segments.length, equals(1));
        expect(segments[0].text, equals('Hello'));
        expect(segments[0].style?.color, equals(Color.red));
      });

      test('child style overrides parent color', () {
        const span = TextSpan(
          style: TextStyle(color: Color.red),
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Color.blue),
            ),
          ],
        );
        final segments = <_StyledSegment>[];
        span._collectStyledSegments(segments, null);

        expect(segments[0].style?.color, equals(Color.blue));
      });

      test('child inherits bold from parent', () {
        const span = TextSpan(
          style: TextStyle(bold: true),
          children: [TextSpan(text: 'Hello')],
        );
        final segments = <_StyledSegment>[];
        span._collectStyledSegments(segments, null);

        expect(segments[0].style?.bold, isTrue);
      });

      test('child adds italic to parent bold', () {
        const span = TextSpan(
          style: TextStyle(bold: true),
          children: [TextSpan(text: 'Hello', style: TextStyle(italic: true))],
        );
        final segments = <_StyledSegment>[];
        span._collectStyledSegments(segments, null);

        expect(segments[0].style?.bold, isTrue);
        expect(segments[0].style?.italic, isTrue);
      });
    });
  });

  group('RichText widget', () {
    test('creates with required text span', () {
      const textSpan = TextSpan(text: 'Hello');
      const richText = RichText(text: textSpan);
      expect(richText.text, equals(textSpan));
    });

    test('creates with maxLines', () {
      const textSpan = TextSpan(text: 'Hello');
      const richText = RichText(text: textSpan, maxLines: 3);
      expect(richText.maxLines, equals(3));
    });

    test('creates with overflow', () {
      const textSpan = TextSpan(text: 'Hello');
      const richText = RichText(
        text: textSpan,
        overflow: TextOverflow.ellipsis,
      );
      expect(richText.overflow, equals(TextOverflow.ellipsis));
    });

    test('default overflow is clip', () {
      const textSpan = TextSpan(text: 'Hello');
      const richText = RichText(text: textSpan);
      expect(richText.overflow, equals(TextOverflow.clip));
    });
  });

  group('RenderRichText', () {
    test('layout simple text', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(text: 'Hello'),
      );
      renderRichText.layout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: Constraints.infinity,
          minHeight: 0,
          maxHeight: Constraints.infinity,
        ),
      );

      expect(renderRichText.size!.width, equals(5));
      expect(renderRichText.size!.height, equals(1));
    });

    test('layout multi-segment text', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(
          children: [
            TextSpan(text: 'Hello'),
            TextSpan(text: ' '),
            TextSpan(text: 'World'),
          ],
        ),
      );
      renderRichText.layout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: Constraints.infinity,
          minHeight: 0,
          maxHeight: Constraints.infinity,
        ),
      );

      expect(renderRichText.size!.width, equals(11));
      expect(renderRichText.size!.height, equals(1));
    });

    test('layout with line breaks', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(
          children: [
            TextSpan(text: 'Line1'),
            TextSpan(text: '\n'),
            TextSpan(text: 'Line2'),
          ],
        ),
      );
      renderRichText.layout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: Constraints.infinity,
          minHeight: 0,
          maxHeight: Constraints.infinity,
        ),
      );

      expect(renderRichText.size!.width, equals(5));
      expect(renderRichText.size!.height, equals(2));
    });

    test('layout with maxLines', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(text: 'Line1\nLine2\nLine3'),
        maxLines: 2,
      );
      renderRichText.layout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: Constraints.infinity,
          minHeight: 0,
          maxHeight: Constraints.infinity,
        ),
      );

      expect(renderRichText.size!.height, equals(2));
    });

    test('layout with text wrapping', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(text: 'Hello World'),
      );
      renderRichText.layout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 6,
          minHeight: 0,
          maxHeight: Constraints.infinity,
        ),
      );

      expect(renderRichText.size!.height, greaterThan(1));
    });

    test('properties can be updated', () {
      final renderRichText = RenderRichText(
        text: const TextSpan(text: 'Hello'),
      );
      expect(renderRichText.text.plainText, equals('Hello'));

      renderRichText.text = const TextSpan(text: 'World');
      expect(renderRichText.text.plainText, equals('World'));

      renderRichText.maxLines = 3;
      expect(renderRichText.maxLines, equals(3));

      renderRichText.overflow = TextOverflow.ellipsis;
      expect(renderRichText.overflow, equals(TextOverflow.ellipsis));
    });
  });
}

class _StyledSegment {
  _StyledSegment(this.text, this.style);
  final String text;
  final TextStyle? style;
}

extension on TextSpan {
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
