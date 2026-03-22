import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Checkbox', () {
    group('constructor', () {
      test('creates with required value', () {
        final checkbox = Checkbox(value: true);
        expect(checkbox.value, isTrue);
        expect(checkbox.tristate, isFalse);
      });

      test('creates with tristate enabled', () {
        final checkbox = Checkbox(value: false, tristate: true);
        expect(checkbox.tristate, isTrue);
      });

      test('creates with onChanged callback', () {
        bool? changedValue;
        final checkbox = Checkbox(
          value: false,
          onChanged: (value) {
            changedValue = value;
          },
        );
        expect(checkbox.onChanged, isNotNull);
        checkbox.onChanged!(true);
        expect(changedValue, isTrue);
      });

      test('creates with custom colors', () {
        final checkbox = Checkbox(
          value: true,
          activeColor: Color.red,
          checkColor: Color.yellow,
        );
        expect(checkbox.activeColor, equals(Color.red));
        expect(checkbox.checkColor, equals(Color.yellow));
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final checkbox = Checkbox(value: false, focusNode: focusNode);
        expect(checkbox.focusNode, equals(focusNode));
        focusNode.dispose();
      });
    });

    group('RenderCheckbox', () {
      test('has fixed size of 3x1', () {
        final renderCheckbox = RenderCheckbox(
          value: true,
          tristate: false,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
        );
        renderCheckbox.layout(const BoxConstraints());
        expect(renderCheckbox.size!.width, equals(3));
        expect(renderCheckbox.size!.height, equals(1));
      });

      test('disabled state', () {
        final renderCheckbox = RenderCheckbox(
          value: true,
          tristate: false,
          focused: false,
          enabled: false,
          activeColor: Color.blue,
          checkColor: Color.white,
        );
        expect(renderCheckbox.enabled, isFalse);
        expect(renderCheckbox.value, isTrue);
      });

      test('unchecked state', () {
        final renderCheckbox = RenderCheckbox(
          value: false,
          tristate: false,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
        );
        expect(renderCheckbox.value, isFalse);
      });

      test('checked state', () {
        final renderCheckbox = RenderCheckbox(
          value: true,
          tristate: false,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
        );
        expect(renderCheckbox.value, isTrue);
      });

      test('focused state', () {
        final renderCheckbox = RenderCheckbox(
          value: false,
          tristate: false,
          focused: true,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
        );
        expect(renderCheckbox.focused, isTrue);
      });
    });
  });
}
