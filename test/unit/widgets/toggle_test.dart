import 'package:radartui/radartui.dart';
import 'package:test/test.dart';

void main() {
  group('Toggle', () {
    group('constructor', () {
      test('creates with required value true', () {
        const toggle = Toggle(value: true);
        expect(toggle.value, isTrue);
      });

      test('creates with required value false', () {
        const toggle = Toggle(value: false);
        expect(toggle.value, isFalse);
      });

      test('creates with onChanged callback', () {
        bool? changedValue;
        final toggle = Toggle(
          value: false,
          onChanged: (value) {
            changedValue = value;
          },
        );
        expect(toggle.onChanged, isNotNull);
        toggle.onChanged!(true);
        expect(changedValue, isTrue);
      });

      test('creates with custom colors', () {
        const toggle = Toggle(
          value: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        expect(toggle.activeColor, equals(Color.green));
        expect(toggle.inactiveColor, equals(Color.brightBlack));
      });

      test('creates with label', () {
        const toggle = Toggle(value: true, label: 'Dark Mode');
        expect(toggle.label, equals('Dark Mode'));
      });

      test('creates with null label', () {
        const toggle = Toggle(value: true);
        expect(toggle.label, isNull);
      });

      test('creates with custom focusNode', () {
        final focusNode = FocusNode();
        final toggle = Toggle(value: false, focusNode: focusNode);
        expect(toggle.focusNode, equals(focusNode));
        focusNode.dispose();
      });
    });

    group('RenderToggle', () {
      test('has size 3x1 without label', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        renderToggle.layout(const BoxConstraints());
        expect(renderToggle.size!.width, equals(3));
        expect(renderToggle.size!.height, equals(1));
      });

      test('has correct size with label', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
          label: 'Test',
        );
        renderToggle.layout(const BoxConstraints());
        expect(renderToggle.size!.width, equals(8)); // 3 + 1 + 4
        expect(renderToggle.size!.height, equals(1));
      });

      test('on state renders correctly', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        expect(renderToggle.value, isTrue);
        expect(renderToggle.enabled, isTrue);
      });

      test('off state renders correctly', () {
        final renderToggle = RenderToggle(
          value: false,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        expect(renderToggle.value, isFalse);
        expect(renderToggle.enabled, isTrue);
      });

      test('focused state', () {
        final renderToggle = RenderToggle(
          value: false,
          focused: true,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        expect(renderToggle.focused, isTrue);
      });

      test('disabled state', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: false,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        expect(renderToggle.enabled, isFalse);
        expect(renderToggle.value, isTrue);
      });

      test('responds to value change via markNeedsLayout', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
        );
        renderToggle.layout(const BoxConstraints());
        expect(renderToggle.size!.width, equals(3));

        renderToggle.value = false;
        renderToggle.markNeedsLayout();
        expect(renderToggle.value, isFalse);
      });

      test('with empty label has same size as no label', () {
        final renderToggle = RenderToggle(
          value: true,
          focused: false,
          enabled: true,
          activeColor: Color.green,
          inactiveColor: Color.brightBlack,
          label: '',
        );
        renderToggle.layout(const BoxConstraints());
        expect(renderToggle.size!.width, equals(3));
      });
    });
  });
}
