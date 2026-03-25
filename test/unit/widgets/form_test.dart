import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('TextSelection', () {
    test('TextSelection creates with start and end', () {
      const selection = TextSelection(start: 0, end: 5);
      expect(selection.start, equals(0));
      expect(selection.end, equals(5));
    });

    test('TextSelection isValid', () {
      expect(const TextSelection(start: 0, end: 5).isValid, isTrue);
      expect(const TextSelection(start: -1, end: 5).isValid, isFalse);
      expect(const TextSelection(start: 5, end: 3).isValid, isFalse);
    });

    test('TextSelection length', () {
      expect(const TextSelection(start: 0, end: 5).length, equals(5));
      expect(const TextSelection(start: 3, end: 7).length, equals(4));
    });

    test('TextSelection textInRange', () {
      const selection = TextSelection(start: 0, end: 5);
      expect(selection.textInRange('Hello World'), equals('Hello'));
    });
  });

  group('Clipboard', () {
    test('Clipboard setData and getData', () async {
      await Clipboard.setData('test text');
      final data = await Clipboard.getData();
      expect(data, equals('test text'));
    });

    test('Clipboard hasData', () async {
      await Clipboard.setData('test');
      expect(Clipboard.hasData, isTrue);
    });
  });

  group('TextEditingController selection', () {
    test('hasSelection defaults to false', () {
      final controller = TextEditingController();
      expect(controller.hasSelection, isFalse);
    });

    test('setSelection sets selection', () {
      final controller = TextEditingController();
      controller.text = 'Hello';
      controller.setSelection(0, 5);
      
      expect(controller.hasSelection, isTrue);
      expect(controller.selection?.start, equals(0));
      expect(controller.selection?.end, equals(5));
    });

    test('selectAll selects all text', () {
      final controller = TextEditingController();
      controller.text = 'Hello';
      controller.selectAll();
      
      expect(controller.hasSelection, isTrue);
      expect(controller.selection?.start, equals(0));
      expect(controller.selection?.end, equals(5));
    });

    test('clearSelection clears selection', () {
      final controller = TextEditingController();
      controller.text = 'Hello';
      controller.selectAll();
      controller.clearSelection();
      
      expect(controller.hasSelection, isFalse);
    });

    test('deleteSelection removes selected text', () {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.setSelection(0, 6);
      controller.deleteSelection();
      
      expect(controller.text, equals('World'));
      expect(controller.cursorPosition, equals(0));
    });

    test('copy copies selected text to clipboard', () async {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.setSelection(0, 5);
      await controller.copy();
      
      final data = await Clipboard.getData();
      expect(data, equals('Hello'));
    });

    test('cut removes and copies selected text', () async {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.setSelection(0, 6);
      await controller.cut();
      
      expect(controller.text, equals('World'));
      final data = await Clipboard.getData();
      expect(data, equals('Hello '));
    });

    test('paste inserts clipboard text', () async {
      await Clipboard.setData('Test');
      final controller = TextEditingController();
      controller.text = 'Hello';
      controller.cursorPosition = 5;
      await controller.paste();
      
      expect(controller.text, equals('HelloTest'));
    });

    test('insertText replaces selection', () {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.setSelection(0, 6);
      controller.insertText('Hi ');
      
      expect(controller.text, equals('Hi World'));
    });

    test('moveCursorWordLeft moves to previous word', () {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.cursorPosition = 11;
      controller.moveCursorWordLeft();
      
      expect(controller.cursorPosition, equals(6));
    });

    test('moveCursorWordRight moves to next word', () {
      final controller = TextEditingController();
      controller.text = 'Hello World';
      controller.cursorPosition = 0;
      controller.moveCursorWordRight();
      
      expect(controller.cursorPosition, equals(6));
    });
  });

  group('Form widget', () {
    test('Form creates with child', () {
      const form = Form(child: Text('test'));
      expect(form.child, isA<Text>());
    });

    test('FormScope provides FormState', () {
      final formState = FormState();
      final formScope = FormScope(formState: formState, child: const Text('test'));
      expect(formScope.formState, equals(formState));
    });
  });

  group('FormField widget', () {
    test('FormField creates with initial value', () {
      final field = FormField<int>(
        initialValue: 42,
        builder: (state) => Text('${state.value}'),
      );
      expect(field.initialValue, equals(42));
    });

    test('FormField validator is called', () {
      final field = FormField<String>(
        initialValue: '',
        validator: (value) => value?.isEmpty == true ? 'Required' : null,
        builder: (state) => Text(state.value),
      );
      expect(field.validator, isNotNull);
    });
  });
}
