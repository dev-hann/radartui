import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Text rendering', () {
    testWidgets('Text renders single line', (tester) async {
      tester.pumpWidget(const Text('Hello'));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['Hello']);
    });

    testWidgets('Text renders empty string', (tester) async {
      tester.pumpWidget(const Text(''));

      await tester.pumpAndSettle();

      expect(find.byType<Text>().exists, isTrue);
    });

    testWidgets('Text with newline splits into lines', (tester) async {
      tester.pumpWidget(const Text('Line1\nLine2'));

      await tester.pumpAndSettle();

      tester.assertContains('Line1');
      tester.assertContains('Line2');
    });

    testWidgets('Text with softWrap wraps long text', (tester) async {
      tester.pumpWidget(const Text('Hello World'));

      await tester.pumpAndSettle();

      tester.assertContains('Hello');
    });
  });

  group('Text interaction', () {
    testWidgets('Text can be found by type', (tester) async {
      tester.pumpWidget(const Text('Test'));

      expect(find.byType<Text>().exists, isTrue);
    });

    testWidgets('Text can be found by content', (tester) async {
      tester.pumpWidget(const Text('UniqueText'));

      await tester.pumpAndSettle();

      expect(find.text('UniqueText').exists, isTrue);
    });
  });
}
