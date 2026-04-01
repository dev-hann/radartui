import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('DialogExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Dialog Widget Examples');
      tester.assertContains('Show Simple Dialog');
      tester.assertContains('Show Colored Dialog');
      tester.assertContains('Show Constrained Dialog');
      tester.assertContains('Show Non-Dismissible Dialog');
    });

    testWidgets('renders initial status', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Press buttons to show dialogs!');
    });

    testWidgets('renders features list', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Title and actions support');
      tester.assertContains('Barrier color customization');
      tester.assertContains('Return values from dialogs');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      expect(find.byType<DialogExample>().exists, isTrue);
    });
  });
}
