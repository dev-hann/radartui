import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('RadioExample', () {
    testWidgets('renders radio button groups', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertContains('Radio Button Example');
      tester.assertContains('Theme Selection');
      tester.assertContains('Dark Theme');
      tester.assertContains('Light Theme');
      tester.assertContains('Auto Theme');
    });

    testWidgets('shows priority and language options', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertContains('Priority Level');
      tester.assertContains('High Priority');
      tester.assertContains('Medium Priority');
      tester.assertContains('Low Priority');
      tester.assertContains('Programming Language');
    });

    testWidgets('shows disabled radio buttons', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertContains('Disabled Radio Buttons');
      tester.assertContains('Disabled Unselected');
      tester.assertContains('Disabled Selected');
    });

    testWidgets('displays current selection', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      tester.assertContains('Current Selection');
      tester.assertContains('Theme:');
      tester.assertContains('Priority:');
      tester.assertContains('Language:');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const RadioExample());
      await tester.pumpAndSettle();

      expect(find.byType<RadioExample>().exists, isTrue);
    });
  });
}
