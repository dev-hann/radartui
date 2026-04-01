import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('FocusExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Focus Example');
      tester.assertContains('Actions:');
      tester.assertContains('Files:');
      tester.assertContains('Options:');
    });

    testWidgets('renders list items', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Create');
      tester.assertContains('Edit');
      tester.assertContains('Delete');
      tester.assertContains('main.dart');
    });

    testWidgets('renders selection info', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      tester.assertContains('Current Selection');
      tester.assertContains('Action:');
      tester.assertContains('File:');
      tester.assertContains('Option:');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const FocusExample());
      await tester.pumpAndSettle();

      expect(find.byType<FocusExample>().exists, isTrue);
    });
  });
}
