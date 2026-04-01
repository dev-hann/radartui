import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('ShortcutsExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertContains('Shortcuts & Actions Demo');
      tester.assertContains('Press a shortcut key');
    });

    testWidgets('renders shortcut list', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertContains('Available Shortcuts');
      tester.assertContains('Ctrl+S');
      tester.assertContains('Ctrl+C');
      tester.assertContains('Alt+P');
      tester.assertContains('ESC');
      tester.assertContains('F1');
    });

    testWidgets('renders counters', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertContains('Saves: 0');
      tester.assertContains('Copies: 0');
      tester.assertContains('Pastes: 0');
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      expect(find.byType<ShortcutsExample>().exists, isTrue);
    });
  });
}
