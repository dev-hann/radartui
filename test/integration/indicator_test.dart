import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('ProgressIndicator rendering', () {
    testWidgets('ProgressIndicator renders 0%', (tester) async {
      tester.pumpWidget(
        const ProgressIndicator(progress: 0),
      );

      await tester.pumpAndSettle();

      tester.assertContains('[');
      tester.assertContains(']');
      tester.assertContains('0%');
    });

    testWidgets('ProgressIndicator renders 50%', (tester) async {
      tester.pumpWidget(
        const ProgressIndicator(progress: 50),
      );

      await tester.pumpAndSettle();

      tester.assertContains('[');
      tester.assertContains(']');
      tester.assertContains('50%');
    });

    testWidgets('ProgressIndicator renders 100%', (tester) async {
      tester.pumpWidget(
        const ProgressIndicator(progress: 100),
      );

      await tester.pumpAndSettle();

      tester.assertContains('100%');
    });

    testWidgets('ProgressIndicator without percentage', (tester) async {
      tester.pumpWidget(
        const ProgressIndicator(
          progress: 50,
          showPercentage: false,
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('[');
      tester.assertContains(']');
    });
  });

  group('LoadingIndicator rendering', () {
    testWidgets('LoadingIndicator renders spinner', (tester) async {
      tester.pumpWidget(
        const LoadingIndicator(),
      );

      await tester.pumpAndSettle();

      // Spinner uses characters: | / - \
      final buffer = tester.getPlainText();
      final hasSpinner = buffer.contains('|') ||
          buffer.contains('/') ||
          buffer.contains('-') ||
          buffer.contains('\\');
      expect(hasSpinner, isTrue,
          reason: 'Spinner should show one of: | / - \\');
    });

    testWidgets('LoadingIndicator with dots type', (tester) async {
      tester.pumpWidget(
        const LoadingIndicator(type: IndicatorType.dots),
      );

      await tester.pumpAndSettle();

      // Dots indicator uses braille patterns
      expect(find.byType<LoadingIndicator>().exists, isTrue);
    });

    testWidgets('LoadingIndicator with pulse type', (tester) async {
      tester.pumpWidget(
        const LoadingIndicator(type: IndicatorType.pulse),
      );

      await tester.pumpAndSettle();

      // Pulse uses ● or ○
      final buffer = tester.getPlainText();
      final hasPulse = buffer.contains('●') || buffer.contains('○');
      expect(hasPulse, isTrue, reason: 'Pulse should show ● or ○');
    });
  });

  group('Indicator interaction', () {
    testWidgets('ProgressIndicator can be found by type', (tester) async {
      tester.pumpWidget(
        const ProgressIndicator(progress: 0),
      );

      expect(find.byType<ProgressIndicator>().exists, isTrue);
    });

    testWidgets('LoadingIndicator can be found by type', (tester) async {
      tester.pumpWidget(
        const LoadingIndicator(),
      );

      expect(find.byType<LoadingIndicator>().exists, isTrue);
    });
  });
}
