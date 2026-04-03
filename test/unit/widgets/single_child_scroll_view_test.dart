import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('SingleChildScrollView', () {
    group('constructor', () {
      test('creates with required child', () {
        const scrollView = SingleChildScrollView(child: Text('hello'));
        expect(scrollView.child, isA<Text>());
        expect(scrollView.scrollDirection, equals(Axis.vertical));
        expect(scrollView.controller, isNull);
        expect(scrollView.padding, isNull);
        expect(scrollView.focusNode, isNull);
      });

      test('creates with horizontal scroll direction', () {
        const scrollView = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text('hello'),
        );
        expect(scrollView.scrollDirection, equals(Axis.horizontal));
      });

      test('creates with padding', () {
        const scrollView = SingleChildScrollView(
          padding: EdgeInsets.all(4),
          child: Text('hello'),
        );
        expect(scrollView.padding, equals(const EdgeInsets.all(4)));
      });

      test('creates with symmetric padding', () {
        const scrollView = SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: Text('hello'),
        );
        expect(scrollView.padding!.left, equals(2));
        expect(scrollView.padding!.top, equals(3));
      });

      test('creates with custom controller', () {
        final controller = ScrollController();
        final scrollView = SingleChildScrollView(
          controller: controller,
          child: const Text('hello'),
        );
        expect(scrollView.controller, same(controller));
        controller.dispose();
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final scrollView = SingleChildScrollView(
          focusNode: focusNode,
          child: const Text('hello'),
        );
        expect(scrollView.focusNode, same(focusNode));
        focusNode.dispose();
      });

      test('creates with all parameters', () {
        final controller = ScrollController();
        final focusNode = FocusNode();
        final scrollView = SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(2),
          focusNode: focusNode,
          child: const Text('hello'),
        );
        expect(scrollView.controller, same(controller));
        expect(scrollView.scrollDirection, equals(Axis.horizontal));
        expect(scrollView.padding, equals(const EdgeInsets.all(2)));
        expect(scrollView.focusNode, same(focusNode));
        controller.dispose();
        focusNode.dispose();
      });
    });

    group('ScrollController', () {
      test('initial offset is zero', () {
        final controller = ScrollController();
        expect(controller.offset, equals(0));
        controller.dispose();
      });

      test('offset setter updates value', () {
        final controller = ScrollController();
        controller.offset = 10;
        expect(controller.offset, equals(10));
        controller.dispose();
      });

      test('offset setter does not notify when value unchanged', () {
        final controller = ScrollController();
        int notifyCount = 0;
        controller.addListener(() {
          notifyCount++;
        });
        controller.offset = 0;
        expect(notifyCount, equals(0));
        controller.dispose();
      });

      test('offset setter notifies listeners on change', () {
        final controller = ScrollController();
        int notifyCount = 0;
        controller.addListener(() {
          notifyCount++;
        });
        controller.offset = 5;
        expect(notifyCount, equals(1));
        controller.dispose();
      });

      test('animateTo updates offset', () {
        final controller = ScrollController();
        controller.animateTo(15);
        expect(controller.offset, equals(15));
        controller.dispose();
      });
    });
  });
}
