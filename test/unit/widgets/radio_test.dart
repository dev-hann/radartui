import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Radio', () {
    group('constructor', () {
      test('creates with required value and groupValue', () {
        const radio = Radio<int>(value: 1, groupValue: 1);
        expect(radio.value, equals(1));
        expect(radio.groupValue, equals(1));
      });

      test('creates with null groupValue', () {
        const radio = Radio<int>(value: 1, groupValue: null);
        expect(radio.value, equals(1));
        expect(radio.groupValue, isNull);
      });

      test('creates with onChanged callback', () {
        int? changedValue;
        final radio = Radio<int>(
          value: 1,
          groupValue: null,
          onChanged: (value) {
            changedValue = value;
          },
        );
        expect(radio.onChanged, isNotNull);
        radio.onChanged!(2);
        expect(changedValue, equals(2));
      });

      test('creates with custom colors', () {
        const radio = Radio<int>(
          value: 1,
          groupValue: 1,
          activeColor: Color.red,
          checkColor: Color.yellow,
        );
        expect(radio.activeColor, equals(Color.red));
        expect(radio.checkColor, equals(Color.yellow));
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final radio = Radio<int>(value: 1, groupValue: 1, focusNode: focusNode);
        expect(radio.focusNode, equals(focusNode));
        focusNode.dispose();
      });

      test('supports String type', () {
        const radio = Radio<String>(value: 'a', groupValue: 'b');
        expect(radio.value, equals('a'));
        expect(radio.groupValue, equals('b'));
      });
    });

    group('selection state', () {
      test('is selected when value equals groupValue', () {
        const radio = Radio<int>(value: 1, groupValue: 1);
        expect(radio.value == radio.groupValue, isTrue);
      });

      test('is not selected when value differs from groupValue', () {
        const radio = Radio<int>(value: 1, groupValue: 2);
        expect(radio.value == radio.groupValue, isFalse);
      });

      test('is not selected when groupValue is null', () {
        const radio = Radio<int>(value: 1, groupValue: null);
        expect(radio.value == radio.groupValue, isFalse);
      });
    });

    group('RenderRadio', () {
      test('has fixed size of 3x1', () {
        final renderRadio = RenderRadio(
          selected: true,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
          onTap: null,
        );
        renderRadio.layout(const BoxConstraints());
        expect(renderRadio.size!.width, equals(3));
        expect(renderRadio.size!.height, equals(1));
      });

      test('disabled state', () {
        final renderRadio = RenderRadio(
          selected: true,
          focused: false,
          enabled: false,
          activeColor: Color.blue,
          checkColor: Color.white,
          onTap: null,
        );
        expect(renderRadio.enabled, isFalse);
        expect(renderRadio.selected, isTrue);
      });

      test('unselected state', () {
        final renderRadio = RenderRadio(
          selected: false,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
          onTap: null,
        );
        expect(renderRadio.selected, isFalse);
      });

      test('selected state', () {
        final renderRadio = RenderRadio(
          selected: true,
          focused: false,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
          onTap: null,
        );
        expect(renderRadio.selected, isTrue);
      });

      test('focused state', () {
        final renderRadio = RenderRadio(
          selected: false,
          focused: true,
          enabled: true,
          activeColor: Color.blue,
          checkColor: Color.white,
          onTap: null,
        );
        expect(renderRadio.focused, isTrue);
      });
    });
  });
}
