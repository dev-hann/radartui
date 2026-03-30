import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Positioned', () {
    test('Positioned creates with all parameters', () {
      const positioned = Positioned(
        left: 10,
        top: 5,
        right: 20,
        bottom: 15,
        width: 100,
        height: 50,
        child: Text('test'),
      );
      expect(positioned.left, equals(10));
      expect(positioned.top, equals(5));
      expect(positioned.right, equals(20));
      expect(positioned.bottom, equals(15));
      expect(positioned.width, equals(100));
      expect(positioned.height, equals(50));
    });

    test('Positioned.fill creates with zero offsets', () {
      const positioned = Positioned.fill(
        child: Text('test'),
      );
      expect(positioned.left, equals(0));
      expect(positioned.top, equals(0));
      expect(positioned.right, equals(0));
      expect(positioned.bottom, equals(0));
      expect(positioned.width, isNull);
      expect(positioned.height, isNull);
    });

    test('Positioned creates with partial parameters', () {
      const positioned = Positioned(
        left: 10,
        top: 5,
        child: Text('test'),
      );
      expect(positioned.left, equals(10));
      expect(positioned.top, equals(5));
      expect(positioned.right, isNull);
      expect(positioned.bottom, isNull);
      expect(positioned.width, isNull);
      expect(positioned.height, isNull);
    });

    test('Positioned child is accessible', () {
      const positioned = Positioned(
        left: 10,
        child: Text('test'),
      );
      expect(positioned.child, isA<Text>());
    });

    test('Positioned is a ParentDataWidget', () {
      const positioned = Positioned(
        child: Text('test'),
      );
      expect(positioned, isA<ParentDataWidget>());
    });

    test('Positioned.applyParentData sets StackParentData', () {
      const positioned = Positioned(
        left: 10,
        top: 5,
        child: Text('test'),
      );
      final renderObject = _TestRenderBox();
      renderObject.parentData = StackParentData();

      positioned.applyParentData(renderObject);

      final parentData = renderObject.parentData as StackParentData;
      expect(parentData.left, equals(10));
      expect(parentData.top, equals(5));
    });
  });

  group('StackParentData', () {
    test('StackParentData default values are null', () {
      final data = StackParentData();
      expect(data.left, isNull);
      expect(data.top, isNull);
      expect(data.right, isNull);
      expect(data.bottom, isNull);
      expect(data.width, isNull);
      expect(data.height, isNull);
      expect(data.offset, equals(Offset.zero));
    });

    test('StackParentData can set values', () {
      final data = StackParentData();
      data.left = 10;
      data.top = 5;
      data.right = 20;
      data.bottom = 15;
      data.width = 100;
      data.height = 50;
      data.offset = const Offset(30, 40);

      expect(data.left, equals(10));
      expect(data.top, equals(5));
      expect(data.right, equals(20));
      expect(data.bottom, equals(15));
      expect(data.width, equals(100));
      expect(data.height, equals(50));
      expect(data.offset, equals(const Offset(30, 40)));
    });
  });

  group('ParentDataWidget', () {
    test('ParentDataWidget has child', () {
      final widget = _TestParentDataWidget(child: const Text('test'));
      expect(widget.child, isA<Text>());
    });
  });
}

class _TestRenderBox extends RenderBox {
  @override
  void performLayout(Constraints constraints) {
    size = const Size(100, 50);
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}

class _TestParentDataWidget extends ParentDataWidget<ParentData> {
  _TestParentDataWidget({required super.child});

  @override
  void applyParentData(RenderObject renderObject) {}
}
