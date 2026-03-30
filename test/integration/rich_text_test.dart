import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('RichText integration', () {
    group('rendering multiple colors', () {
      test('segments have different colors', () {
        final renderRichText = RenderRichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Red',
                style: TextStyle(color: Color.red),
              ),
              TextSpan(text: ' '),
              TextSpan(
                text: 'Blue',
                style: TextStyle(color: Color.blue),
              ),
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

        expect(renderRichText.size!.width, equals(8));
        expect(renderRichText.size!.height, equals(1));
      });

      test('style segments are preserved', () {
        final segments = <_TestSegment>[];
        final textSpan = const TextSpan(
          children: [
            TextSpan(
              text: 'Red',
              style: TextStyle(color: Color.red),
            ),
            TextSpan(text: ' '),
            TextSpan(
              text: 'Blue',
              style: TextStyle(color: Color.blue),
            ),
          ],
        );

        _collectSegments(textSpan, segments, null);

        expect(segments.length, equals(3));
        expect(segments[0].text, equals('Red'));
        expect(segments[0].style?.color, equals(Color.red));
        expect(segments[1].text, equals(' '));
        expect(segments[2].text, equals('Blue'));
        expect(segments[2].style?.color, equals(Color.blue));
      });
    });

    group('bold/italic mixing', () {
      test('bold and italic segments', () {
        final segments = <_TestSegment>[];
        final textSpan = const TextSpan(
          children: [
            TextSpan(text: 'Bold', style: TextStyle(bold: true)),
            TextSpan(text: ' '),
            TextSpan(text: 'Italic', style: TextStyle(italic: true)),
            TextSpan(text: ' '),
            TextSpan(text: 'Both', style: TextStyle(bold: true, italic: true)),
          ],
        );

        _collectSegments(textSpan, segments, null);

        expect(segments[0].style?.bold, isTrue);
        expect(segments[0].style?.italic, isFalse);
        expect(segments[2].style?.bold, isFalse);
        expect(segments[2].style?.italic, isTrue);
        expect(segments[4].style?.bold, isTrue);
        expect(segments[4].style?.italic, isTrue);
      });

      test('inherited bold with child italic', () {
        final segments = <_TestSegment>[];
        final textSpan = const TextSpan(
          style: TextStyle(bold: true),
          children: [
            TextSpan(text: 'Inherited'),
            TextSpan(text: ' ', style: TextStyle(italic: true)),
          ],
        );

        _collectSegments(textSpan, segments, null);

        expect(segments[0].style?.bold, isTrue);
        expect(segments[0].style?.italic, isFalse);
        expect(segments[1].style?.bold, isTrue);
        expect(segments[1].style?.italic, isTrue);
      });
    });

    group('maxLines truncation', () {
      test('truncates to maxLines with ellipsis', () {
        final renderRichText = RenderRichText(
          text: const TextSpan(text: 'Line1\nLine2\nLine3\nLine4'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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

      test('wraps and truncates long text', () {
        final renderRichText = RenderRichText(
          text: const TextSpan(
            text: 'This is a very long line that needs wrapping',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
        renderRichText.layout(
          const BoxConstraints(
            minWidth: 0,
            maxWidth: 20,
            minHeight: 0,
            maxHeight: Constraints.infinity,
          ),
        );

        expect(renderRichText.size!.height, equals(2));
      });
    });

    group('multiline with styles', () {
      test('styles across line breaks', () {
        final renderRichText = RenderRichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'First line\n',
                style: TextStyle(color: Color.red),
              ),
              TextSpan(
                text: 'Second line',
                style: TextStyle(color: Color.blue),
              ),
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

        expect(renderRichText.size!.height, equals(2));
      });

      test('multiline plainText preserves line breaks', () {
        const textSpan = TextSpan(
          children: [
            TextSpan(text: 'Line1\n'),
            TextSpan(text: 'Line2'),
          ],
        );
        expect(textSpan.plainText, equals('Line1\nLine2'));
      });
    });

    group('complex nesting', () {
      test('deeply nested styles merge correctly', () {
        final segments = <_TestSegment>[];
        final textSpan = const TextSpan(
          style: TextStyle(color: Color.red, bold: true),
          children: [
            TextSpan(
              text: 'Middle',
              style: TextStyle(italic: true),
              children: [
                TextSpan(
                  text: 'Deep',
                  style: TextStyle(color: Color.blue),
                ),
              ],
            ),
          ],
        );

        _collectSegments(textSpan, segments, null);

        expect(segments[0].text, equals('Middle'));
        expect(segments[0].style?.color, equals(Color.red));
        expect(segments[0].style?.bold, isTrue);
        expect(segments[0].style?.italic, isTrue);

        expect(segments[1].text, equals('Deep'));
        expect(segments[1].style?.color, equals(Color.blue));
        expect(segments[1].style?.bold, isTrue);
        expect(segments[1].style?.italic, isTrue);
      });
    });
  });
}

class _TestSegment {
  _TestSegment(this.text, this.style);
  final String text;
  final TextStyle? style;
}

void _collectSegments(
  TextSpan span,
  List<_TestSegment> segments,
  TextStyle? parentStyle,
) {
  final effectiveStyle = _mergeStyles(parentStyle, span.style);

  if (span.text != null && span.text!.isNotEmpty) {
    segments.add(_TestSegment(span.text!, effectiveStyle));
  }

  if (span.children != null) {
    for (final child in span.children!) {
      _collectSegments(child, segments, effectiveStyle);
    }
  }
}

TextStyle? _mergeStyles(TextStyle? base, TextStyle? overlay) {
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
