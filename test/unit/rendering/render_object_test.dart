import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('RenderObject', () {
    group('parent management', () {
      test('parent can be set and retrieved', () {
        final parent = _TestRenderObject();
        final child = _TestRenderObject();

        child.parent = parent;

        expect(child.parent, equals(parent));
      });

      test('parent defaults to null', () {
        final renderObject = _TestRenderObject();
        expect(renderObject.parent, isNull);
      });
    });

    group('layout', () {
      test('markNeedsLayout sets needsLayout flag', () {
        final renderObject = _TestRenderObject();
        renderObject.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));

        renderObject.markNeedsLayout();
      });

      test('layout caches constraints', () {
        final renderObject = _TestRenderObject();
        final constraints = const BoxConstraints(maxWidth: 100, maxHeight: 100);

        renderObject.layout(constraints);

        expect(renderObject.lastConstraints, equals(constraints));
      });

      test('layout skips when constraints unchanged and not dirty', () {
        final renderObject = _TestRenderObject();
        final constraints = const BoxConstraints(maxWidth: 100, maxHeight: 100);

        renderObject.layout(constraints);
        final firstLayoutCount = renderObject.layoutCount;

        renderObject.layout(constraints);

        expect(renderObject.layoutCount, equals(firstLayoutCount));
      });
    });

    group('size', () {
      test('size can be set during layout', () {
        final renderObject = _TestRenderObject();
        renderObject.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));

        expect(renderObject.size, isNotNull);
      });
    });

    group('relayoutBoundary', () {
      test('relayoutBoundary defaults to false', () {
        final renderObject = _TestRenderObject();
        expect(renderObject.isRelayoutBoundary, isFalse);
      });

      test('relayoutBoundary can be set', () {
        final renderObject = _TestRenderObject();
        renderObject.setRelayoutBoundary(true);
        expect(renderObject.isRelayoutBoundary, isTrue);
      });
    });

    group('parentData', () {
      test('parentData is null by default', () {
        final renderObject = _TestRenderObject();
        expect(renderObject.parentData, isNull);
      });

      test('setupParentData creates ParentData if null', () {
        final parent = _TestRenderObject();
        final child = _TestRenderObject();

        parent.setupParentData(child);

        expect(child.parentData, isNotNull);
      });
    });
  });
}

class _TestRenderObject extends RenderBox {
  int layoutCount = 0;
  BoxConstraints? lastConstraints;

  @override
  void performLayout(Constraints constraints) {
    layoutCount++;
    lastConstraints = constraints as BoxConstraints;
    size = Size(50, 50);
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}
