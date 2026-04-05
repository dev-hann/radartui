import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Container rendering', () {
    testWidgets('Container with fixed size', (tester) async {
      tester.pumpWidget(const Container(width: 5, height: 1, child: Text('X')));

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        'X',
      ]);
    });

    testWidgets('Container with child', (tester) async {
      tester.pumpWidget(const Container(child: Text('Inside')));

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        'Inside',
      ]);
    });

    testWidgets('Container with padding', (tester) async {
      tester.pumpWidget(
        const Container(padding: EdgeInsets.all(1), child: Text('P')),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        ' P',
      ]);
    });

    testWidgets('Container with margin', (tester) async {
      tester.pumpWidget(
        const Container(margin: EdgeInsets.all(1), child: Text('M')),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        ' M',
      ]);
    });
  });

  group('Container interaction', () {
    testWidgets('Container can be found by type', (tester) async {
      tester.pumpWidget(const Container());

      expect(find.byType<Container>().exists, isTrue);
    });
  });
}
