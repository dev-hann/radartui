import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('TextFieldExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                 Single-line input:',
        '                                █nter text here...',
        '',
        '',
        '                           Multiline input (maxLines: 3):',
        '',
        '',
        '                                            ⌨️ TextField Widget Example',
        '                                      Input:',
        '                                    Multiline:',
        '',
        '',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('renders initial text', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                 Single-line input:',
        '                                █nter text here...',
        '',
        '',
        '                           Multiline input (maxLines: 3):',
        '',
        '',
        '                                            ⌨️ TextField Widget Example',
        '                                      Input:',
        '                                    Multiline:',
        '',
        '',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('renders controls help text', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                 Single-line input:',
        '                                █nter text here...',
        '',
        '',
        '                           Multiline input (maxLines: 3):',
        '',
        '',
        '                                            ⌨️ TextField Widget Example',
        '                                      Input:',
        '                                    Multiline:',
        '',
        '',
        '                          Press ESC to return to main menu',
        '',
        '',
        '',
        '',
      ]);
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const TextFieldExample());
      await tester.pumpAndSettle();

      expect(find.byType<TextFieldExample>().exists, isTrue);
    });
  });
}
