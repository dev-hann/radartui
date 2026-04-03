import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Builder', () {
    test('Builder stores builder callback', () {
      WidgetBuilder? captured;
      const builder = Builder(builder: _captureBuilder);
      captured = builder.builder;
      expect(captured, isNotNull);
    });

    test('Builder build invokes callback with context', () {
      BuildContext? capturedContext;
      final builder = Builder(
        builder: (BuildContext context) {
          capturedContext = context;
          return const Text('result');
        },
      );
      final result = builder.build(_MockBuildContext());
      expect(result, isA<Text>());
      expect(capturedContext, isNotNull);
    });

    test('Builder build returns widget from callback', () {
      const builder = Builder(builder: _returnContainer);
      final result = builder.build(_MockBuildContext());
      expect(result, isA<Container>());
    });

    test('Builder is a StatelessWidget', () {
      const builder = Builder(builder: _returnText);
      expect(builder, isA<StatelessWidget>());
    });
  });
}

Widget _captureBuilder(BuildContext context) => const Text('captured');

Widget _returnContainer(BuildContext context) => const Container();

Widget _returnText(BuildContext context) => const Text('text');

class _MockBuildContext implements BuildContext {
  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() => null;

  @override
  InheritedElement?
  findAncestorElementOfExactType<T extends InheritedWidget>() => null;
}
