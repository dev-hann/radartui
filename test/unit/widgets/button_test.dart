import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Button', () {
    group('constructor', () {
      test('creates with required text', () {
        const button = Button(text: 'Click me');
        expect(button.text, equals('Click me'));
        expect(button.enabled, isTrue);
      });

      test('creates with enabled false', () {
        const button = Button(text: 'Click me', enabled: false);
        expect(button.enabled, isFalse);
      });

      test('creates with custom style', () {
        const style = ButtonStyle(
          foregroundColor: Color.red,
          backgroundColor: Color.blue,
        );
        const button = Button(text: 'Click me', style: style);
        expect(button.style, equals(style));
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final button = Button(text: 'Click me', focusNode: focusNode);
        expect(button.focusNode, equals(focusNode));
        focusNode.dispose();
      });
    });

    group('ButtonStyle', () {
      test('creates with default values', () {
        const style = ButtonStyle();
        expect(style.foregroundColor, equals(Color.white));
        expect(style.backgroundColor, equals(Color.blue));
        expect(style.focusColor, equals(Color.brightWhite));
        expect(style.focusBackgroundColor, equals(Color.brightBlue));
        expect(style.disabledColor, equals(Color.brightBlack));
        expect(style.disabledBackgroundColor, equals(Color.black));
        expect(style.bold, isFalse);
      });

      test('creates with custom values', () {
        const style = ButtonStyle(
          foregroundColor: Color.red,
          backgroundColor: Color.green,
          focusColor: Color.yellow,
          focusBackgroundColor: Color.cyan,
          disabledColor: Color.brightBlack,
          disabledBackgroundColor: Color.black,
          padding: EdgeInsets.all(1),
          bold: true,
        );
        expect(style.foregroundColor, equals(Color.red));
        expect(style.backgroundColor, equals(Color.green));
        expect(style.focusColor, equals(Color.yellow));
        expect(style.focusBackgroundColor, equals(Color.cyan));
        expect(style.bold, isTrue);
      });

      test('equality works correctly', () {
        const style1 = ButtonStyle(foregroundColor: Color.red);
        const style2 = ButtonStyle(foregroundColor: Color.red);
        const style3 = ButtonStyle(foregroundColor: Color.blue);
        expect(style1, equals(style2));
        expect(style1, isNot(equals(style3)));
      });
    });

    group('RenderButton', () {
      test('sizes based on text and padding', () {
        final renderButton = RenderButton(
          text: 'Hi',
          enabled: true,
          focused: false,
          style: const ButtonStyle(
            padding: EdgeInsets.symmetric(horizontal: 2),
          ),
          onTap: null,
        );
        renderButton.layout(const BoxConstraints());
        expect(renderButton.size!.width, equals(6));
        expect(renderButton.size!.height, equals(1));
      });

      test('sizes with larger padding', () {
        final renderButton = RenderButton(
          text: 'Hi',
          enabled: true,
          focused: false,
          style: const ButtonStyle(padding: EdgeInsets.all(1)),
          onTap: null,
        );
        renderButton.layout(const BoxConstraints());
        expect(renderButton.size!.width, equals(4));
        expect(renderButton.size!.height, equals(3));
      });
    });
  });
}
