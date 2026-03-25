import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Widget', () {
    test('Widget has optional key', () {
      const widget = _TestStatelessWidget();
      expect(widget.key, isNull);
    });

    test('Widget can have key', () {
      const key = ValueKey<String>('test');
      const widget = _TestStatelessWidget(key: key);
      expect(widget.key, equals(key));
    });
  });

  group('StatelessWidget', () {
    test('StatelessWidget creates StatelessElement', () {
      const widget = _TestStatelessWidget();
      final element = widget.createElement();
      expect(element, isA<StatelessElement>());
    });

    test('StatelessElement build returns widget build result', () {
      const widget = _TestStatelessWidget();
      final element = widget.createElement();
      final built = element.build();
      expect(built, isA<Text>());
    });
  });

  group('StatefulWidget', () {
    test('StatefulWidget creates StatefulElement', () {
      const widget = _TestStatefulWidget();
      final element = widget.createElement();
      expect(element, isA<StatefulElement>());
    });

    test('State is created in element constructor', () {
      const widget = _TestStatefulWidget();
      final element = widget.createElement();
      expect(element.widget, equals(widget));
    });
  });

  group('Element', () {
    test('Element dirty defaults to true', () {
      final element = const _TestStatelessWidget().createElement();
      expect(element.dirty, isTrue);
    });
  });

  group('GlobalKey', () {
    test('GlobalKey registers element on mount', () {
      final key = GlobalKey();
      final widget = _TestStatefulWidget(key: key);
      final element = widget.createElement();
      
      element.mount(null);
      expect(key.currentElement, equals(element));
    });

    test('GlobalKey unregisters element on unmount', () {
      final key = GlobalKey();
      final widget = _TestStatefulWidget(key: key);
      final element = widget.createElement();
      
      element.mount(null);
      expect(key.currentElement, isNotNull);
      
      element.unmount();
      expect(key.currentElement, isNull);
    });

    test('GlobalKey currentWidget returns widget', () {
      final key = GlobalKey();
      final widget = _TestStatefulWidget(key: key);
      final element = widget.createElement();
      
      element.mount(null);
      expect(key.currentWidget, equals(widget));
    });
  });

  group('ValueKey', () {
    test('ValueKey equality with same value', () {
      const key1 = ValueKey<String>('test');
      const key2 = ValueKey<String>('test');
      expect(key1, equals(key2));
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('ValueKey inequality with different value', () {
      const key1 = ValueKey<String>('test1');
      const key2 = ValueKey<String>('test2');
      expect(key1, isNot(equals(key2)));
    });
  });

  group('UniqueKey', () {
    test('UniqueKey is only equal to itself', () {
      const key1 = UniqueKey();
      const key2 = UniqueKey();
      expect(key1, equals(key1));
      expect(key1, isNot(equals(key2)));
    });

    test('UniqueKey has unique hashCodes', () {
      const key1 = UniqueKey();
      const key2 = UniqueKey();
      expect(key1.hashCode, isNot(equals(key2.hashCode)));
    });
  });

  group('Widget.canUpdate', () {
    test('canUpdate returns true for same type without key', () {
      const w1 = _TestStatelessWidget();
      const w2 = _TestStatelessWidget();
      expect(Widget.canUpdate(w1, w2), isTrue);
    });

    test('canUpdate returns true for same type with same key', () {
      const key = ValueKey<String>('key');
      const w1 = _TestStatelessWidget(key: key);
      const w2 = _TestStatelessWidget(key: key);
      expect(Widget.canUpdate(w1, w2), isTrue);
    });

    test('canUpdate returns false for same type with different key', () {
      const key1 = ValueKey<String>('key1');
      const key2 = ValueKey<String>('key2');
      const w1 = _TestStatelessWidget(key: key1);
      const w2 = _TestStatelessWidget(key: key2);
      expect(Widget.canUpdate(w1, w2), isFalse);
    });

    test('canUpdate returns false for different types', () {
      const w1 = _TestStatelessWidget();
      const w2 = _TestStatefulWidget();
      expect(Widget.canUpdate(w1, w2), isFalse);
    });
  });

  group('InheritedElement', () {
    test('InheritedElement tracks dependents', () {
      const inherited = _TestInheritedWidget(value: 42, child: Text('test'));
      final element = inherited.createElement();
      expect(element, isA<InheritedElement>());
    });

    test('InheritedWidget updateShouldNotify works correctly', () {
      const oldWidget = _TestInheritedWidget(value: 1, child: Text('a'));
      const newWidget = _TestInheritedWidget(value: 2, child: Text('b'));
      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
      
      const sameWidget = _TestInheritedWidget(value: 1, child: Text('b'));
      expect(sameWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });

  group('ParentDataWidget', () {
    test('ParentDataWidget has child', () {
      const positioned = Positioned(left: 10, child: Text('test'));
      expect(positioned.child, isA<Text>());
    });

    test('ParentDataWidget creates ParentDataElement', () {
      const positioned = Positioned(left: 10, child: Text('test'));
      final element = positioned.createElement();
      expect(element, isA<ParentDataElement>());
    });
  });
}

class _TestStatelessWidget extends StatelessWidget {
  const _TestStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) => const Text('test');
}

class _TestStatefulWidget extends StatefulWidget {
  const _TestStatefulWidget({super.key});

  @override
  State<_TestStatefulWidget> createState() => _TestStatefulWidgetState();
}

class _TestStatefulWidgetState extends State<_TestStatefulWidget> {
  @override
  Widget build(BuildContext context) => const Text('stateful');
}

class _TestInheritedWidget extends InheritedWidget {

  const _TestInheritedWidget({
    required this.value,
    required super.child,
  });
  final int value;

  @override
  bool updateShouldNotify(_TestInheritedWidget oldWidget) => value != oldWidget.value;
}
