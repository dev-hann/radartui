import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('SizedBox', () {
    test('SizedBox creates with default width and height', () {
      const sizedBox = SizedBox(child: Text('a'));
      expect(sizedBox.width, equals(0));
      expect(sizedBox.height, equals(0));
    });

    test('SizedBox creates with custom width and height', () {
      const sizedBox = SizedBox(width: 10, height: 20, child: Text('a'));
      expect(sizedBox.width, equals(10));
      expect(sizedBox.height, equals(20));
    });

    test('SizedBox creates with width only', () {
      const sizedBox = SizedBox(width: 15);
      expect(sizedBox.width, equals(15));
      expect(sizedBox.height, equals(0));
    });

    test('SizedBox creates with height only', () {
      const sizedBox = SizedBox(height: 25);
      expect(sizedBox.width, equals(0));
      expect(sizedBox.height, equals(25));
    });

    test('SizedBox creates without child', () {
      const sizedBox = SizedBox(width: 10, height: 20);
      expect(sizedBox.width, equals(10));
      expect(sizedBox.height, equals(20));
      expect(sizedBox.child, isNull);
    });

    test('SizedBox.shrink creates zero-sized box', () {
      const sizedBox = SizedBox.shrink(child: Text('a'));
      expect(sizedBox.width, equals(0));
      expect(sizedBox.height, equals(0));
    });

    test('SizedBox.shrink creates without child', () {
      const sizedBox = SizedBox.shrink();
      expect(sizedBox.width, equals(0));
      expect(sizedBox.height, equals(0));
      expect(sizedBox.child, isNull);
    });

    test('SizedBox.square creates with equal dimensions', () {
      const sizedBox = SizedBox.square(dimension: 10, child: Text('a'));
      expect(sizedBox.width, equals(10));
      expect(sizedBox.height, equals(10));
    });

    test('SizedBox.square creates without child', () {
      const sizedBox = SizedBox.square(dimension: 5);
      expect(sizedBox.width, equals(5));
      expect(sizedBox.height, equals(5));
      expect(sizedBox.child, isNull);
    });

    test('SizedBox creates RenderSizedBox', () {
      const sizedBox = SizedBox(width: 10, height: 20);
      final renderObject = sizedBox.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderSizedBox>());
    });
  });

  group('RenderSizedBox', () {
    test('RenderSizedBox stores width and height', () {
      final renderSizedBox = RenderSizedBox(10, 20);
      expect(renderSizedBox.boxWidth, equals(10));
      expect(renderSizedBox.boxHeight, equals(20));
    });

    test('RenderSizedBox width and height are mutable', () {
      final renderSizedBox = RenderSizedBox(10, 20);
      renderSizedBox.boxWidth = 30;
      renderSizedBox.boxHeight = 40;
      expect(renderSizedBox.boxWidth, equals(30));
      expect(renderSizedBox.boxHeight, equals(40));
    });

    test('RenderSizedBox performLayout sets size without child', () {
      final renderSizedBox = RenderSizedBox(15, 25);
      renderSizedBox.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(renderSizedBox.size, equals(const Size(15, 25)));
    });

    test('RenderSizedBox performLayout sets size to zero for shrink', () {
      final renderSizedBox = RenderSizedBox(0, 0);
      renderSizedBox.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(renderSizedBox.size, equals(Size.zero));
    });

    test('RenderSizedBox performLayout with child uses tight constraints', () {
      final renderSizedBox = RenderSizedBox(20, 10);
      final child = _TrackingRenderBox();
      renderSizedBox.child = child;
      renderSizedBox.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(renderSizedBox.size, equals(const Size(20, 10)));
      expect(child.receivedConstraints?.maxWidth, equals(20));
      expect(child.receivedConstraints?.maxHeight, equals(10));
      expect(child.receivedConstraints?.isTight, isTrue);
    });
  });
}

class _TrackingRenderBox extends RenderBox {
  BoxConstraints? receivedConstraints;

  @override
  void performLayout(Constraints constraints) {
    receivedConstraints = constraints.asBoxConstraints;
    size = const Size(20, 10);
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
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
