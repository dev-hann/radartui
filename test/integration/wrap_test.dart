import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Wrap rendering', () {
    testWidgets('Wrap lays out children horizontally', (tester) async {
      tester.pumpWidget(
        const Wrap(children: [Text('A'), Text('B'), Text('C')]),
      );

      await tester.pumpAndSettle();

      tester.assertContains('A');
      tester.assertContains('B');
      tester.assertContains('C');
    });

    testWidgets('Wrap with spacing', (tester) async {
      tester.pumpWidget(
        const Wrap(spacing: 2, children: [Text('X'), Text('Y')]),
      );

      await tester.pumpAndSettle();

      tester.assertContains('X');
      tester.assertContains('Y');
    });

    testWidgets('Wrap with runSpacing', (tester) async {
      tester.pumpWidget(
        const Wrap(runSpacing: 1, children: [Text('1'), Text('2')]),
      );

      await tester.pumpAndSettle();

      tester.assertContains('1');
      tester.assertContains('2');
    });

    testWidgets('Wrap empty', (tester) async {
      tester.pumpWidget(const Wrap(children: []));

      await tester.pumpAndSettle();

      expect(find.byType<Wrap>().exists, isTrue);
    });
  });

  group('Wrap interaction', () {
    testWidgets('Wrap can be found by type', (tester) async {
      tester.pumpWidget(const Wrap(children: [Text('Test')]));

      expect(find.byType<Wrap>().exists, isTrue);
    });
  });
}
