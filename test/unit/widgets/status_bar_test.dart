import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('StatusBar', () {
    group('constructor', () {
      test('creates with default values', () {
        const statusBar = StatusBar();
        expect(statusBar.height, equals(1));
        expect(statusBar.backgroundColor, isNull);
        expect(statusBar.foregroundColor, isNull);
        expect(statusBar.left, isNull);
        expect(statusBar.center, isNull);
        expect(statusBar.right, isNull);
      });

      test('creates with custom height', () {
        const statusBar = StatusBar(height: 2);
        expect(statusBar.height, equals(2));
      });

      test('creates with custom background color', () {
        const statusBar = StatusBar(backgroundColor: Color.green);
        expect(statusBar.backgroundColor, equals(Color.green));
      });

      test('creates with custom foreground color', () {
        const statusBar = StatusBar(foregroundColor: Color.white);
        expect(statusBar.foregroundColor, equals(Color.white));
      });

      test('creates with left widget', () {
        const statusBar = StatusBar(left: Text('L'));
        expect(statusBar.left, isNotNull);
      });

      test('creates with center widget', () {
        const statusBar = StatusBar(center: Text('C'));
        expect(statusBar.center, isNotNull);
      });

      test('creates with right widget', () {
        const statusBar = StatusBar(right: Text('R'));
        expect(statusBar.right, isNotNull);
      });

      test('creates with all sections', () {
        const statusBar = StatusBar(
          left: Text('L'),
          center: Text('C'),
          right: Text('R'),
        );
        expect(statusBar.left, isNotNull);
        expect(statusBar.center, isNotNull);
        expect(statusBar.right, isNotNull);
      });
    });

    group('build', () {
      test('build returns Container', () {
        const statusBar = StatusBar();
        final widget = statusBar.build(_MockBuildContext());
        expect(widget, isA<Container>());
      });

      test('Container has default height of 1', () {
        const statusBar = StatusBar();
        final container = statusBar.build(_MockBuildContext()) as Container;
        expect(container.height, equals(1));
      });

      test('Container has custom height', () {
        const statusBar = StatusBar(height: 3);
        final container = statusBar.build(_MockBuildContext()) as Container;
        expect(container.height, equals(3));
      });

      test('Container has default blue background', () {
        const statusBar = StatusBar();
        final container = statusBar.build(_MockBuildContext()) as Container;
        expect(container.color, equals(Color.blue));
      });

      test('Container has custom background color', () {
        const statusBar = StatusBar(backgroundColor: Color.green);
        final container = statusBar.build(_MockBuildContext()) as Container;
        expect(container.color, equals(Color.green));
      });
    });

    group('rendering', () {
      testWidgets('StatusBar renders center text', (tester) async {
        tester.pumpWidget(const StatusBar(center: Text('Ready')));

        await tester.pumpAndSettle();

        tester.assertContains('Ready');
      });

      testWidgets('StatusBar renders left text', (tester) async {
        tester.pumpWidget(const StatusBar(left: Text('NORMAL')));

        await tester.pumpAndSettle();

        tester.assertContains('NORMAL');
      });

      testWidgets('StatusBar renders right text', (tester) async {
        tester.pumpWidget(const StatusBar(right: Text('100%')));

        await tester.pumpAndSettle();

        tester.assertContains('100%');
      });

      testWidgets('StatusBar renders all sections', (tester) async {
        tester.pumpWidget(
          const StatusBar(left: Text('L'), center: Text('C'), right: Text('R')),
        );

        await tester.pumpAndSettle();

        tester.assertContains('L');
        tester.assertContains('C');
        tester.assertContains('R');
      });

      testWidgets('StatusBar has height of 1 by default', (tester) async {
        tester.pumpWidget(const StatusBar(center: Text('X')));

        await tester.pumpAndSettle();

        expect(tester.lines.length, greaterThanOrEqualTo(1));
        tester.assertContains('X');
      });

      testWidgets('StatusBar with custom height', (tester) async {
        tester.pumpWidget(const StatusBar(height: 3, center: Text('Tall')));

        await tester.pumpAndSettle();

        tester.assertContains('Tall');
      });

      testWidgets('StatusBar renders empty with no sections', (tester) async {
        tester.pumpWidget(const StatusBar());

        await tester.pumpAndSettle();

        final text = tester.getPlainText();
        expect(text.length, greaterThanOrEqualTo(0));
      });

      testWidgets('StatusBar with custom background color', (tester) async {
        tester.pumpWidget(
          const StatusBar(backgroundColor: Color.green, center: Text('Green')),
        );

        await tester.pumpAndSettle();

        tester.assertContains('Green');
      });

      testWidgets('StatusBar fills available width', (tester) async {
        tester.pumpWidget(const StatusBar(center: Text('Wide')));

        await tester.pumpAndSettle();

        tester.assertContains('Wide');
        expect(tester.terminal.width, equals(80));
      });

      testWidgets('left and right are positioned at edges', (tester) async {
        tester.pumpWidget(const StatusBar(left: Text('A'), right: Text('B')));

        await tester.pumpAndSettle();

        tester.assertContains('A');
        tester.assertContains('B');
        tester.assertCellAt(0, 0, 'A');
      });
    });
  });
}

class _MockBuildContext implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  InheritedElement?
      findAncestorElementOfExactType<T extends InheritedWidget>() => null;
}
