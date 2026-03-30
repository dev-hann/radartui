import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Stack widget', () {
    test('Stack creates with children', () {
      const stack = Stack(children: [Text('a'), Text('b')]);
      expect(stack.children.length, equals(2));
    });

    test('Stack creates RenderStack', () {
      const stack = Stack(children: [Text('a')]);
      final renderObject = stack.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderStack>());
    });
  });

  group('RenderStack', () {
    test('RenderStack has setupParentData', () {
      final renderStack = RenderStack();
      final child = _MockRenderBox();
      renderStack.setupParentData(child);
      expect(child.parentData, isA<StackParentData>());
    });

    test('RenderStack setupParentData preserves existing StackParentData', () {
      final renderStack = RenderStack();
      final child = _MockRenderBox();
      final existingData = StackParentData();
      existingData.left = 10;
      child.parentData = existingData;

      renderStack.setupParentData(child);
      expect(child.parentData, equals(existingData));
      expect((child.parentData as StackParentData).left, equals(10));
    });
  });

  group('StackParentData', () {
    test('StackParentData has default values', () {
      final data = StackParentData();
      expect(data.left, isNull);
      expect(data.top, isNull);
      expect(data.right, isNull);
      expect(data.bottom, isNull);
      expect(data.width, isNull);
      expect(data.height, isNull);
      expect(data.offset, equals(Offset.zero));
    });

    test('StackParentData can set all values', () {
      final data = StackParentData();
      data.left = 10;
      data.top = 20;
      data.right = 30;
      data.bottom = 40;
      data.width = 100;
      data.height = 50;
      data.offset = const Offset(5, 15);

      expect(data.left, equals(10));
      expect(data.top, equals(20));
      expect(data.right, equals(30));
      expect(data.bottom, equals(40));
      expect(data.width, equals(100));
      expect(data.height, equals(50));
      expect(data.offset, equals(const Offset(5, 15)));
    });
  });

  group('Positioned widget', () {
    test('Positioned creates with left', () {
      const positioned = Positioned(left: 10, child: Text('a'));
      expect(positioned.left, equals(10));
      expect(positioned.top, isNull);
      expect(positioned.right, isNull);
      expect(positioned.bottom, isNull);
    });

    test('Positioned creates with top', () {
      const positioned = Positioned(top: 20, child: Text('a'));
      expect(positioned.top, equals(20));
      expect(positioned.left, isNull);
    });

    test('Positioned creates with right', () {
      const positioned = Positioned(right: 30, child: Text('a'));
      expect(positioned.right, equals(30));
    });

    test('Positioned creates with bottom', () {
      const positioned = Positioned(bottom: 40, child: Text('a'));
      expect(positioned.bottom, equals(40));
    });

    test('Positioned creates with all sides', () {
      const positioned = Positioned(
        left: 10,
        top: 20,
        right: 30,
        bottom: 40,
        child: Text('a'),
      );
      expect(positioned.left, equals(10));
      expect(positioned.top, equals(20));
      expect(positioned.right, equals(30));
      expect(positioned.bottom, equals(40));
    });

    test('Positioned creates with width and height', () {
      const positioned = Positioned(
        left: 10,
        top: 20,
        width: 100,
        height: 50,
        child: Text('a'),
      );
      expect(positioned.width, equals(100));
      expect(positioned.height, equals(50));
    });

    test('Positioned has child', () {
      const positioned = Positioned(left: 10, child: Text('a'));
      expect(positioned.child, isA<Text>());
    });

    test('Positioned applies StackParentData when parentData exists', () {
      const positioned = Positioned(
        left: 10,
        top: 20,
        right: 30,
        bottom: 40,
        width: 100,
        height: 50,
        child: Text('a'),
      );
      final renderObject = _MockRenderBox();
      renderObject.parentData = StackParentData();
      positioned.applyParentData(renderObject);

      expect(renderObject.parentData, isA<StackParentData>());
      final data = renderObject.parentData as StackParentData;
      expect(data.left, equals(10));
      expect(data.top, equals(20));
      expect(data.right, equals(30));
      expect(data.bottom, equals(40));
      expect(data.width, equals(100));
      expect(data.height, equals(50));
    });

    test('Positioned preserves existing StackParentData offset', () {
      const positioned = Positioned(left: 10, child: Text('a'));
      final renderObject = _MockRenderBox();
      final existingData = StackParentData();
      existingData.offset = const Offset(100, 200);
      renderObject.parentData = existingData;

      positioned.applyParentData(renderObject);

      final data = renderObject.parentData as StackParentData;
      expect(data.offset, equals(const Offset(100, 200)));
      expect(data.left, equals(10));
    });
  });

  group('Positioned.fill', () {
    test('Positioned.fill creates with all zeros', () {
      const positioned = Positioned.fill(child: Text('a'));
      expect(positioned.left, equals(0));
      expect(positioned.top, equals(0));
      expect(positioned.right, equals(0));
      expect(positioned.bottom, equals(0));
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

class _MockRenderBox extends RenderBox {
  @override
  void performLayout(Constraints constraints) {}

  @override
  void paint(PaintingContext context, Offset offset) {}
}
