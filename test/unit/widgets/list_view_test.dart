import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('ListView', () {
    group('constructor', () {
      test('creates with required parameters', () {
        const listView = ListView<String>(items: ['a', 'b', 'c']);
        expect(listView.items, equals(['a', 'b', 'c']));
        expect(listView.initialSelectedIndex, equals(0));
        expect(listView.wrapAroundNavigation, isFalse);
      });

      test('creates with custom initial index', () {
        const listView = ListView<String>(
          items: ['a', 'b', 'c'],
          initialSelectedIndex: 1,
        );
        expect(listView.initialSelectedIndex, equals(1));
      });

      test('creates with wrap around navigation', () {
        const listView = ListView<String>(
          items: ['a', 'b', 'c'],
          wrapAroundNavigation: true,
        );
        expect(listView.wrapAroundNavigation, isTrue);
      });

      test('supports generic types', () {
        const listView = ListView<int>(items: [1, 2, 3]);
        expect(listView.items, equals([1, 2, 3]));
      });
    });

    group('builders', () {
      test('uses default selected builder', () {
        const listView = ListView<String>(items: ['test']);
        final widget = listView.selectedBuilder('test');
        expect(widget, isA<Text>());
      });

      test('uses default unselected builder', () {
        const listView = ListView<String>(items: ['test']);
        final widget = listView.unselectedBuilder('test');
        expect(widget, isA<Text>());
      });

      test('accepts custom builders', () {
        final listView = ListView<String>(
          items: ['test'],
          selectedBuilder: (item) => Text('SELECTED: $item'),
          unselectedBuilder: (item) => Text('UNSELECTED: $item'),
        );
        final selectedWidget = listView.selectedBuilder('test');
        final unselectedWidget = listView.unselectedBuilder('test');
        expect(selectedWidget, isA<Text>());
        expect(unselectedWidget, isA<Text>());
      });
    });
  });
}
