import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Icon rendering', () {
    testWidgets('Icon renders unicode character', (tester) async {
      tester.pumpWidget(const Icon(icon: '✓'));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['✓']);
    });

    testWidgets('Icon renders with color', (tester) async {
      tester.pumpWidget(const Icon(icon: '✓', color: Color.red));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['✓']);
    });

    testWidgets('Icon uses Icons constant', (tester) async {
      tester.pumpWidget(const Icon(icon: Icons.check));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['✓']);
    });

    testWidgets('Icon in Row', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [
            Icon(icon: Icons.check),
            Text('Done'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['✓Done']);
    });

    testWidgets('Icon in Column', (tester) async {
      tester.pumpWidget(
        const Column(
          children: [
            Icon(icon: Icons.arrowUp),
            Icon(icon: Icons.arrowDown),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['↑', '↓']);
    });

    testWidgets('Multiple Icons in layout', (tester) async {
      tester.pumpWidget(
        const Row(
          children: [
            Icon(icon: Icons.folder, color: Color.yellow),
            Text('Documents'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['📁Documents']);
    });
  });

  group('Icon finder', () {
    testWidgets('Icon can be found by type', (tester) async {
      tester.pumpWidget(const Icon(icon: Icons.check));

      expect(find.byType<Icon>().exists, isTrue);
    });
  });
}
