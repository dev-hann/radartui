import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultTextStyle', () {
    group('constructor', () {
      test('creates instance with required style', () {
        const style = TextStyle(color: Color.red, bold: true);
        const defaultTextStyle = DefaultTextStyle(
          style: style,
          child: Text('test'),
        );
        expect(defaultTextStyle.style, equals(style));
      });

      test('child is accessible', () {
        const defaultTextStyle = DefaultTextStyle(
          style: TextStyle(),
          child: Text('test'),
        );
        expect(defaultTextStyle.child, isA<Text>());
      });
    });

    group('updateShouldNotify', () {
      test('returns false when styles are equal', () {
        const style = TextStyle(color: Color.red);
        const widget1 = DefaultTextStyle(style: style, child: Text('test'));
        const widget2 = DefaultTextStyle(style: style, child: Text('test'));
        expect(widget1.updateShouldNotify(widget2), isFalse);
      });

      test('returns true when color differs', () {
        const widget1 = DefaultTextStyle(
          style: TextStyle(color: Color.red),
          child: Text('test'),
        );
        const widget2 = DefaultTextStyle(
          style: TextStyle(color: Color.blue),
          child: Text('test'),
        );
        expect(widget1.updateShouldNotify(widget2), isTrue);
      });

      test('returns true when bold differs', () {
        const widget1 = DefaultTextStyle(
          style: TextStyle(bold: false),
          child: Text('test'),
        );
        const widget2 = DefaultTextStyle(
          style: TextStyle(bold: true),
          child: Text('test'),
        );
        expect(widget1.updateShouldNotify(widget2), isTrue);
      });

      test('returns true when italic differs', () {
        const widget1 = DefaultTextStyle(
          style: TextStyle(italic: false),
          child: Text('test'),
        );
        const widget2 = DefaultTextStyle(
          style: TextStyle(italic: true),
          child: Text('test'),
        );
        expect(widget1.updateShouldNotify(widget2), isTrue);
      });

      test('returns true when underline differs', () {
        const widget1 = DefaultTextStyle(
          style: TextStyle(underline: false),
          child: Text('test'),
        );
        const widget2 = DefaultTextStyle(
          style: TextStyle(underline: true),
          child: Text('test'),
        );
        expect(widget1.updateShouldNotify(widget2), isTrue);
      });
    });
  });

  group('TextStyle.merge', () {
    test('returns original when other is null', () {
      const original = TextStyle(color: Color.red, bold: true);
      final merged = original.merge(null);
      expect(merged, equals(original));
    });

    test('other color overrides original', () {
      const original = TextStyle(color: Color.red);
      const other = TextStyle(color: Color.blue);
      final merged = original.merge(other);
      expect(merged.color, equals(Color.blue));
    });

    test('other null color keeps original color', () {
      const original = TextStyle(color: Color.red);
      const other = TextStyle();
      final merged = original.merge(other);
      expect(merged.color, equals(Color.red));
    });

    test('bold flags are ORed', () {
      const original = TextStyle(bold: true);
      const other = TextStyle(bold: false);
      final merged = original.merge(other);
      expect(merged.bold, isTrue);
    });

    test('italic flags are ORed', () {
      const original = TextStyle(italic: false);
      const other = TextStyle(italic: true);
      final merged = original.merge(other);
      expect(merged.italic, isTrue);
    });

    test('underline flags are ORed', () {
      const original = TextStyle(underline: true);
      const other = TextStyle(underline: true);
      final merged = original.merge(other);
      expect(merged.underline, isTrue);
    });

    test('backgroundColor merges correctly', () {
      const original = TextStyle(backgroundColor: Color.red);
      const other = TextStyle(backgroundColor: Color.blue);
      final merged = original.merge(other);
      expect(merged.backgroundColor, equals(Color.blue));
    });

    test('complete merge works', () {
      const original = TextStyle(
        color: Color.red,
        backgroundColor: Color.green,
        bold: false,
        italic: false,
        underline: false,
      );
      const other = TextStyle(
        color: Color.blue,
        bold: true,
        italic: true,
      );
      final merged = original.merge(other);
      expect(merged.color, equals(Color.blue));
      expect(merged.backgroundColor, equals(Color.green));
      expect(merged.bold, isTrue);
      expect(merged.italic, isTrue);
      expect(merged.underline, isFalse);
    });
  });
}
