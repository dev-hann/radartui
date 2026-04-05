import 'dart:async';
import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Toast', () {
    testWidgets('Toast appears when shown', (tester) async {
      late BuildContext descendantContext;

      tester.pumpWidget(
        Overlay(
          child: Builder(
            builder: (context) {
              descendantContext = context;
              return const Text('background');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      Toast.show(descendantContext, message: 'Hello Toast');
      await tester.pumpAndSettle();

      tester.assertBufferLines([
        'background',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '                                   Hello Toast',
      ]);
    });

    testWidgets('Toast auto-removes after duration', (tester) async {
      late BuildContext descendantContext;

      tester.pumpWidget(
        Overlay(
          child: Builder(
            builder: (context) {
              descendantContext = context;
              return const Text('background');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      Toast.show(
        descendantContext,
        message: 'Bye Toast',
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();

      expect(tester.contains('Bye Toast'), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(tester.contains('Bye Toast'), isFalse);
    });

    testWidgets('Toast does nothing without Overlay ancestor', (tester) async {
      late BuildContext descendantContext;

      tester.pumpWidget(
        Builder(
          builder: (context) {
            descendantContext = context;
            return const Text('no overlay');
          },
        ),
      );
      await tester.pumpAndSettle();

      Toast.show(descendantContext, message: 'Should not appear');
      await tester.pumpAndSettle();

      expect(tester.contains('Should not appear'), isFalse);
    });
  });
}
