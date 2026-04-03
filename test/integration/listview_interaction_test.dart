import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('ListView rendering', () {
    testWidgets('ListView renders items with selection indicator', (
      tester,
    ) async {
      tester.pumpWidget(
        const ListView<String>(items: ['Item 1', 'Item 2', 'Item 3']),
      );

      await tester.pumpAndSettle();

      tester.assertContains('> Item 1');
      tester.assertContains('  Item 2');
    });
  });

  group('ListView interaction', () {
    testWidgets('ListView navigates with arrow keys', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;
      var selectedValue = '';

      tester.pumpWidget(
        ListView<String>(
          items: items,
          onItemSelected: (index, item) {
            selectedIndex = index;
            selectedValue = item;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowDown();
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
      expect(selectedValue, equals('Item 2'));
    });

    testWidgets('ListView navigates with j/k keys (vim-style)', (tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        ListView<String>(
          items: items,
          onItemSelected: (index, item) {
            selectedIndex = index;
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendChar('j');
      await tester.pumpAndSettle();

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('ListView triggers onItemSelected with Space', (tester) async {
      final items = ['Item 1', 'Item 2'];
      var selectedValue = '';

      tester.pumpWidget(
        ListView<String>(
          items: items,
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

    testWidgets('ListView does not go above first item', (tester) async {
      final items = ['Item 1', 'Item 2'];
      var selectedIndex = 999;

      tester.pumpWidget(
        ListView<String>(
          items: items,
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

    testWidgets('ListView does not go below last item', (tester) async {
      final items = ['Item 1', 'Item 2'];
      var selectedIndex = -1;

      tester.pumpWidget(
        ListView<String>(
          items: items,
          initialSelectedIndex: 1,
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

      expect(selectedIndex, equals(1));
    });

    testWidgets('ListView wrapAroundNavigation wraps to last from first', (
      tester,
    ) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];
      var selectedIndex = -1;

      tester.pumpWidget(
        ListView<String>(
          items: items,
          initialSelectedIndex: 0,
          wrapAroundNavigation: true,
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

      expect(selectedIndex, equals(2));
    });

    testWidgets('ListView wrapAroundNavigation wraps to first from last', (
      tester,
    ) async {
      final items = ['Item 1', 'Item 2'];
      var selectedIndex = -1;

      tester.pumpWidget(
        ListView<String>(
          items: items,
          initialSelectedIndex: 1,
          wrapAroundNavigation: true,
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

      expect(selectedIndex, equals(0));
    });

    testWidgets('ListView can be found by type', (tester) async {
      tester.pumpWidget(const ListView<String>(items: ['Item 1']));

      expect(find.byType<ListView<String>>().exists, isTrue);
    });

    testWidgets('ListView with custom builders', (tester) async {
      final items = ['Item 1', 'Item 2'];

      tester.pumpWidget(
        ListView<String>(
          items: items,
          selectedBuilder: (item) => Text('> $item'),
          unselectedBuilder: (item) => Text('  $item'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('> Item 1').exists, isTrue);
    });
  });
}
