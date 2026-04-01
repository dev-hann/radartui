import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('ButtonExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      tester.assertContains('Button Widget Example');
      tester.assertContains('Click Me!');
      tester.assertContains('Reset');
      tester.assertContains('Disabled Button');
      tester.assertContains('Custom Style');
    });

    testWidgets('renders initial message and counter', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      tester.assertContains('Press a button!');
      tester.assertContains('Counter: 0');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      expect(find.byType<ButtonExample>().exists, isTrue);
    });
  });
}
