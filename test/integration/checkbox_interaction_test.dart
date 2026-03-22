import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Checkbox rendering', () {
    testWidgets('Checkbox renders unchecked state', (tester) async {
      tester.pumpWidget(
        const Checkbox(value: false),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '[ ]',
      ]);
    });

    testWidgets('Checkbox renders checked state', (tester) async {
      tester.pumpWidget(
        Checkbox(value: true, onChanged: (_) {}),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '[✓]',
      ]);
    });
  });

  group('Checkbox interaction', () {
    testWidgets('Checkbox toggles from false to true on Space', (tester) async {
      var value = false;

      tester.pumpWidget(
        Checkbox(
          value: value,
          onChanged: (newValue) => value = newValue!,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('Checkbox toggles from true to false on Space', (tester) async {
      var value = true;

      tester.pumpWidget(
        Checkbox(
          value: value,
          onChanged: (newValue) => value = newValue!,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(value, isFalse);
    });

    testWidgets('Checkbox toggles on Enter key', (tester) async {
      var value = false;

      tester.pumpWidget(
        Checkbox(
          value: value,
          onChanged: (newValue) => value = newValue!,
        ),
      );

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('Disabled checkbox does not respond to input', (tester) async {
      var value = false;

      tester.pumpWidget(
        Checkbox(
          value: value,
          onChanged: null,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(value, isFalse);
    });

    testWidgets('Checkbox can be found by type', (tester) async {
      tester.pumpWidget(
        const Checkbox(value: false),
      );

      expect(find.byType<Checkbox>().exists, isTrue);
    });

    testWidgets('Multiple checkbox interactions', (tester) async {
      var value1 = false;
      var value2 = true;

      tester.pumpWidget(
        Row(
          children: [
            Checkbox(
              value: value1,
              onChanged: (v) => value1 = v!,
            ),
            Checkbox(
              value: value2,
              onChanged: (v) => value2 = v!,
            ),
          ],
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(value1, isTrue);
    });
  });
}
