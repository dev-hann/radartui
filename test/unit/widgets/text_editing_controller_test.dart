import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('TextEditingController', () {
    group('constructor', () {
      test('creates with empty text', () {
        final controller = TextEditingController();
        expect(controller.text, equals(''));
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });
    });

    group('text setter', () {
      test('sets text and clamps cursor position', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        expect(controller.text, equals('hello'));
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });

      test('clamps cursor to new text length', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 5;
        controller.text = 'hi';
        expect(controller.cursorPosition, equals(2));
        controller.dispose();
      });
    });

    group('cursorPosition setter', () {
      test('sets cursor position', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 3;
        expect(controller.cursorPosition, equals(3));
        controller.dispose();
      });

      test('clamps cursor position to valid range', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 100;
        expect(controller.cursorPosition, equals(5));
        controller.cursorPosition = -5;
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });
    });

    group('insertText', () {
      test('inserts text at cursor position', () {
        final controller = TextEditingController();
        controller.text = 'helloworld';
        controller.cursorPosition = 5;
        controller.insertText(' ');
        expect(controller.text, equals('hello world'));
        expect(controller.cursorPosition, equals(6));
        controller.dispose();
      });

      test('inserts at beginning', () {
        final controller = TextEditingController();
        controller.text = 'world';
        controller.cursorPosition = 0;
        controller.insertText('hello ');
        expect(controller.text, equals('hello world'));
        expect(controller.cursorPosition, equals(6));
        controller.dispose();
      });

      test('inserts at end', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 5;
        controller.insertText(' world');
        expect(controller.text, equals('hello world'));
        expect(controller.cursorPosition, equals(11));
        controller.dispose();
      });
    });

    group('deleteBackward', () {
      test('deletes character before cursor', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 3;
        controller.deleteBackward();
        expect(controller.text, equals('helo'));
        expect(controller.cursorPosition, equals(2));
        controller.dispose();
      });

      test('does nothing at start', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 0;
        controller.deleteBackward();
        expect(controller.text, equals('hello'));
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });
    });

    group('deleteForward', () {
      test('deletes character at cursor', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 2;
        controller.deleteForward();
        expect(controller.text, equals('helo'));
        expect(controller.cursorPosition, equals(2));
        controller.dispose();
      });

      test('does nothing at end', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 5;
        controller.deleteForward();
        expect(controller.text, equals('hello'));
        expect(controller.cursorPosition, equals(5));
        controller.dispose();
      });
    });

    group('cursor movement', () {
      test('moveCursorLeft decreases position', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 3;
        controller.moveCursorLeft();
        expect(controller.cursorPosition, equals(2));
        controller.dispose();
      });

      test('moveCursorRight increases position', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 2;
        controller.moveCursorRight();
        expect(controller.cursorPosition, equals(3));
        controller.dispose();
      });

      test('moveCursorToStart sets position to 0', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 3;
        controller.moveCursorToStart();
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });

      test('moveCursorToEnd sets position to text length', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 0;
        controller.moveCursorToEnd();
        expect(controller.cursorPosition, equals(5));
        controller.dispose();
      });
    });

    group('clear', () {
      test('clears text and resets cursor', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        controller.cursorPosition = 3;
        controller.clear();
        expect(controller.text, equals(''));
        expect(controller.cursorPosition, equals(0));
        controller.dispose();
      });
    });

    group('ChangeNotifier', () {
      test('notifies listeners on text change', () {
        final controller = TextEditingController();
        var notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.text = 'hello';
        expect(notified, isTrue);
        controller.dispose();
      });

      test('notifies listeners on cursor change', () {
        final controller = TextEditingController();
        controller.text = 'hello';
        var notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.cursorPosition = 3;
        expect(notified, isTrue);
        controller.dispose();
      });

      test('removeListener stops notifications', () {
        final controller = TextEditingController();
        var count = 0;
        void listener() => count++;
        controller.addListener(listener);
        controller.text = 'a';
        expect(count, equals(1));
        controller.removeListener(listener);
        controller.text = 'b';
        expect(count, equals(1));
        controller.dispose();
      });

      test('hasListeners returns correct value', () {
        final controller = TextEditingController();
        expect(controller.hasListeners, isFalse);
        controller.addListener(() {});
        expect(controller.hasListeners, isTrue);
        controller.dispose();
      });
    });
  });
}
