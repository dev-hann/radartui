import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Spacer rendering', () {
    testWidgets('Spacer takes remaining space in Row', (tester) async {
      tester.pumpWidget(const Row(children: [Text('A'), Spacer(), Text('B')]));

      await tester.pumpAndSettle();

      tester.assertContains('A');
      tester.assertContains('B');
    });

    testWidgets('Spacer with custom flex', (tester) async {
      tester.pumpWidget(
        const Row(children: [Text('X'), Spacer(flex: 2), Text('Y')]),
      );

      await tester.pumpAndSettle();

      tester.assertContains('X');
      tester.assertContains('Y');
    });

    testWidgets('Multiple Spacers', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [Text('1'), Spacer(), Text('2'), Spacer(), Text('3')],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('1');
      tester.assertContains('2');
      tester.assertContains('3');
    });
  });

  group('Expanded rendering', () {
    testWidgets('Expanded fills space in Row', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [
            Text('L'),
            Expanded(child: Text('Middle')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('L');
      tester.assertContains('Middle');
    });

    testWidgets('Expanded with custom flex', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [
            Expanded(flex: 1, child: Text('1')),
            Expanded(flex: 2, child: Text('2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('1');
      tester.assertContains('2');
    });

    testWidgets('Expanded in Column', (tester) async {
      tester.pumpWidget(
        const Column(
          children: [
            Text('Top'),
            Expanded(child: Text('Bottom')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Top');
      tester.assertContains('Bottom');
    });
  });

  group('Spacer interaction', () {
    testWidgets('Spacer can be found by type', (tester) async {
      tester.pumpWidget(const Row(children: [Spacer()]));

      expect(find.byType<Spacer>().exists, isTrue);
    });

    testWidgets('Expanded can be found by type', (tester) async {
      tester.pumpWidget(const Row(children: [Expanded(child: Text('X'))]));

      expect(find.byType<Expanded>().exists, isTrue);
    });
  });
}
