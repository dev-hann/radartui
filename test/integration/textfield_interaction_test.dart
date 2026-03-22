import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('TextField interaction', () {
    testWidgets('TextField renders typed text', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('world');
      await tester.pumpAndSettle();

      expect(tester.contains('world'), isTrue);
    });

    testWidgets('TextField accepts text input', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('hello');
      await tester.pumpAndSettle();

      expect(controller.text, equals('hello'));
    });

    testWidgets('TextField handles backspace', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('hello');
      tester.sendBackspace();
      await tester.pumpAndSettle();

      expect(controller.text, equals('hell'));
    });

    testWidgets('TextField handles cursor movement', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('hello');
      tester.sendArrowLeft();
      tester.sendArrowLeft();
      tester.sendChar('X');
      await tester.pumpAndSettle();

      expect(controller.text, equals('helXlo'));
    });

    testWidgets('TextField handles Home and End keys', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('hello');
      tester.sendHome();
      tester.sendChar('X');
      await tester.pumpAndSettle();

      expect(controller.text, equals('Xhello'));

      tester.sendEnd();
      tester.sendChar('Y');
      await tester.pumpAndSettle();

      expect(controller.text, equals('XhelloY'));
    });

    testWidgets('TextField handles delete key', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      tester.typeText('hello');
      tester.sendHome();
      tester.sendArrowRight();
      tester.sendDelete();
      await tester.pumpAndSettle();

      expect(controller.text, equals('hllo'));
    });

    testWidgets('TextField calls onSubmitted on Enter', (tester) async {
      final controller = TextEditingController();
      String? submittedText;

      tester.pumpWidget(
        TextField(
          controller: controller,
          onSubmitted: (text) => submittedText = text,
        ),
      );

      tester.typeText('hello');
      tester.sendEnter();
      await tester.pumpAndSettle();

      expect(submittedText, equals('hello'));
    });

    testWidgets('TextField calls onChanged on text change', (tester) async {
      final controller = TextEditingController();
      final changes = <String>[];

      tester.pumpWidget(
        TextField(
          controller: controller,
          onChanged: (text) => changes.add(text),
        ),
      );

      tester.typeText('ab');
      await tester.pumpAndSettle();

      expect(changes, isNotEmpty);
    });

    testWidgets('TextField respects maxLength', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(
          controller: controller,
          maxLength: 5,
        ),
      );

      tester.typeText('hello world');
      await tester.pumpAndSettle();

      expect(controller.text, equals('hello'));
    });

    testWidgets('TextField can be found by type', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        TextField(controller: controller),
      );

      expect(find.byType<TextField>().exists, isTrue);
    });
  });
}
