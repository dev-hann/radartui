import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Padding', () {
    test('Padding creates with required padding and child', () {
      const padding = Padding(padding: EdgeInsets.all(4), child: Text('a'));
      expect(padding.padding, equals(const EdgeInsets.all(4)));
      expect(padding.child, isA<Text>());
    });

    test('Padding creates with symmetric EdgeInsets', () {
      const padding = Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        child: Text('a'),
      );
      expect(padding.padding.left, equals(2));
      expect(padding.padding.right, equals(2));
      expect(padding.padding.top, equals(3));
      expect(padding.padding.bottom, equals(3));
    });

    test('Padding creates with EdgeInsets.only', () {
      const padding = Padding(
        padding: EdgeInsets.only(left: 1, top: 2, right: 3, bottom: 4),
        child: Text('a'),
      );
      expect(padding.padding.left, equals(1));
      expect(padding.padding.top, equals(2));
      expect(padding.padding.right, equals(3));
      expect(padding.padding.bottom, equals(4));
    });

    test('Padding creates RenderPadding', () {
      const padding = Padding(padding: EdgeInsets.all(4), child: Text('a'));
      final renderObject = padding.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderPadding>());
    });

    test('Padding updateRenderObject sets padding', () {
      const padding = Padding(padding: EdgeInsets.all(4), child: Text('a'));
      final renderObject = padding.createRenderObject(_MockBuildContext());
      expect(renderObject.padding, equals(const EdgeInsets.all(4)));
    });
  });

  group('RenderPadding', () {
    test('RenderPadding stores padding', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(3));
      expect(renderPadding.padding, equals(const EdgeInsets.all(3)));
    });

    test('RenderPadding padding is mutable', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(3));
      renderPadding.padding = const EdgeInsets.all(5);
      expect(renderPadding.padding, equals(const EdgeInsets.all(5)));
    });

    test('getConstraintsForChild deflates constraints', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(4));
      const constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
        minHeight: 0,
        maxHeight: 50,
      );
      final childConstraints = renderPadding.getConstraintsForChild(
        constraints,
      );
      expect(childConstraints.maxWidth, equals(92));
      expect(childConstraints.maxHeight, equals(42));
    });

    test('computeSizeFromChild adds padding to child size', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(4));
      const constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
        minHeight: 0,
        maxHeight: 50,
      );
      final size = renderPadding.computeSizeFromChild(
        constraints,
        const Size(20, 10),
      );
      expect(size.width, equals(28));
      expect(size.height, equals(18));
    });

    test('computeSizeWithoutChild returns padding size', () {
      final renderPadding = RenderPadding(
        padding: const EdgeInsets.fromLTRB(2, 3, 4, 5),
      );
      const constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
        minHeight: 0,
        maxHeight: 50,
      );
      final size = renderPadding.computeSizeWithoutChild(constraints);
      expect(size.width, equals(6));
      expect(size.height, equals(8));
    });

    test('computeChildOffset adds padding offset', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(4));
      final offset = renderPadding.computeChildOffset(
        const Offset(10, 20),
        const Size(20, 10),
      );
      expect(offset.x, equals(14));
      expect(offset.y, equals(24));
    });

    test('computeSizeFromChild with symmetric padding', () {
      final renderPadding = RenderPadding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      );
      const constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
        minHeight: 0,
        maxHeight: 50,
      );
      final size = renderPadding.computeSizeFromChild(
        constraints,
        const Size(30, 20),
      );
      expect(size.width, equals(40));
      expect(size.height, equals(26));
    });

    test('getConstraintsForChild with zero padding', () {
      final renderPadding = RenderPadding(padding: const EdgeInsets.all(0));
      const constraints = BoxConstraints(
        minWidth: 0,
        maxWidth: 100,
        minHeight: 0,
        maxHeight: 50,
      );
      final childConstraints = renderPadding.getConstraintsForChild(
        constraints,
      );
      expect(childConstraints.maxWidth, equals(100));
      expect(childConstraints.maxHeight, equals(50));
    });

    test('computeChildOffset with EdgeInsets.only left and top', () {
      final renderPadding = RenderPadding(
        padding: const EdgeInsets.only(left: 10, top: 5),
      );
      final offset = renderPadding.computeChildOffset(
        Offset.zero,
        const Size(20, 10),
      );
      expect(offset.x, equals(10));
      expect(offset.y, equals(5));
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
