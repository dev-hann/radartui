import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('FocusExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Use Tab to cycle focus');
      tester.assertContains('Button A');
      tester.assertContains('Button B');
      tester.assertContains('Button C');
    });

    testWidgets('renders list items', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Button A');
      tester.assertContains('Button B');
      tester.assertContains('Button C');
    });

    testWidgets('renders selection info', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Focused:');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      expect(find.byType<FocusExample>().exists, isTrue);
    });
  });
}
