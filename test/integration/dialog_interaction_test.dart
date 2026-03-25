import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Dialog rendering', () {
    testWidgets('Dialog renders title and content', (tester) async {
      tester.pumpWidget(
        const Dialog(
          title: 'Title',
          child: Text('Content'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Title');
      tester.assertContains('Content');
    });

    testWidgets('Dialog renders with actions', (tester) async {
      tester.pumpWidget(
        const Dialog(
          child: Text('Body'),
          actions: [
            Button(text: 'OK'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Body');
      tester.assertContains('OK');
    });
  });

  group('Dialog interaction', () {
    testWidgets('Dialog shows title', (tester) async {
      tester.pumpWidget(
        const Dialog(
          title: 'Dialog Title',
          child: Text('Content'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Dialog Title').exists, isTrue);
    });

    testWidgets('Dialog shows child content', (tester) async {
      tester.pumpWidget(
        const Dialog(
          child: Text('Dialog Content'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Dialog Content').exists, isTrue);
    });

    testWidgets('Dialog shows actions', (tester) async {
      tester.pumpWidget(
        const Dialog(
          child: Text('Content'),
          actions: [
            Button(text: 'OK'),
            Button(text: 'Cancel'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType<Button>().exists, isTrue);
    });

    testWidgets('Dialog can be found by type', (tester) async {
      tester.pumpWidget(
        const Dialog(child: Text('Content')),
      );

      expect(find.byType<Dialog>().exists, isTrue);
    });

    testWidgets('Dialog with custom padding', (tester) async {
      tester.pumpWidget(
        const Dialog(
          padding: EdgeInsets.all(4),
          child: Text('Content'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType<Dialog>().exists, isTrue);
    });

    testWidgets('Dialog with custom background color', (tester) async {
      tester.pumpWidget(
        const Dialog(
          backgroundColor: Color.blue,
          child: Text('Content'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType<Dialog>().exists, isTrue);
    });
  });
}
