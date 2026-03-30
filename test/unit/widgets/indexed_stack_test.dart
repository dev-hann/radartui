import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('IndexedStack widget', () {
    test('creates with default index 0', () {
      const indexedStack = IndexedStack(children: [Text('a'), Text('b')]);
      expect(indexedStack.index, equals(0));
      expect(indexedStack.children.length, equals(2));
    });

    test('creates with custom index', () {
      const indexedStack = IndexedStack(
        index: 1,
        children: [Text('a'), Text('b'), Text('c')],
      );
      expect(indexedStack.index, equals(1));
    });

    test('creates with empty children', () {
      const indexedStack = IndexedStack(children: []);
      expect(indexedStack.index, equals(0));
      expect(indexedStack.children.length, equals(0));
    });

    test('creates RenderIndexedStack', () {
      const indexedStack = IndexedStack(children: [Text('a')]);
      final renderObject = indexedStack.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderIndexedStack>());
    });

    test('RenderIndexedStack has default index 0', () {
      final renderObject = RenderIndexedStack();
      expect(renderObject.index, equals(0));
    });

    test('RenderIndexedStack index can be set', () {
      final renderObject = RenderIndexedStack();
      renderObject.index = 2;
      expect(renderObject.index, equals(2));
    });

    test('updateRenderObject updates index', () {
      const indexedStack = IndexedStack(
        index: 1,
        children: [Text('a'), Text('b')],
      );
      final renderObject = RenderIndexedStack();
      indexedStack.updateRenderObject(_MockBuildContext(), renderObject);
      expect(renderObject.index, equals(1));
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
