import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Center rendering', () {
    testWidgets('Center centers child', (tester) async {
      tester.pumpWidget(
        const SizedBox(width: 10, height: 5, child: Center(child: Text('X'))),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                        X',
      ]);
    });

    testWidgets('Center empty', (tester) async {
      tester.pumpWidget(const Center());

      await tester.pumpAndSettle();

      expect(find.byType<Center>().exists, isTrue);
    });
  });

  group('Align rendering', () {
    testWidgets('Align with topLeft', (tester) async {
      tester.pumpWidget(
        const SizedBox(
          width: 10,
          height: 5,
          child: Align(alignment: Alignment.topLeft, child: Text('TL')),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['TL']);
    });

    testWidgets('Align with bottomRight', (tester) async {
      tester.pumpWidget(
        const SizedBox(
          width: 10,
          height: 5,
          child: Align(alignment: Alignment.bottomRight, child: Text('BR')),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['BR']);
    });

    testWidgets('Align with center', (tester) async {
      tester.pumpWidget(
        const SizedBox(
          width: 10,
          height: 5,
          child: Align(alignment: Alignment.center, child: Text('C')),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                        C',
      ]);
    });
  });

  group('SizedBox rendering', () {
    testWidgets('SizedBox with fixed size and child', (tester) async {
      tester.pumpWidget(const SizedBox(width: 5, height: 1, child: Text('Hi')));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['Hi']);
    });

    testWidgets('SizedBox empty shrinks to zero', (tester) async {
      tester.pumpWidget(
        const Column(children: [Text('Before'), SizedBox(), Text('After')]),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines(['Before', 'After']);
    });

    testWidgets('SizedBox with width constraint', (tester) async {
      tester.pumpWidget(const SizedBox(width: 10, child: Text('Wide')));

      await tester.pumpAndSettle();

      tester.assertBufferLines(['Wide']);
    });
  });

  group('Align interaction', () {
    testWidgets('Center can be found by type', (tester) async {
      tester.pumpWidget(const Center(child: Text('X')));

      expect(find.byType<Center>().exists, isTrue);
    });

    testWidgets('Align can be found by type', (tester) async {
      tester.pumpWidget(
        const Align(alignment: Alignment.center, child: Text('Y')),
      );

      expect(find.byType<Align>().exists, isTrue);
    });

    testWidgets('SizedBox can be found by type', (tester) async {
      tester.pumpWidget(const SizedBox());

      expect(find.byType<SizedBox>().exists, isTrue);
    });
  });
}
