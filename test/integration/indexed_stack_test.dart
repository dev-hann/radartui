import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('IndexedStack rendering', () {
    testWidgets('renders only indexed child', (tester) async {
      tester.pumpWidget(
        const IndexedStack(
          index: 1,
          children: [
            Text('First'),
            Text('Second'),
            Text('Third'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Second');
      expect(tester.contains('First'), isFalse);
      expect(tester.contains('Third'), isFalse);
    });

    testWidgets('renders first child with default index 0', (tester) async {
      tester.pumpWidget(
        const IndexedStack(
          children: [
            Text('Alpha'),
            Text('Beta'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Alpha');
      expect(tester.contains('Beta'), isFalse);
    });

    testWidgets('handles out of bounds index - negative', (tester) async {
      tester.pumpWidget(
        const IndexedStack(
          index: -1,
          children: [
            Text('A'),
            Text('B'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('A');
    });

    testWidgets('handles out of bounds index - too high', (tester) async {
      tester.pumpWidget(
        const IndexedStack(
          index: 100,
          children: [
            Text('X'),
            Text('Y'),
          ],
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Y');
    });

    testWidgets('renders nothing with empty children', (tester) async {
      tester.pumpWidget(
        const IndexedStack(children: []),
      );

      await tester.pumpAndSettle();

      expect(find.byType<IndexedStack>().exists, isTrue);
    });
  });

  group('IndexedStack interaction', () {
    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(
        const IndexedStack(children: [Text('Test')]),
      );

      expect(find.byType<IndexedStack>().exists, isTrue);
    });

    testWidgets('index change updates displayed child', (tester) async {
      tester.pumpWidget(const _SwitchableIndexedStack());

      await tester.pumpAndSettle();
      tester.assertContains('Page 0');
      expect(tester.contains('Page 1'), isFalse);

      final state = tester.state<_SwitchableIndexedStackState>()!;
      state.setIndex(1);
      await tester.pumpAndSettle();

      tester.assertContains('Page 1');
      expect(tester.contains('Page 0'), isFalse);
    });
  });
}

class _SwitchableIndexedStack extends StatefulWidget {
  const _SwitchableIndexedStack();

  @override
  State<_SwitchableIndexedStack> createState() =>
      _SwitchableIndexedStackState();
}

class _SwitchableIndexedStackState extends State<_SwitchableIndexedStack> {
  int _index = 0;

  void setIndex(int value) {
    setState(() {
      _index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _index,
      children: const [
        Text('Page 0'),
        Text('Page 1'),
        Text('Page 2'),
      ],
    );
  }
}
