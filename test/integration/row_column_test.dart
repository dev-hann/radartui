import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Row rendering', () {
    testWidgets('Row lays out children horizontally', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [
            Text('A'),
            Text('B'),
            Text('C'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('A');
      tester.assertContains('B');
      tester.assertContains('C');
    });

    testWidgets('Row single child', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [Text('Only')],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Only');
    });

    testWidgets('Row empty', (tester) async {
      tester.pumpWidget(
        const Row(children: []),
      );

      await tester.pumpAndSettle();

      expect(find.byType<Row>().exists, isTrue);
    });
  });

  group('Column rendering', () {
    testWidgets('Column lays out children vertically', (tester) async {
      tester.pumpWidget(
        const Column(
          children: [
            Text('1'),
            Text('2'),
            Text('3'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('1');
      tester.assertContains('2');
      tester.assertContains('3');
    });

    testWidgets('Column single child', (tester) async {
      tester.pumpWidget(
        const Column(
          children: [Text('Solo')],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Solo');
    });

    testWidgets('Column empty', (tester) async {
      tester.pumpWidget(
        const Column(children: []),
      );

      await tester.pumpAndSettle();

      expect(find.byType<Column>().exists, isTrue);
    });
  });

  group('Flex interaction', () {
    testWidgets('Row can be found by type', (tester) async {
      tester.pumpWidget(
        const Row(children: [Text('X')]),
      );

      expect(find.byType<Row>().exists, isTrue);
    });

    testWidgets('Column can be found by type', (tester) async {
      tester.pumpWidget(
        const Column(children: [Text('Y')]),
      );

      expect(find.byType<Column>().exists, isTrue);
    });
  });
}
