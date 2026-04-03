import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('GridView', () {
    group('constructor', () {
      test('creates with required parameters', () {
        const gridView = GridView<String>(items: ['a', 'b', 'c']);
        expect(gridView.items, equals(['a', 'b', 'c']));
        expect(gridView.crossAxisCount, equals(2));
        expect(gridView.mainAxisSpacing, equals(0));
        expect(gridView.crossAxisSpacing, equals(0));
        expect(gridView.initialSelectedIndex, equals(0));
        expect(gridView.wrapAroundNavigation, isFalse);
      });

      test('creates with custom crossAxisCount', () {
        const gridView = GridView<String>(
          items: ['a', 'b', 'c'],
          crossAxisCount: 3,
        );
        expect(gridView.crossAxisCount, equals(3));
      });

      test('creates with custom spacing', () {
        const gridView = GridView<String>(
          items: ['a', 'b', 'c', 'd'],
          mainAxisSpacing: 2,
          crossAxisSpacing: 1,
        );
        expect(gridView.mainAxisSpacing, equals(2));
        expect(gridView.crossAxisSpacing, equals(1));
      });

      test('creates with custom initial index', () {
        const gridView = GridView<String>(
          items: ['a', 'b', 'c'],
          initialSelectedIndex: 1,
        );
        expect(gridView.initialSelectedIndex, equals(1));
      });

      test('creates with wrap around navigation', () {
        const gridView = GridView<String>(
          items: ['a', 'b', 'c'],
          wrapAroundNavigation: true,
        );
        expect(gridView.wrapAroundNavigation, isTrue);
      });

      test('supports generic types', () {
        const gridView = GridView<int>(items: [1, 2, 3]);
        expect(gridView.items, equals([1, 2, 3]));
      });
    });

    group('builders', () {
      test('uses default selected builder', () {
        const gridView = GridView<String>(items: ['test']);
        final widget = gridView.selectedBuilder('test');
        expect(widget, isA<Text>());
      });

      test('uses default unselected builder', () {
        const gridView = GridView<String>(items: ['test']);
        final widget = gridView.unselectedBuilder('test');
        expect(widget, isA<Text>());
      });

      test('accepts custom builders', () {
        final gridView = GridView<String>(
          items: ['test'],
          selectedBuilder: (item) => Text('SELECTED: $item'),
          unselectedBuilder: (item) => Text('UNSELECTED: $item'),
        );
        final selectedWidget = gridView.selectedBuilder('test');
        final unselectedWidget = gridView.unselectedBuilder('test');
        expect(selectedWidget, isA<Text>());
        expect(unselectedWidget, isA<Text>());
      });
    });
  });
}
