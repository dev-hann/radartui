import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('DialogExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Show Confirm Dialog');
      tester.assertContains('Show Info Dialog');
      tester.assertContains('Result: No dialog shown');
    });

    testWidgets('renders initial status', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Result: No dialog shown');
    });

    testWidgets('renders features list', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      tester.assertContains('Show Confirm Dialog');
      tester.assertContains('Show Info Dialog');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const DialogExample());
      await tester.pumpAndSettle();

      expect(find.byType<DialogExample>().exists, isTrue);
    });
  });
}
