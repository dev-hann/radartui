import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('TextFieldExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertContains('TextField Example');
      tester.assertContains('Basic TextField with controller');
      tester.assertContains('TextField with max length');
    });

    testWidgets('renders initial text', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertContains('Initial text');
    });

    testWidgets('renders controls help text', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertContains('Status:');
      tester.assertContains('Controller 1');
      tester.assertContains('Controller 2');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      expect(find.byType<TextFieldExample>().exists, isTrue);
    });
  });
}
