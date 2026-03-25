import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('RenderBox', () {
    group('convenience properties', () {
      test('hasSize returns false when size is null', () {
        final renderBox = _TestRenderBox();
        expect(renderBox.hasSize, isFalse);
      });

      test('hasSize returns true when size is set', () {
        final renderBox = _TestRenderBox();
        renderBox.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));
        expect(renderBox.hasSize, isTrue);
      });

      test('width returns size width', () {
        final renderBox = _TestRenderBox();
        renderBox.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));
        expect(renderBox.width, equals(50));
      });

      test('height returns size height', () {
        final renderBox = _TestRenderBox();
        renderBox.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));
        expect(renderBox.height, equals(50));
      });

      test('width returns 0 when size is null', () {
        final renderBox = _TestRenderBox();
        expect(renderBox.width, equals(0));
      });

      test('height returns 0 when size is null', () {
        final renderBox = _TestRenderBox();
        expect(renderBox.height, equals(0));
      });

      test('widthInt returns integer width', () {
        final renderBox = _TestRenderBox();
        renderBox.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));
        expect(renderBox.widthInt, equals(50));
      });

      test('heightInt returns integer height', () {
        final renderBox = _TestRenderBox();
        renderBox.layout(const BoxConstraints(maxWidth: 100, maxHeight: 100));
        expect(renderBox.heightInt, equals(50));
      });
    });
  });

  group('RenderObjectWithChildMixin', () {
    test('child can be set and retrieved', () {
      final parent = _TestRenderBoxWithChild();
      final child = _TestRenderBox();

      parent.child = child;

      expect(parent.child, equals(child));
      expect(child.parent, equals(parent));
    });

    test('hasChild returns correct value', () {
      final parent = _TestRenderBoxWithChild();

      expect(parent.hasChild, isFalse);

      parent.child = _TestRenderBox();

      expect(parent.hasChild, isTrue);
    });

    test('setting new child clears previous child parent', () {
      final parent = _TestRenderBoxWithChild();
      final child1 = _TestRenderBox();
      final child2 = _TestRenderBox();

      parent.child = child1;
      parent.child = child2;

      expect(child1.parent, isNull);
      expect(child2.parent, equals(parent));
    });

    test('setting child to null clears parent', () {
      final parent = _TestRenderBoxWithChild();
      final child = _TestRenderBox();

      parent.child = child;
      parent.child = null;

      expect(parent.child, isNull);
      expect(child.parent, isNull);
    });
  });

  group('ContainerRenderObjectMixin', () {
    test('add adds child and sets parent', () {
      final container = _TestContainerRenderObject();
      final child = _TestRenderBox();

      container.add(child);

      expect(container.children.contains(child), isTrue);
      expect(child.parent, equals(container));
    });

    test('remove removes child and clears parent', () {
      final container = _TestContainerRenderObject();
      final child = _TestRenderBox();

      container.add(child);
      container.remove(child);

      expect(container.children.contains(child), isFalse);
      expect(child.parent, isNull);
    });

    test('clear removes all children', () {
      final container = _TestContainerRenderObject();
      container.add(_TestRenderBox());
      container.add(_TestRenderBox());
      container.add(_TestRenderBox());

      container.clear();

      expect(container.children.isEmpty, isTrue);
    });
  });
}

class _TestRenderBox extends RenderBox {
  @override
  void performLayout(Constraints constraints) {
    size = const Size(50, 50);
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}

class _TestRenderBoxWithChild extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  @override
  void performLayout(Constraints constraints) {
    final bc = constraints as BoxConstraints;
    size = const Size(100, 100);
    child?.layout(bc);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}

class _TestContainerRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, ParentData> {
  @override
  void performLayout(Constraints constraints) {
    final bc = constraints as BoxConstraints;
    size = const Size(100, 100);
    for (final child in children) {
      child.layout(bc);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      context.paintChild(child, offset);
    }
  }
}
