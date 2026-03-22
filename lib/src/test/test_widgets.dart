import 'package:test/test.dart';
import 'test_binding.dart';
import 'widget_tester.dart';

void testWidgets(
  String description,
  Future<void> Function(WidgetTester tester) callback,
) {
  test(description, () async {
    TestBinding.ensureInitialized();

    final tester = WidgetTester();

    try {
      await callback(tester);
    } finally {
      tester.unmount();
    }
  });
}
