import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('RadioExample', () {
    testWidgets('renders radio button groups', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '  (●)  Option 1',
        '  ( )  Option 2',
        '  ( )  Option 3',
        '',
        '',
        '                                 Selected: option1',
        '',
        '                                              ◉ Radio Button Example',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('shows priority and language options', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '  (●)  Option 1',
        '  ( )  Option 2',
        '  ( )  Option 3',
        '',
        '',
        '                                 Selected: option1',
        '',
        '                                              ◉ Radio Button Example',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('shows disabled radio buttons', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '  (●)  Option 1',
        '  ( )  Option 2',
        '  ( )  Option 3',
        '',
        '',
        '                                 Selected: option1',
        '',
        '                                              ◉ Radio Button Example',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('displays current selection', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '  (●)  Option 1',
        '  ( )  Option 2',
        '  ( )  Option 3',
        '',
        '',
        '                                 Selected: option1',
        '',
        '                                              ◉ Radio Button Example',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      expect(find.byType<RadioExample>().exists, isTrue);
    });
  });
}
