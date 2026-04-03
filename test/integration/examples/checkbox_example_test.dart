import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('CheckboxExample', () {
    testWidgets('renders checkboxes and labels', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Checkbox Widget Example');
      tester.assertContains('Interactive Checkboxes');
      tester.assertContains('Enable notifications');
      tester.assertContains('Auto-save documents');
      tester.assertContains('Green themed checkbox');
      tester.assertContains('Custom colors checkbox');
    });

    testWidgets('shows disabled checkboxes', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Disabled Checkboxes');
      tester.assertContains('Disabled unchecked');
      tester.assertContains('Disabled checked');
    });

    testWidgets('displays current selection status', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      tester.assertContains('Current Selection Status');
      tester.assertContains('Notifications:');
      tester.assertContains('Auto-save:');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const CheckboxExample());
      await tester.pumpAndSettle();

      expect(find.byType<CheckboxExample>().exists, isTrue);
    });
  });
}
