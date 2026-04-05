import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('SingleChildScrollView', () {
    testWidgets('renders child content within viewport', (tester) async {
      tester.pumpWidget(
        const SingleChildScrollView(child: Text('Hello World')),
      );

      await tester.pumpAndSettle();
      tester.assertBufferLines(['Hello World']);
    });

    testWidgets('scrolls down with arrow down key', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 30; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Item0');
      expect(tester.contains('Item24'), isFalse);

      tester.sendArrowDown();
      await tester.pumpAndSettle();

      expect(tester.contains('Item0'), isFalse);
      tester.assertContains('Item1');
      tester.assertContains('Item24');
    });

    testWidgets('scrolls up with arrow up key', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 30; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.sendArrowDown();
      await tester.pumpAndSettle();

      expect(tester.contains('Item0'), isFalse);

      tester.sendArrowUp();
      await tester.pumpAndSettle();

      tester.assertContains('Item0');
      expect(tester.contains('Item24'), isFalse);
    });

    testWidgets('does not scroll past top bounds', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 30; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Item0');

      for (int i = 0; i < 5; i++) {
        tester.sendArrowUp();
        await tester.pumpAndSettle();
      }

      tester.assertContains('Item0');
      expect(tester.contains('Item24'), isFalse);
    });

    testWidgets('does not scroll past bottom bounds', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 30; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      for (int i = 0; i < 20; i++) {
        tester.sendArrowDown();
        await tester.pumpAndSettle();
      }

      tester.assertContains('Item29');
      expect(tester.contains('Item0'), isFalse);
      expect(tester.contains('Item5'), isFalse);
    });

    testWidgets('handles content shorter than viewport', (tester) async {
      tester.pumpWidget(
        const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('LineA'), Text('LineB'), Text('LineC')],
          ),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('LineA');
      tester.assertContains('LineB');
      tester.assertContains('LineC');

      for (int i = 0; i < 5; i++) {
        tester.sendArrowDown();
        await tester.pumpAndSettle();
      }

      tester.assertContains('LineA');
      tester.assertContains('LineB');
      tester.assertContains('LineC');
    });

    testWidgets('respects padding', (tester) async {
      tester.pumpWidget(
        const SingleChildScrollView(
          padding: EdgeInsets.only(top: 2, left: 3),
          child: Text('Padded'),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertCellAt(3, 2, 'P');
      tester.assertCellAt(4, 2, 'a');
      tester.assertCellAt(3, 0, ' ');
      tester.assertCellAt(2, 2, ' ');
    });

    testWidgets('ScrollController integration', (tester) async {
      final controller = ScrollController();

      final children = <Widget>[];
      for (int i = 0; i < 30; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          controller: controller,
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Item0');
      expect(controller.offset, equals(0));

      controller.offset = 5;
      await tester.pumpAndSettle();

      expect(tester.contains('Item0'), isFalse);
      tester.assertContains('Item5');

      controller.offset = 0;
      await tester.pumpAndSettle();

      tester.assertContains('Item0');
    });

    testWidgets('page down scrolls by viewport minus one', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 50; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('Item0');

      tester.sendKey(KeyCode.pageDown);
      await tester.pumpAndSettle();

      expect(tester.contains('Item0'), isFalse);
      tester.assertContains('Item23');
    });

    testWidgets('page up scrolls by viewport minus one', (tester) async {
      final children = <Widget>[];
      for (int i = 0; i < 50; i++) {
        children.add(Text('Item$i'));
      }

      tester.pumpWidget(
        SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),
      );

      await tester.pumpAndSettle();

      tester.sendKey(KeyCode.pageDown);
      await tester.pumpAndSettle();

      expect(tester.contains('Item0'), isFalse);

      tester.sendKey(KeyCode.pageUp);
      await tester.pumpAndSettle();

      tester.assertContains('Item0');
    });

    testWidgets('renders empty child without error', (tester) async {
      tester.pumpWidget(const SingleChildScrollView(child: SizedBox()));

      await tester.pumpAndSettle();
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const SingleChildScrollView(child: Text('test')));

      await tester.pumpAndSettle();

      expect(find.byType<SingleChildScrollView>().exists, isTrue);
    });

    testWidgets('horizontal scroll direction with arrow keys', (tester) async {
      tester.pumpWidget(
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(width: 150, height: 1, child: Text('ABCDEFGHIJ')),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertCellAt(0, 0, 'A');

      for (int i = 0; i < 5; i++) {
        tester.sendArrowRight();
        await tester.pumpAndSettle();
      }

      tester.assertCellAt(0, 0, 'F');
    });
  });
}
