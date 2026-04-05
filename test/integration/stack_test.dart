import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Stack rendering', () {
    testWidgets('Stack renders children', (tester) async {
      tester.pumpWidget(const Stack(children: [Text('A'), Text('B')]));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['B']);
    });

    testWidgets('Stack with Positioned left', (tester) async {
      tester.pumpWidget(
        const Stack(children: [Positioned(left: 5, child: Text('X'))]),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['X']);
    });

    testWidgets('Stack with Positioned top', (tester) async {
      tester.pumpWidget(
        const Stack(children: [Positioned(top: 2, child: Text('Y'))]),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['Y']);
    });

    testWidgets('Stack empty', (tester) async {
      tester.pumpWidget(const Stack(children: []));

      await tester.pumpAndSettle();

      expect(find.byType<Stack>().exists, isTrue);
    });
  });

  group('Stack interaction', () {
    testWidgets('Stack can be found by type', (tester) async {
      tester.pumpWidget(const Stack(children: [Text('Test')]));

      expect(find.byType<Stack>().exists, isTrue);
    });

    testWidgets('Positioned can be found by type', (tester) async {
      tester.pumpWidget(const Positioned(child: Text('Test')));

      expect(find.byType<Positioned>().exists, isTrue);
    });
  });
}
