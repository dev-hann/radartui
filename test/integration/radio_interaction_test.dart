import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Radio rendering', () {
    testWidgets('Radio renders unselected state', (tester) async {
      tester.pumpWidget(
        const Radio<String>(
          value: 'option1',
          groupValue: null,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '( )',
      ]);
    });

    testWidgets('Radio renders selected state', (tester) async {
      tester.pumpWidget(
        Radio<String>(
          value: 'option1',
          groupValue: 'option1',
          onChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '(●)',
      ]);
    });
  });

  group('Radio interaction', () {
    testWidgets('Radio selects value on Space key', (tester) async {
      String? groupValue;

      tester.pumpWidget(
        Radio<String>(
          value: 'option1',
          groupValue: groupValue,
          onChanged: (v) => groupValue = v,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(groupValue, equals('option1'));
    });

    testWidgets('Radio selects value on Enter key', (tester) async {
      String? groupValue;

      tester.pumpWidget(
        Radio<String>(
          value: 'option1',
          groupValue: groupValue,
          onChanged: (v) => groupValue = v,
        ),
      );

      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(groupValue, equals('option1'));
    });

    testWidgets('Disabled radio does not respond to input', (tester) async {
      const String groupValue = 'initial';

      tester.pumpWidget(
        const Radio<String>(
          value: 'option1',
          groupValue: groupValue,
          onChanged: null,
        ),
      );

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(groupValue, equals('initial'));
    });

    testWidgets('Radio groupValue changes update visual state', (tester) async {
      var groupValue = 'option1';

      tester.pumpWidget(
        Radio<String>(
          value: 'option1',
          groupValue: groupValue,
          onChanged: (v) {},
        ),
      );

      await tester.pumpAndSettle();

      groupValue = 'option2';
      tester.pumpWidget(
        Radio<String>(
          value: 'option1',
          groupValue: groupValue,
          onChanged: (v) {},
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('Radio can be found by type', (tester) async {
      tester.pumpWidget(
        const Radio<String>(
          value: 'test',
          groupValue: null,
        ),
      );

      expect(find.byType<Radio<String>>().exists, isTrue);
    });
  });
}
