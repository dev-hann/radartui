import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('LayoutBuilder', () {
    test('is a StatelessWidget', () {
      const layoutBuilder = LayoutBuilder(
        builder: _returnEmptyContainer,
      );
      expect(layoutBuilder, isA<StatelessWidget>());
    });

    test('build returns _LayoutBuilderWidget', () {
      const layoutBuilder = LayoutBuilder(
        builder: _returnEmptyContainer,
      );
      final result = layoutBuilder.build(_MockBuildContext());
      expect(result, isA<RenderObjectWidget>());
    });

    test('stores builder callback', () {
      const layoutBuilder = LayoutBuilder(
        builder: _returnEmptyContainer,
      );
      expect(layoutBuilder.builder, isNotNull);
    });
  });

  group('RenderLayoutBuilder', () {
    test('receives tight constraints', () {
      BoxConstraints? received;
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          received = constraints;
          return const SizedBox(width: 10, height: 10);
        },
        buildContext: _MockBuildContext(),
      );
      renderObject.performLayout(
        BoxConstraints.tight(const Size(20, 20)),
      );
      expect(received, isNotNull);
      expect(received!.isTight, isTrue);
      expect(received!.minWidth, equals(20));
      expect(received!.maxWidth, equals(20));
      expect(received!.minHeight, equals(20));
      expect(received!.maxHeight, equals(20));
    });

    test('receives loose constraints', () {
      BoxConstraints? received;
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          received = constraints;
          return const SizedBox(width: 5, height: 5);
        },
        buildContext: _MockBuildContext(),
      );
      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 50,
        ),
      );
      expect(received, isNotNull);
      expect(received!.isTight, isFalse);
      expect(received!.minWidth, equals(0));
      expect(received!.maxWidth, equals(100));
      expect(received!.minHeight, equals(0));
      expect(received!.maxHeight, equals(50));
    });

    test('builder is called during layout', () {
      int callCount = 0;
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          callCount++;
          return const SizedBox(width: 10, height: 10);
        },
        buildContext: _MockBuildContext(),
      );
      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(callCount, equals(1));
    });

    test('can return different widgets based on constraints', () {
      Widget? lastReturned;
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 50) {
            lastReturned = const SizedBox(width: 60, height: 10);
            return lastReturned!;
          }
          lastReturned = const SizedBox(width: 30, height: 10);
          return lastReturned!;
        },
        buildContext: _MockBuildContext(),
      );

      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 80,
          minHeight: 0,
          maxHeight: 80,
        ),
      );
      expect(
        (lastReturned as SizedBox).width,
        equals(60),
      );

      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 40,
          minHeight: 0,
          maxHeight: 40,
        ),
      );
      expect(
        (lastReturned as SizedBox).width,
        equals(30),
      );
    });

    test('sizes to child when child has render object', () {
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          return const SizedBox(width: 25, height: 15);
        },
        buildContext: _MockBuildContext(),
      );
      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(renderObject.size, equals(const Size(25, 15)));
    });

    test('sizes to zero when child has no render object', () {
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          return const _NoRenderWidget();
        },
        buildContext: _MockBuildContext(),
      );
      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(renderObject.size, equals(Size.zero));
    });

    test('updateRenderObject updates builder callback', () {
      int firstBuilderCalls = 0;
      int secondBuilderCalls = 0;
      final renderObject = RenderLayoutBuilder(
        builder: (context, constraints) {
          firstBuilderCalls++;
          return const SizedBox(width: 10, height: 10);
        },
        buildContext: _MockBuildContext(),
      );

      renderObject.builder = (context, constraints) {
        secondBuilderCalls++;
        return const SizedBox(width: 20, height: 20);
      };

      renderObject.performLayout(
        const BoxConstraints(
          minWidth: 0,
          maxWidth: 100,
          minHeight: 0,
          maxHeight: 100,
        ),
      );
      expect(firstBuilderCalls, equals(0));
      expect(secondBuilderCalls, equals(1));
    });
  });
}

Widget _returnEmptyContainer(BuildContext context, BoxConstraints constraints) {
  return const Container();
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

class _NoRenderWidget extends Widget {
  const _NoRenderWidget();

  @override
  Element createElement() => _NoRenderElement(this);
}

class _NoRenderElement extends Element {
  _NoRenderElement(super.widget);

  @override
  RenderObject? get renderObject => null;
}
