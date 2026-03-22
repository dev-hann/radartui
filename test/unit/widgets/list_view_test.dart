import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('ListView', () {
    group('constructor', () {
      test('creates with required parameters', () {
        final listView = ListView<String>(
          items: ['a', 'b', 'c'],
        );
        expect(listView.items, equals(['a', 'b', 'c']));
        expect(listView.initialSelectedIndex, equals(0));
        expect(listView.wrapAroundNavigation, isFalse);
      });

      test('creates with custom initial index', () {
        final listView = ListView<String>(
          items: ['a', 'b', 'c'],
          initialSelectedIndex: 1,
        );
        expect(listView.initialSelectedIndex, equals(1));
      });

      test('creates with wrap around navigation', () {
        final listView = ListView<String>(
          items: ['a', 'b', 'c'],
          wrapAroundNavigation: true,
        );
        expect(listView.wrapAroundNavigation, isTrue);
      });

      test('supports generic types', () {
        final listView = ListView<int>(
          items: [1, 2, 3],
        );
        expect(listView.items, equals([1, 2, 3]));
      });
    });

    group('builders', () {
      test('uses default selected builder', () {
        final listView = ListView<String>(
          items: ['test'],
        );
        final widget = listView.selectedBuilder('test');
        expect(widget, isA<Text>());
      });

      test('uses default unselected builder', () {
        final listView = ListView<String>(
          items: ['test'],
        );
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
