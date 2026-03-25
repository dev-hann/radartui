import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Text widget', () {
    test('Text creates with string', () {
      const text = Text('Hello');
      expect(text.data, equals('Hello'));
    });

    test('Text creates with empty string', () {
      const text = Text('');
      expect(text.data, equals(''));
    });

    test('Text creates with style', () {
      const style = TextStyle(color: Color.red);
      const text = Text('Hello', style: style);
      expect(text.style, equals(style));
    });

    test('Text creates without style', () {
      const text = Text('Hello');
      expect(text.style, isNull);
    });

    test('Text can have key', () {
      const key = ValueKey<String>('text_key');
      const text = Text('Hello', key: key);
      expect(text.key, equals(key));
    });
    
    test('Text creates with softWrap', () {
      const text = Text('Hello', softWrap: false);
      expect(text.softWrap, isFalse);
    });
    
    test('Text creates with maxLines', () {
      const text = Text('Hello', maxLines: 3);
      expect(text.maxLines, equals(3));
    });
    
    test('Text creates with overflow', () {
      const text = Text('Hello', overflow: TextOverflow.ellipsis);
      expect(text.overflow, equals(TextOverflow.ellipsis));
    });
  });

  group('RenderText', () {
    test('RenderText has text', () {
      final renderText = RenderText(text: 'Hello');
      expect(renderText.text, equals('Hello'));
    });

    test('RenderText can have style', () {
      const style = TextStyle(color: Color.red);
      final renderText = RenderText(text: 'Hello', style: style);
      expect(renderText.style, equals(style));
    });

    test('RenderText style can be null', () {
      final renderText = RenderText(text: 'Hello');
      expect(renderText.style, isNull);
    });

    test('RenderText layout size based on text length', () {
      final renderText = RenderText(text: 'Hello');
      renderText.layout(const BoxConstraints(
        minWidth: 0,
        maxWidth: Constraints.infinity,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      ));
      
      expect(renderText.size, isNotNull);
      expect(renderText.size!.width, equals(5));
      expect(renderText.size!.height, equals(1));
    });

    test('RenderText layout with empty string', () {
      final renderText = RenderText(text: '');
      renderText.layout(const BoxConstraints(
        minWidth: 0,
        maxWidth: Constraints.infinity,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      ));
      
      expect(renderText.size!.width, equals(0));
      expect(renderText.size!.height, equals(1));
    });

    test('RenderText text can be updated', () {
      final renderText = RenderText(text: 'Hello');
      expect(renderText.text, equals('Hello'));
      
      renderText.text = 'World';
      expect(renderText.text, equals('World'));
    });

    test('RenderText style can be updated', () {
      final renderText = RenderText(text: 'Hello');
      expect(renderText.style, isNull);
      
      const newStyle = TextStyle(color: Color.blue);
      renderText.style = newStyle;
      expect(renderText.style, equals(newStyle));
    });
    
    test('RenderText supports multiline', () {
      final renderText = RenderText(text: 'Hello\nWorld');
      renderText.layout(const BoxConstraints(
        minWidth: 0,
        maxWidth: Constraints.infinity,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      ));
      
      expect(renderText.size!.width, equals(5));
      expect(renderText.size!.height, equals(2));
    });
    
    test('RenderText softWrap breaks long text', () {
      final renderText = RenderText(text: 'Hello World', softWrap: true);
      renderText.layout(const BoxConstraints(
        minWidth: 0,
        maxWidth: 6,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      ));
      
      expect(renderText.size!.height, greaterThan(1));
    });
    
    test('RenderText maxLines limits lines', () {
      final renderText = RenderText(text: 'Hello\nWorld\nTest', maxLines: 2);
      renderText.layout(const BoxConstraints(
        minWidth: 0,
        maxWidth: Constraints.infinity,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      ));
      
      expect(renderText.size!.height, equals(2));
    });
  });

  group('TextStyle', () {
    test('TextStyle creates with color', () {
      const style = TextStyle(color: Color.red);
      expect(style.color, equals(Color.red));
    });

    test('TextStyle creates with backgroundColor', () {
      const style = TextStyle(backgroundColor: Color.blue);
      expect(style.backgroundColor, equals(Color.blue));
    });

    test('TextStyle creates with bold', () {
      const style = TextStyle(bold: true);
      expect(style.bold, isTrue);
    });

    test('TextStyle creates with italic', () {
      const style = TextStyle(italic: true);
      expect(style.italic, isTrue);
    });

    test('TextStyle creates with underline', () {
      const style = TextStyle(underline: true);
      expect(style.underline, isTrue);
    });

    test('TextStyle creates with fontFamily', () {
      const style = TextStyle(fontFamily: FontFamily.monospace);
      expect(style.fontFamily, equals(FontFamily.monospace));
    });

    test('TextStyle default values', () {
      const style = TextStyle();
      expect(style.color, isNull);
      expect(style.backgroundColor, isNull);
      expect(style.bold, isFalse);
      expect(style.italic, isFalse);
      expect(style.underline, isFalse);
      expect(style.fontFamily, equals(FontFamily.monospace));
    });

    test('TextStyle equality', () {
      const style1 = TextStyle(color: Color.red, bold: true);
      const style2 = TextStyle(color: Color.red, bold: true);
      expect(style1, equals(style2));
      expect(style1.hashCode, equals(style2.hashCode));
    });

    test('TextStyle inequality', () {
      const style1 = TextStyle(color: Color.red);
      const style2 = TextStyle(color: Color.blue);
      expect(style1, isNot(equals(style2)));
    });
  });

  group('Color', () {
    test('Color creates with value', () {
      const color = Color(5);
      expect(color.value, equals(5));
    });

    test('Color named constants', () {
      expect(Color.black.value, equals(0));
      expect(Color.white.value, equals(7));
      expect(Color.red.value, equals(1));
      expect(Color.green.value, equals(2));
      expect(Color.blue.value, equals(4));
      expect(Color.yellow.value, equals(3));
      expect(Color.cyan.value, equals(6));
      expect(Color.magenta.value, equals(5));
    });

    test('Color equality', () {
      const color1 = Color(5);
      const color2 = Color(5);
      expect(color1, equals(color2));
      expect(color1.hashCode, equals(color2.hashCode));
    });

    test('Color inequality', () {
      const color1 = Color(5);
      const color2 = Color(6);
      expect(color1, isNot(equals(color2)));
    });
  });

  group('Colors', () {
    test('Colors has all basic colors', () {
      expect(Colors.black, equals(Color.black));
      expect(Colors.white, equals(Color.white));
      expect(Colors.red, equals(Color.red));
      expect(Colors.green, equals(Color.green));
      expect(Colors.blue, equals(Color.blue));
      expect(Colors.yellow, equals(Color.yellow));
      expect(Colors.cyan, equals(Color.cyan));
      expect(Colors.magenta, equals(Color.magenta));
    });

    test('Colors has bright variants', () {
      expect(Colors.brightBlack.value, equals(8));
      expect(Colors.brightRed.value, equals(9));
      expect(Colors.brightGreen.value, equals(10));
      expect(Colors.brightYellow.value, equals(11));
      expect(Colors.brightBlue.value, equals(12));
      expect(Colors.brightMagenta.value, equals(13));
      expect(Colors.brightCyan.value, equals(14));
      expect(Colors.brightWhite.value, equals(15));
    });
  });

  group('FontFamily', () {
    test('FontFamily has system value', () {
      expect(FontFamily.system, equals(FontFamily.system));
    });

    test('FontFamily has monospace value', () {
      expect(FontFamily.monospace, equals(FontFamily.monospace));
    });

    test('FontFamily values contains all options', () {
      expect(FontFamily.values.length, equals(2));
      expect(FontFamily.values, contains(FontFamily.system));
      expect(FontFamily.values, contains(FontFamily.monospace));
    });
  });
  
  group('TextOverflow', () {
    test('TextOverflow has all values', () {
      expect(TextOverflow.values.length, equals(3));
      expect(TextOverflow.values, contains(TextOverflow.clip));
      expect(TextOverflow.values, contains(TextOverflow.ellipsis));
      expect(TextOverflow.values, contains(TextOverflow.fade));
    });
  });
}
