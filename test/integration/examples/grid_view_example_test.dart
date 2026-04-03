import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('GridViewExample', () {
    testWidgets('renders grid with items', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      tester.assertContains('GridView Widget Example');
      tester.assertContains('Item 1');
      tester.assertContains('Item 2');
      tester.assertContains('Item 3');
    });

    testWidgets('shows navigation instructions', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      tester.assertContains('Arrow keys to navigate');
      tester.assertContains('Space/Enter to select');
    });

    testWidgets('displays selected item', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      tester.assertContains('Selected:');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      expect(find.byType<GridViewExample>().exists, isTrue);
    });
  });
}
