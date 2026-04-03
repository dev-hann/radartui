import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultTextStyle Integration', () {
    test('DefaultTextStyle is an InheritedWidget', () {
      const defaultTextStyle = DefaultTextStyle(
        style: TextStyle(color: Color.cyan),
        child: Text('test'),
      );
      expect(defaultTextStyle, isA<InheritedWidget>());
    });

    test('child widget can be any widget type', () {
      const defaultTextStyle1 = DefaultTextStyle(
        style: TextStyle(),
        child: Text('text child'),
      );
      const defaultTextStyle2 = DefaultTextStyle(
        style: TextStyle(),
        child: Column(children: [Text('a'), Text('b')]),
      );
      expect(defaultTextStyle1.child, isA<Text>());
      expect(defaultTextStyle2.child, isA<Column>());
    });

    test('nested DefaultTextStyle widgets work correctly', () {
      const outer = DefaultTextStyle(
        style: TextStyle(color: Color.red),
        child: DefaultTextStyle(
          style: TextStyle(color: Color.blue),
          child: Text('nested'),
        ),
      );
      expect(outer.child, isA<DefaultTextStyle>());
      final inner = outer.child as DefaultTextStyle;
      expect(inner.style.color, equals(Color.blue));
    });

    test('explicit Text style is preserved', () {
      const text = Text(
        'styled',
        style: TextStyle(color: Color.green, bold: true),
      );
      const defaultTextStyle = DefaultTextStyle(
        style: TextStyle(color: Color.red),
        child: text,
      );
      final childText = defaultTextStyle.child as Text;
      expect(childText.style?.color, equals(Color.green));
      expect(childText.style?.bold, isTrue);
    });

    test('Text widget with explicit style merges correctly', () {
      const defaultStyle = TextStyle(
        color: Color.red,
        italic: true,
        underline: false,
      );
      const explicitStyle = TextStyle(color: Color.blue, bold: true);
      final merged = defaultStyle.merge(explicitStyle);
      expect(merged.color, equals(Color.blue));
      expect(merged.bold, isTrue);
      expect(merged.italic, isTrue);
      expect(merged.underline, isFalse);
    });

    test('style inheritance chain works', () {
      const style1 = TextStyle(color: Color.red, bold: true);
      const style2 = TextStyle(color: Color.blue, italic: true);
      const style3 = TextStyle(underline: true);

      final merged1 = style1.merge(style2);
      expect(merged1.color, equals(Color.blue));
      expect(merged1.bold, isTrue);
      expect(merged1.italic, isTrue);

      final merged2 = merged1.merge(style3);
      expect(merged2.color, equals(Color.blue));
      expect(merged2.bold, isTrue);
      expect(merged2.italic, isTrue);
      expect(merged2.underline, isTrue);
    });
  });
}
