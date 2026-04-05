import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('ShortcutsExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                 Available shortcuts:',
        '',
        '                    Ctrl+S  - Save',
        '                    Alt+C   - Copy',
        '                   Delete  - Delete',
        '',
        '',
        '                                                  Example',
        '     No shortcut triggered yet',
        '',
        '',
        '',
        '           Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('renders shortcut list', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                 Available shortcuts:',
        '',
        '                    Ctrl+S  - Save',
        '                    Alt+C   - Copy',
        '                   Delete  - Delete',
        '',
        '',
        '                                                  Example',
        '     No shortcut triggered yet',
        '',
        '',
        '',
        '           Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('renders counters', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                 Available shortcuts:',
        '',
        '                    Ctrl+S  - Save',
        '                    Alt+C   - Copy',
        '                   Delete  - Delete',
        '',
        '',
        '                                                  Example',
        '     No shortcut triggered yet',
        '',
        '',
        '',
        '           Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const ShortcutsExample());
      await tester.pumpAndSettle();

      expect(find.byType<ShortcutsExample>().exists, isTrue);
    });
  });
}
