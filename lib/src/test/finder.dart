import '../widgets.dart';
import 'test_binding.dart';

abstract class Finder {
  const Finder();

  List<Element> evaluateAll();

  Element? evaluate() {
    final all = evaluateAll();
    return all.isNotEmpty ? all.first : null;
  }

  bool get exists => evaluateAll().isNotEmpty;

  bool get evaluatesToSingleWidget => evaluateAll().length == 1;

  Finder byType<T extends Widget>() => TypeFinder<T>();

  Finder text(String text) => TextFinder(text);

  Finder byKey(Key key) => KeyFinder(key);
}

class TypeFinder<T extends Widget> extends Finder {
  const TypeFinder();

  @override
  List<Element> evaluateAll() {
    final result = <Element>[];
    final root = TestBinding.instance.rootElement;

    if (root == null) return result;

    void visit(Element element) {
      if (element.widget is T) {
        result.add(element);
      }
      element.visitChildren(visit);
    }

    visit(root);
    return result;
  }
}

class TextFinder extends Finder {
  final String targetText;

  const TextFinder(this.targetText);

  @override
  List<Element> evaluateAll() {
    final result = <Element>[];
    final root = TestBinding.instance.rootElement;

    if (root == null) return result;

    void visit(Element element) {
      final widget = element.widget;
      if (widget is Text && widget.data == targetText) {
        result.add(element);
      }
      element.visitChildren(visit);
    }

    visit(root);
    return result;
  }
}

class KeyFinder extends Finder {
  final Key key;

  const KeyFinder(this.key);

  @override
  List<Element> evaluateAll() {
    final result = <Element>[];
    final root = TestBinding.instance.rootElement;

    if (root == null) return result;

    void visit(Element element) {
      if (element.widget.key == key) {
        result.add(element);
      }
      element.visitChildren(visit);
    }

    visit(root);
    return result;
  }
}

Finder find = const _EmptyFinder();

class _EmptyFinder extends Finder {
  const _EmptyFinder();

  @override
  List<Element> evaluateAll() => [];
}

Finder findByType<T extends Widget>() => TypeFinder<T>();

Finder findText(String text) => TextFinder(text);

Finder findByKey(Key key) => KeyFinder(key);
