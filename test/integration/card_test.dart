import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Card rendering', () {
    testWidgets('Card renders with border', (tester) async {
      tester.pumpWidget(const Card(child: Text('Hi')));

      await tester.pumpAndSettle();

      tester.assertContains('┌');
      tester.assertContains('┐');
      tester.assertContains('└');
      tester.assertContains('┘');
      tester.assertContains('Hi');
    });

    testWidgets('Card renders empty', (tester) async {
      tester.pumpWidget(const Card());

      await tester.pumpAndSettle();

      tester.assertContains('┌');
      tester.assertContains('┘');
    });

    testWidgets('Card with padding', (tester) async {
      tester.pumpWidget(
        const Card(padding: EdgeInsets.all(2), child: Text('X')),
      );

      await tester.pumpAndSettle();

      tester.assertContains('X');
    });
  });

  group('Card interaction', () {
    testWidgets('Card can be found by type', (tester) async {
      tester.pumpWidget(const Card(child: Text('Content')));

      expect(find.byType<Card>().exists, isTrue);
    });
  });
}
