import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('CheckboxExample', () {
    testWidgets('renders checkboxes and labels', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Checkbox Widget Example');
      tester.assertContains('Enable notifications');
      tester.assertContains('Auto-save documents');
      tester.assertContains('Dark mode');
    });

    testWidgets('shows checked state', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Auto-save: ON');
    });

    testWidgets('displays current selection status', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Notifications: OFF');
      tester.assertContains('Auto-save: ON');
      tester.assertContains('Dark mode: OFF');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      expect(find.byType<CheckboxExample>().exists, isTrue);
    });
  });
}
