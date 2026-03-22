import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Spacer', () {
    group('constructor', () {
      test('creates with default flex', () {
        const spacer = Spacer();
        expect(spacer.flex, equals(1));
      });

      test('creates with custom flex', () {
        const spacer = Spacer(flex: 2);
        expect(spacer.flex, equals(2));
      });

      test('creates with flex 3', () {
        const spacer = Spacer(flex: 3);
        expect(spacer.flex, equals(3));
      });
    });

    group('build', () {
      test('build returns Expanded widget', () {
        const spacer = Spacer();
        final widget = spacer.build(BuildContextMock());
        expect(widget, isA<Expanded>());
      });

      test('Expanded has correct flex value', () {
        const spacer = Spacer(flex: 5);
        final widget = spacer.build(BuildContextMock()) as Expanded;
        expect(widget.flex, equals(5));
      });

      test('Expanded contains SizedBox.shrink', () {
        const spacer = Spacer();
        final widget = spacer.build(BuildContextMock()) as Expanded;
        expect(widget.child, isA<SizedBox>());
      });
    });
  });
}

class BuildContextMock implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  InheritedElement? findAncestorElementOfExactType<T extends InheritedWidget>() =>
      null;
}
