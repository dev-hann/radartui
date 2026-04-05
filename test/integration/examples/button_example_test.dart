import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';
import '../../../example/src/exports.dart';

void main() {
  group('ButtonExample', () {
    testWidgets('renders correctly', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                   Press count: 0',
        '',
        '                                      Press Me',
        '',
        '                                      Disabled',
        '',
        '    Red      Green',
        '                                             🔘 Button Widget Example',
        '',
        '                          Press ESC to return to main menu',
      ]);
    });

    testWidgets('renders initial message and counter', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                   Press count: 0',
        '',
        '                                      Press Me',
        '',
        '                                      Disabled',
        '',
        '    Red      Green',
        '                                             🔘 Button Widget Example',
        '',
        '                          Press ESC to return to main menu',
      ]);
    });

    testWidgets('can be found by type', (tester) async {
      tester.pumpWidget(const ButtonExample());
      await tester.pumpAndSettle();

      expect(find.byType<ButtonExample>().exists, isTrue);
    });
  });
}
