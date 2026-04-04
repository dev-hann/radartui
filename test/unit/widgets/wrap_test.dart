import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Wrap widget', () {
    test('Wrap creates with children', () {
      const wrap = Wrap(children: [Text('a'), Text('b')]);
      expect(wrap.children.length, equals(2));
    });

    test('Wrap creates with direction', () {
      const wrap = Wrap(direction: Axis.vertical, children: [Text('a')]);
      expect(wrap.direction, equals(Axis.vertical));
    });

    test('Wrap creates with alignment', () {
      const wrap = Wrap(alignment: WrapAlignment.center, children: [Text('a')]);
      expect(wrap.alignment, equals(WrapAlignment.center));
    });

    test('Wrap creates with crossAxisAlignment', () {
      const wrap = Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [Text('a')],
      );
      expect(wrap.crossAxisAlignment, equals(WrapCrossAlignment.end));
    });

    test('Wrap creates with spacing', () {
      const wrap = Wrap(spacing: 2, children: [Text('a')]);
      expect(wrap.spacing, equals(2));
    });

    test('Wrap creates with runSpacing', () {
      const wrap = Wrap(runSpacing: 1, children: [Text('a')]);
      expect(wrap.runSpacing, equals(1));
    });

    test('Wrap creates RenderWrap', () {
      const wrap = Wrap(children: [Text('a')]);
      final renderObject = wrap.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderWrap>());
    });
  });

  group('RenderWrap', () {
    test('RenderWrap has direction default', () {
      final renderWrap = RenderWrap();
      expect(renderWrap.direction, equals(Axis.horizontal));
    });

    test('RenderWrap has alignment default', () {
      final renderWrap = RenderWrap();
      expect(renderWrap.alignment, equals(WrapAlignment.start));
    });

    test('RenderWrap has crossAxisAlignment default', () {
      final renderWrap = RenderWrap();
      expect(renderWrap.crossAxisAlignment, equals(WrapCrossAlignment.start));
    });

    test('RenderWrap has spacing default', () {
      final renderWrap = RenderWrap();
      expect(renderWrap.spacing, equals(0));
    });

    test('RenderWrap has runSpacing default', () {
      final renderWrap = RenderWrap();
      expect(renderWrap.runSpacing, equals(0));
    });

    test('RenderWrap can update properties', () {
      final renderWrap = RenderWrap();
      renderWrap.direction = Axis.vertical;
      renderWrap.alignment = WrapAlignment.end;
      renderWrap.crossAxisAlignment = WrapCrossAlignment.center;
      renderWrap.spacing = 2;
      renderWrap.runSpacing = 1;

      expect(renderWrap.direction, equals(Axis.vertical));
      expect(renderWrap.alignment, equals(WrapAlignment.end));
      expect(renderWrap.crossAxisAlignment, equals(WrapCrossAlignment.center));
      expect(renderWrap.spacing, equals(2));
      expect(renderWrap.runSpacing, equals(1));
    });

    test('RenderWrap setupParentData sets WrapParentData', () {
      final renderWrap = RenderWrap();
      final child = _MockRenderBox();
      renderWrap.setupParentData(child);
      expect(child.parentData, isA<WrapParentData>());
    });
  });

  group('WrapParentData', () {
    test('WrapParentData has default offset', () {
      final data = WrapParentData();
      expect(data.offset, equals(Offset.zero));
    });

    test('WrapParentData offset can be set', () {
      final data = WrapParentData();
      data.offset = const Offset(10, 20);
      expect(data.offset, equals(const Offset(10, 20)));
    });
  });

  group('WrapAlignment', () {
    test('WrapAlignment has all values', () {
      expect(WrapAlignment.values.length, equals(6));
      expect(WrapAlignment.values, contains(WrapAlignment.start));
      expect(WrapAlignment.values, contains(WrapAlignment.end));
      expect(WrapAlignment.values, contains(WrapAlignment.center));
      expect(WrapAlignment.values, contains(WrapAlignment.spaceBetween));
      expect(WrapAlignment.values, contains(WrapAlignment.spaceAround));
      expect(WrapAlignment.values, contains(WrapAlignment.spaceEvenly));
    });
  });

  group('WrapCrossAlignment', () {
    test('WrapCrossAlignment has all values', () {
      expect(WrapCrossAlignment.values.length, equals(3));
      expect(WrapCrossAlignment.values, contains(WrapCrossAlignment.start));
      expect(WrapCrossAlignment.values, contains(WrapCrossAlignment.end));
      expect(WrapCrossAlignment.values, contains(WrapCrossAlignment.center));
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
