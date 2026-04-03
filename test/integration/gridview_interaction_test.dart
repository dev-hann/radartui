import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('GridView rendering', () {
    testWidgets('GridView renders items in grid layout', (tester) async {
      tester.pumpWidget(
        const GridView<String>(
          items: ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6'],
          crossAxisCount: 3,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('> Item 1');
      tester.assertContains('  Item 2');
      tester.assertContains('  Item 3');
    });
  });

  group('GridView interaction', () {
    testWidgets('GridView navigates right with arrow key', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowRight();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('GridView navigates down with arrow key', (tester) async {
      final items = [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
        'Item 5',
        'Item 6',
      ];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 0,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowDown();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(3));
    });

    testWidgets('GridView navigates left with arrow key', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 2,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowLeft();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('GridView navigates up with arrow key', (tester) async {
      final items = [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
        'Item 5',
        'Item 6',
      ];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 4,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowUp();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('GridView triggers onItemSelected with Space', (tester) async {
      final items = ['Item 1', 'Item 2'];
      var selectedValue = '';

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 2,
          initialSelectedIndex: 0,
          onItemSelected: (index, item) {
            selectedValue = item;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(selectedValue, equals('Item 1'));
    });

    testWidgets('GridView does not go above first row', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = 999;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 0,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowUp();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(0));
    });

    testWidgets('GridView does not go past last item', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 2,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowRight();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(2));
    });

    testWidgets('GridView wrapAroundNavigation wraps to last from first', (
      tester,
    ) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 0,
          wrapAroundNavigation: true,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowLeft();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(2));
    });

    testWidgets('GridView wrapAroundNavigation wraps to first from last', (
      tester,
    ) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 3,
          initialSelectedIndex: 2,
          wrapAroundNavigation: true,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowRight();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(0));
    });

    testWidgets('GridView can be found by type', (tester) async {
      tester.pumpWidget(const GridView<String>(items: ['Item 1']));

      expect(find.byType<GridView<String>>().exists, isTrue);
    });

    testWidgets('GridView with custom builders', (tester) async {
      final items = ['Item 1', 'Item 2'];

      tester.pumpWidget(
        GridView<String>(
          items: items,
          crossAxisCount: 2,
          selectedBuilder: (item) => Text('[SELECTED: $item]'),
          unselectedBuilder: (item) => Text('  $item'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('[SELECTED: Item 1]').exists, isTrue);
    });
  });
}
