import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Flex widget', () {
    test('Flex creates with direction', () {
      const flex = Flex(
        direction: Axis.horizontal,
        children: [Text('a'), Text('b')],
      );
      expect(flex.direction, equals(Axis.horizontal));
    });

    test('Flex creates with mainAxisAlignment', () {
      const flex = Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('a')],
      );
      expect(flex.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    test('Flex creates with crossAxisAlignment', () {
      const flex = Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('a')],
      );
      expect(flex.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    test('Flex creates with mainAxisSize', () {
      const flex = Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [Text('a')],
      );
      expect(flex.mainAxisSize, equals(MainAxisSize.min));
    });

    test('Flex creates RenderFlex', () {
      const flex = Flex(direction: Axis.horizontal, children: [Text('a')]);
      final renderObject = flex.createRenderObject(_MockBuildContext());
      expect(renderObject, isA<RenderFlex>());
    });
  });

  group('RenderFlex', () {
    test('RenderFlex has direction', () {
      final renderFlex = RenderFlex(direction: Axis.horizontal);
      expect(renderFlex.direction, equals(Axis.horizontal));
    });

    test('RenderFlex has mainAxisAlignment default', () {
      final renderFlex = RenderFlex(direction: Axis.horizontal);
      expect(renderFlex.mainAxisAlignment, equals(MainAxisAlignment.start));
    });

    test('RenderFlex has crossAxisAlignment default', () {
      final renderFlex = RenderFlex(direction: Axis.horizontal);
      expect(renderFlex.crossAxisAlignment, equals(CrossAxisAlignment.center));
    });

    test('RenderFlex can update properties', () {
      final renderFlex = RenderFlex(direction: Axis.horizontal);
      renderFlex.direction = Axis.vertical;
      renderFlex.mainAxisAlignment = MainAxisAlignment.end;
      renderFlex.crossAxisAlignment = CrossAxisAlignment.stretch;

      expect(renderFlex.direction, equals(Axis.vertical));
      expect(renderFlex.mainAxisAlignment, equals(MainAxisAlignment.end));
      expect(renderFlex.crossAxisAlignment, equals(CrossAxisAlignment.stretch));
    });
  });

  group('Row widget', () {
    test('Row creates horizontal Flex', () {
      const row = Row(children: [Text('a'), Text('b')]);
      expect(row.direction, equals(Axis.horizontal));
    });

    test('Row creates with mainAxisAlignment', () {
      const row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [Text('a')],
      );
      expect(row.mainAxisAlignment, equals(MainAxisAlignment.spaceAround));
    });

    test('Row creates with crossAxisAlignment', () {
      const row = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [Text('a')],
      );
      expect(row.crossAxisAlignment, equals(CrossAxisAlignment.end));
    });
  });

  group('Column widget', () {
    test('Column creates vertical Flex', () {
      const column = Column(children: [Text('a'), Text('b')]);
      expect(column.direction, equals(Axis.vertical));
    });

    test('Column creates with mainAxisAlignment', () {
      const column = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('a')],
      );
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.spaceBetween));
    });

    test('Column creates with crossAxisAlignment', () {
      const column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('a')],
      );
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });
  });

  group('Expanded widget', () {
    test('Expanded creates with flex', () {
      const expanded = Expanded(flex: 2, child: Text('a'));
      expect(expanded.flex, equals(2));
    });

    test('Expanded has default flex of 1', () {
      const expanded = Expanded(child: Text('a'));
      expect(expanded.flex, equals(1));
    });

    test('Expanded has child', () {
      const expanded = Expanded(child: Text('a'));
      expect(expanded.child, isA<Text>());
    });

    test('Expanded applies FlexParentData', () {
      const expanded = Expanded(child: Text('a'));
      final renderObject = _MockRenderBox();
      renderObject.parentData = FlexParentData();
      expanded.applyParentData(renderObject);
      expect(renderObject.parentData, isA<FlexParentData>());
      expect((renderObject.parentData as FlexParentData).flex, equals(1));
      expect(
        (renderObject.parentData as FlexParentData).fit,
        equals(FlexFit.tight),
      );
    });
  });

  group('Flexible widget properties', () {
    test('Flexible has flex property via Expanded', () {
      const expanded = Expanded(flex: 3, child: Text('a'));
      expect(expanded.flex, equals(3));
    });

    test('Expanded has tight fit', () {
      const expanded = Expanded(child: Text('a'));
      expect(expanded.fit, equals(FlexFit.tight));
    });
  });

  group('FlexParentData', () {
    test('FlexParentData has default values', () {
      final data = FlexParentData();
      expect(data.flex, equals(0));
      expect(data.fit, equals(FlexFit.loose));
      expect(data.offset, equals(Offset.zero));
    });

    test('FlexParentData can be modified', () {
      final data = FlexParentData();
      data.flex = 2;
      data.fit = FlexFit.tight;
      data.offset = const Offset(10, 20);

      expect(data.flex, equals(2));
      expect(data.fit, equals(FlexFit.tight));
      expect(data.offset, equals(const Offset(10, 20)));
    });
  });

  group('MainAxisAlignment', () {
    test('MainAxisAlignment has all values', () {
      expect(MainAxisAlignment.values.length, equals(6));
      expect(MainAxisAlignment.values, contains(MainAxisAlignment.start));
      expect(MainAxisAlignment.values, contains(MainAxisAlignment.end));
      expect(MainAxisAlignment.values, contains(MainAxisAlignment.center));
      expect(
        MainAxisAlignment.values,
        contains(MainAxisAlignment.spaceBetween),
      );
      expect(MainAxisAlignment.values, contains(MainAxisAlignment.spaceAround));
      expect(MainAxisAlignment.values, contains(MainAxisAlignment.spaceEvenly));
    });
  });

  group('CrossAxisAlignment', () {
    test('CrossAxisAlignment has all values', () {
      expect(CrossAxisAlignment.values.length, equals(4));
      expect(CrossAxisAlignment.values, contains(CrossAxisAlignment.start));
      expect(CrossAxisAlignment.values, contains(CrossAxisAlignment.end));
      expect(CrossAxisAlignment.values, contains(CrossAxisAlignment.center));
      expect(CrossAxisAlignment.values, contains(CrossAxisAlignment.stretch));
    });
  });

  group('MainAxisSize', () {
    test('MainAxisSize has values', () {
      expect(MainAxisSize.values.length, equals(2));
      expect(MainAxisSize.values, contains(MainAxisSize.min));
      expect(MainAxisSize.values, contains(MainAxisSize.max));
    });
  });

  group('FlexFit', () {
    test('FlexFit has values', () {
      expect(FlexFit.values.length, equals(2));
      expect(FlexFit.values, contains(FlexFit.tight));
      expect(FlexFit.values, contains(FlexFit.loose));
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
