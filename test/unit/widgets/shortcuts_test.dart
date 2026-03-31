import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

class _TestIntent extends Intent {
  const _TestIntent();
}

class _TestAction extends Action<_TestIntent> {
  const _TestAction();

  @override
  Object? invoke(_TestIntent intent) => null;
}

class _CustomIntent extends Intent {
  const _CustomIntent(this.value);
  final String value;
}

void main() {
  group('ShortcutActivator', () {
    group('accepts()', () {
      test('matches key code only when no modifiers specified', () {
        const activator = ShortcutActivator(key: KeyCode.enter);

        expect(
          activator.accepts(const KeyEvent(code: KeyCode.enter)),
          isTrue,
        );
        expect(
          activator.accepts(const KeyEvent(code: KeyCode.escape)),
          isFalse,
        );
      });

      test('matches with ctrl modifier', () {
        const activator = ShortcutActivator(
          key: KeyCode.char,
          ctrl: true,
        );

        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 's',
            isCtrlPressed: true,
          )),
          isTrue,
        );
        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 's',
            isCtrlPressed: false,
          )),
          isFalse,
        );
      });

      test('matches with alt modifier', () {
        const activator = ShortcutActivator(
          key: KeyCode.char,
          alt: true,
        );

        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 'a',
            isAltPressed: true,
          )),
          isTrue,
        );
        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 'a',
            isAltPressed: false,
          )),
          isFalse,
        );
      });

      test('matches with shift modifier', () {
        const activator = ShortcutActivator(
          key: KeyCode.arrowUp,
          shift: true,
        );

        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.arrowUp,
            isShiftPressed: true,
          )),
          isTrue,
        );
        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.arrowUp,
            isShiftPressed: false,
          )),
          isFalse,
        );
      });

      test('matches with multiple modifiers', () {
        const activator = ShortcutActivator(
          key: KeyCode.char,
          ctrl: true,
          shift: true,
        );

        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 's',
            isCtrlPressed: true,
            isShiftPressed: true,
          )),
          isTrue,
        );
        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.char,
            char: 's',
            isCtrlPressed: true,
            isShiftPressed: false,
          )),
          isFalse,
        );
      });

      test('requires exact modifier match', () {
        const activator = ShortcutActivator(
          key: KeyCode.enter,
          ctrl: true,
        );

        expect(
          activator.accepts(const KeyEvent(
            code: KeyCode.enter,
            isCtrlPressed: true,
            isAltPressed: true,
          )),
          isTrue,
        );
      });
    });

    group('equality', () {
      test('equal activators have same hashCode', () {
        const a1 = ShortcutActivator(key: KeyCode.enter, ctrl: true);
        const a2 = ShortcutActivator(key: KeyCode.enter, ctrl: true);

        expect(a1, equals(a2));
        expect(a1.hashCode, equals(a2.hashCode));
      });

      test('different activators are not equal', () {
        const a1 = ShortcutActivator(key: KeyCode.enter);
        const a2 = ShortcutActivator(key: KeyCode.escape);

        expect(a1, isNot(equals(a2)));
      });
    });
  });

  group('Intent', () {
    test('can be extended', () {
      const intent = _TestIntent();
      expect(intent, isA<Intent>());
    });
  });

  group('Action', () {
    test('invoke returns null by default', () {
      const action = _TestAction();
      expect(action.invoke(const _TestIntent()), isNull);
    });
  });

  group('CallbackAction', () {
    test('invokes callback', () {
      var called = false;
      final action = CallbackAction(
        onInvoke: (intent) {
          called = true;
          return 'result';
        },
      );

      final result = action.invoke(const Intent());

      expect(called, isTrue);
      expect(result, equals('result'));
    });

    test('receives intent in callback', () {
      String? receivedValue;
      final action = CallbackAction(
        onInvoke: (intent) {
          if (intent is _CustomIntent) {
            receivedValue = intent.value;
          }
          return null;
        },
      );

      action.invoke(const _CustomIntent('test'));

      expect(receivedValue, equals('test'));
    });
  });

  group('ActionDispatcher', () {
    test('invokes action with intent', () {
      const dispatcher = ActionDispatcher();
      var invoked = false;

      final action = CallbackAction(
        onInvoke: (intent) {
          invoked = true;
          return 42;
        },
      );

      final result = dispatcher.invokeAction(action, const Intent());

      expect(invoked, isTrue);
      expect(result, equals(42));
    });
  });
}
