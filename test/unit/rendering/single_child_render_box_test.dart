import 'package:radartui/radartui.dart';
import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('SingleChildRenderBox', () {
    group('performLayout', () {
      test('passes constraints to child via getConstraintsForChild', () {
        final parent = _TestSingleChildRenderBox();
        final child = _TrackingRenderBox();
        parent.child = child;

        parent.layout(const BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 10,
          maxHeight: 100,
        ));

        expect(child.receivedConstraints, isNotNull);
        expect(child.receivedConstraints!.minWidth, equals(10));
        expect(child.receivedConstraints!.maxWidth, equals(100));
        expect(child.receivedConstraints!.minHeight, equals(10));
        expect(child.receivedConstraints!.maxHeight, equals(100));
      });

      test('uses child size when child is present', () {
        final parent = _TestSingleChildRenderBox();
        final child = _FixedSizeRenderBox(const Size(30, 20));
        parent.child = child;

        parent.layout(const BoxConstraints(
          maxWidth: 100,
          maxHeight: 100,
        ));

        expect(parent.size, equals(const Size(30, 20)));
      });

      test('uses computeSizeWithoutChild when no child', () {
        final parent = _TestSingleChildRenderBox();

        parent.layout(const BoxConstraints(
          maxWidth: 80,
          maxHeight: 60,
        ));

        expect(parent.size, equals(const Size(80, 60)));
      });

      test('uses custom getConstraintsForChild', () {
        final parent = _ConstrainingSingleChildRenderBox(
          childConstraints: const BoxConstraints(
            minWidth: 5,
            maxWidth: 50,
            minHeight: 5,
            maxHeight: 50,
          ),
        );
        final child = _TrackingRenderBox();
        parent.child = child;

        parent.layout(const BoxConstraints(
          maxWidth: 100,
          maxHeight: 100,
        ));

        expect(child.receivedConstraints!.maxWidth, equals(50));
        expect(child.receivedConstraints!.maxHeight, equals(50));
      });
    });

    group('paint', () {
      test('delegates to child paint with offset', () {
        final terminal = TestTerminal(width: 100, height: 50);
        final buffer = TestOutputBuffer(terminal);
        final context = PaintingContext(buffer);
        final parent = _OffsettingSingleChildRenderBox();
        final child = _TrackingRenderBox();
        parent.child = child;
        parent.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));

        parent.paint(context, const Offset(5, 3));

        expect(child.wasPainted, isTrue);
        expect(child.paintOffset, equals(const Offset(15, 9)));
      });

      test('does nothing when no child', () {
        final terminal = TestTerminal(width: 100, height: 50);
        final buffer = TestOutputBuffer(terminal);
        final context = PaintingContext(buffer);
        final parent = _TestSingleChildRenderBox();
        parent.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));

        parent.paint(context, Offset.zero);

        expect(parent.hasSize, isTrue);
      });
    });

    group('child setter', () {
      test('setting child sets parent reference', () {
        final parent = _TestSingleChildRenderBox();
        final child = _TrackingRenderBox();

        parent.child = child;

        expect(parent.child, equals(child));
        expect(child.parent, equals(parent));
      });

      test('replacing child clears previous child parent', () {
        final parent = _TestSingleChildRenderBox();
        final child1 = _TrackingRenderBox();
        final child2 = _TrackingRenderBox();

        parent.child = child1;
        parent.child = child2;

        expect(child1.parent, isNull);
        expect(child2.parent, equals(parent));
        expect(parent.child, equals(child2));
      });

      test('setting child to null clears parent', () {
        final parent = _TestSingleChildRenderBox();
        final child = _TrackingRenderBox();

        parent.child = child;
        parent.child = null;

        expect(parent.child, isNull);
        expect(child.parent, isNull);
      });
    });
  });
}

class _TestSingleChildRenderBox extends SingleChildRenderBox {
  @override
  void performLayout(Constraints constraints) {
    super.performLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

class _ConstrainingSingleChildRenderBox extends SingleChildRenderBox {
  _ConstrainingSingleChildRenderBox({required this.childConstraints});

  final BoxConstraints childConstraints;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      childConstraints;

  @override
  void performLayout(Constraints constraints) {
    super.performLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

class _OffsettingSingleChildRenderBox extends SingleChildRenderBox {
  @override
  Offset computeChildOffset(Offset parentOffset, Size childSize) =>
      Offset(parentOffset.x + 10, parentOffset.y + 6);

  @override
  void performLayout(Constraints constraints) {
    super.performLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}

class _TrackingRenderBox extends RenderBox {
  BoxConstraints? receivedConstraints;
  bool wasPainted = false;
  Offset paintOffset = Offset.zero;

  @override
  void performLayout(Constraints constraints) {
    receivedConstraints = constraints as BoxConstraints;
    size = const Size(40, 30);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    wasPainted = true;
    paintOffset = offset;
  }
}

class _FixedSizeRenderBox extends RenderBox {
  _FixedSizeRenderBox(this.fixedSize);

  final Size fixedSize;

  @override
  void performLayout(Constraints constraints) {
    size = fixedSize;
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}
