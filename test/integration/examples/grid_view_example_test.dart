import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('GridViewExample', () {
    testWidgets('renders grid with items', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      tester.assertContains('Item 1');
      tester.assertContains('Item 6');
      tester.assertContains('Item 12');
    });

    testWidgets('shows navigation instructions', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      tester.assertContains('Use arrow keys');
      tester.assertContains('Item 1');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const GridViewExample());
      await tester.pumpAndSettle();

      expect(find.byType<GridViewExample>().exists, isTrue);
    });
  });
}
