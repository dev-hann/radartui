import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Divider rendering', () {
    testWidgets('Divider renders horizontal line', (tester) async {
      tester.pumpWidget(const Divider());

      await tester.pumpAndSettle();

      tester.assertContains('─');
    });

    testWidgets('Divider with custom character', (tester) async {
      tester.pumpWidget(const Divider(character: '='));

      await tester.pumpAndSettle();

      tester.assertContains('=');
    });

    testWidgets('Divider with thickness', (tester) async {
      tester.pumpWidget(const Divider(thickness: 2));

      await tester.pumpAndSettle();

      tester.assertContains('─');
    });
  });

  group('VerticalDivider rendering', () {
    testWidgets('VerticalDivider renders vertical line', (tester) async {
      tester.pumpWidget(
        const SizedBox(width: 10, height: 5, child: VerticalDivider()),
      );

      await tester.pumpAndSettle();

      tester.assertContains('│');
    });

    testWidgets('VerticalDivider with custom character', (tester) async {
      tester.pumpWidget(
        const SizedBox(
          width: 10,
          height: 3,
          child: VerticalDivider(character: '|'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('|');
    });
  });

  group('Divider interaction', () {
    testWidgets('Divider can be found by type', (tester) async {
      tester.pumpWidget(const Divider());

      expect(find.byType<Divider>().exists, isTrue);
    });

    testWidgets('VerticalDivider can be found by type', (tester) async {
      tester.pumpWidget(const SizedBox(height: 5, child: VerticalDivider()));

      expect(find.byType<VerticalDivider>().exists, isTrue);
    });
  });
}
