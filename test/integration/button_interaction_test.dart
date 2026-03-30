import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Button interaction', () {
    testWidgets('Button renders text with border when focused', (tester) async {
      tester.pumpWidget(
        Button(
          text: 'Click',
          onPressed: () {},
        ),
      );

      // Focused button with border (height=1, so border drawn inline)
      // "Click" (5 chars) + padding (2+2) = 9 chars total
      // Border corners replace padding spaces
      tester.assertBufferLines([
        '└─Click─┘',
      ]);
    });

    testWidgets('Button renders short text with border', (tester) async {
      tester.pumpWidget(
        Button(
          text: 'OK',
          onPressed: () {},
        ),
      );

      // "OK" (2 chars) + padding (2+2) = 6 chars total
      tester.assertBufferLines([
        '└─OK─┘',
      ]);
    });

    testWidgets('Button onPressed is called on Enter key', (tester) async {
      var pressed = false;

      tester.pumpWidget(
        Button(
          text: 'Click',
          onPressed: () => pressed = true,
        ),
      );

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('Button onPressed is called on Space key', (tester) async {
      var pressed = false;

      tester.pumpWidget(
        Button(
          text: 'Click',
          onPressed: () => pressed = true,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('Disabled button does not respond to Enter', (tester) async {
      var pressed = false;

      tester.pumpWidget(
        Button(
          text: 'Click',
          enabled: false,
          onPressed: () => pressed = true,
        ),
      );

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
    });

    testWidgets('Button without onPressed does not crash on Enter',
        (tester) async {
      tester.pumpWidget(
        const Button(
          text: 'Click',
        ),
      );

      tester.sendEnter();
      await tester.pumpAndSettle();
    });

    testWidgets('Button can be found by type', (tester) async {
      tester.pumpWidget(
        Button(
          text: 'Click',
          onPressed: () {},
        ),
      );

      expect(find.byType<Button>().exists, isTrue);
    });

    testWidgets('tap() sends Enter key', (tester) async {
      var pressed = false;

      tester.pumpWidget(
        Button(
          text: 'Click',
          onPressed: () => pressed = true,
        ),
      );

      tester.tap(find.byType<Button>());
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });
  });
}
