import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

class _SaveIntent extends Intent {
  const _SaveIntent();
}

class _QuitIntent extends Intent {
  const _QuitIntent();
}

class _CopyIntent extends Intent {
  const _CopyIntent();
}

class _PasteIntent extends Intent {
  const _PasteIntent();
}

void main() {
  group('Shortcuts/Actions Integration', () {
    testWidgets('Shortcut triggers action', (tester) async {
      var saved = false;

      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.char, ctrl: true):
                const _SaveIntent(),
          },
          child: Actions(
            actions: {
              _SaveIntent: CallbackAction(
                onInvoke: (intent) {
                  saved = true;
                  return null;
                },
              ),
            },
            child: const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(saved, isFalse);

      tester.sendKeyEvent(const KeyEvent(
        code: KeyCode.char,
        char: 's',
        isCtrlPressed: true,
      ));

      await tester.pumpAndSettle();

      expect(saved, isTrue);
    });

    testWidgets('Nested shortcuts bubble up', (tester) async {
      var outerCalled = false;

      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.escape): const _QuitIntent(),
          },
          child: Actions(
            actions: {
              _QuitIntent: CallbackAction(
                onInvoke: (intent) {
                  outerCalled = true;
                  return null;
                },
              ),
            },
            child: Shortcuts(
              shortcuts: {
                const ShortcutActivator(key: KeyCode.enter):
                    const _SaveIntent(),
              },
              child: const Text('Nested'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      tester.sendEscape();

      await tester.pumpAndSettle();

      expect(outerCalled, isTrue);
    });

    testWidgets('Nested actions bubble up', (tester) async {
      var innerCalled = false;
      var outerCalled = false;

      tester.pumpWidget(
        Actions(
          actions: {
            _QuitIntent: CallbackAction(
              onInvoke: (intent) {
                outerCalled = true;
                return null;
              },
            ),
          },
          child: Actions(
            actions: {
              _SaveIntent: CallbackAction(
                onInvoke: (intent) {
                  innerCalled = true;
                  return null;
                },
              ),
            },
            child: const Text('Nested Actions'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(innerCalled, isFalse);
      expect(outerCalled, isFalse);
    });

    testWidgets('Ctrl modifier works', (tester) async {
      var copied = false;

      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.char, ctrl: true):
                const _CopyIntent(),
          },
          child: Actions(
            actions: {
              _CopyIntent: CallbackAction(
                onInvoke: (intent) {
                  copied = true;
                  return null;
                },
              ),
            },
            child: const Text('Copy'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      tester.sendKeyEvent(const KeyEvent(
        code: KeyCode.char,
        char: 'c',
        isCtrlPressed: true,
      ));

      await tester.pumpAndSettle();

      expect(copied, isTrue);
    });

    testWidgets('Alt modifier works', (tester) async {
      var pasted = false;

      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.char, alt: true):
                const _PasteIntent(),
          },
          child: Actions(
            actions: {
              _PasteIntent: CallbackAction(
                onInvoke: (intent) {
                  pasted = true;
                  return null;
                },
              ),
            },
            child: const Text('Paste'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final altEvent = KeyEvent(
        code: KeyCode.char,
        char: 'p',
        isAltPressed: true,
      );

      final nonAltEvent = KeyEvent(
        code: KeyCode.char,
        char: 'p',
        isAltPressed: false,
      );

      final activator = const ShortcutActivator(key: KeyCode.char, alt: true);
      expect(activator.accepts(altEvent), isTrue);
      expect(activator.accepts(nonAltEvent), isFalse);
    });

    testWidgets('Shift modifier works', (tester) async {
      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.arrowUp, shift: true):
                const _QuitIntent(),
          },
          child: const Text('Shift'),
        ),
      );

      await tester.pumpAndSettle();

      final shiftEvent = KeyEvent(
        code: KeyCode.arrowUp,
        isShiftPressed: true,
      );

      final nonShiftEvent = KeyEvent(
        code: KeyCode.arrowUp,
        isShiftPressed: false,
      );

      final activator =
          const ShortcutActivator(key: KeyCode.arrowUp, shift: true);
      expect(activator.accepts(shiftEvent), isTrue);
      expect(activator.accepts(nonShiftEvent), isFalse);
    });

    testWidgets('Actions.of returns null when no Actions ancestor',
        (tester) async {
      tester.pumpWidget(const Text('No Actions'));

      await tester.pumpAndSettle();

      expect(Actions.of(tester.rootElement! as BuildContext), isNull);
    });

    testWidgets('Shortcuts.of returns null when no Shortcuts ancestor',
        (tester) async {
      tester.pumpWidget(const Text('No Shortcuts'));

      await tester.pumpAndSettle();

      expect(Shortcuts.of(tester.rootElement! as BuildContext), isNull);
    });

    testWidgets('Multiple shortcuts map to different intents', (tester) async {
      tester.pumpWidget(
        Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.char, ctrl: true):
                const _CopyIntent(),
            const ShortcutActivator(key: KeyCode.char, alt: true):
                const _PasteIntent(),
            const ShortcutActivator(key: KeyCode.escape): const _QuitIntent(),
          },
          child: const Text('Multiple'),
        ),
      );

      await tester.pumpAndSettle();

      final ctrlActivator =
          const ShortcutActivator(key: KeyCode.char, ctrl: true);
      final altActivator =
          const ShortcutActivator(key: KeyCode.char, alt: true);
      final escActivator = const ShortcutActivator(key: KeyCode.escape);

      expect(
          ctrlActivator.accepts(const KeyEvent(
              code: KeyCode.char, char: 'c', isCtrlPressed: true)),
          isTrue);
      expect(
          altActivator.accepts(const KeyEvent(
              code: KeyCode.char, char: 'p', isAltPressed: true)),
          isTrue);
      expect(
          escActivator.accepts(const KeyEvent(code: KeyCode.escape)), isTrue);
    });
  });
}
