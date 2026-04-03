import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Container border rendering', () {
    testWidgets('Container with Border.all renders box border', (tester) async {
      tester.pumpWidget(
        const Container(
          width: 5,
          height: 3,
          border: Border.all,
          child: Text('A'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('┌');
      tester.assertContains('┐');
      tester.assertContains('└');
      tester.assertContains('┘');
      tester.assertContains('A');
    });

    testWidgets('Container without border works as before', (tester) async {
      tester.pumpWidget(const Container(width: 5, height: 1, child: Text('X')));

      await tester.pumpAndSettle();

      tester.assertContains('X');
    });

    testWidgets('Container with border and padding', (tester) async {
      tester.pumpWidget(
        const Container(
          width: 9,
          height: 5,
          border: Border.all,
          padding: EdgeInsets.all(1),
          child: Text('P'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('P');
      tester.assertContains('┌');
      tester.assertContains('┘');
    });

    testWidgets('Container with border and margin', (tester) async {
      tester.pumpWidget(
        const Container(
          width: 5,
          height: 3,
          border: Border.all,
          margin: EdgeInsets.all(1),
          child: Text('M'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('M');
      tester.assertContains('┌');
    });

    testWidgets('Container with border and color', (tester) async {
      tester.pumpWidget(
        const Container(
          width: 5,
          height: 3,
          border: Border.all,
          color: Color(0),
          child: Text('C'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('C');
      tester.assertContains('┌');
    });

    testWidgets('Container with Border.only renders partial border', (
      tester,
    ) async {
      tester.pumpWidget(
        Container(
          width: 5,
          height: 3,
          border: Border.only(top: '─'),
          child: const Text('T'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('T');
      tester.assertContains('─');
    });

    testWidgets('Container with border auto-sizes to child', (tester) async {
      tester.pumpWidget(const Container(border: Border.all, child: Text('Hi')));

      await tester.pumpAndSettle();

      tester.assertContains('Hi');
      tester.assertContains('┌');
      tester.assertContains('┘');
    });
  });
}
