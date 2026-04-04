import 'package:test/test.dart';

import 'golden_matcher.dart';
import 'pty_test_runner.dart';

void testPtyWidget(
  String name, {
  required String example,
  required String golden,
  int width = 80,
  int height = 24,
}) {
  test(name, () async {
    final goldenPath = 'test/pty/golden/$golden';
    final runner = PtyTestRunner(width: width, height: height);
    final result = await runner.runExample(example);

    if (result.exitCode != 0) {
      fail(
          'PTY process exited with code ${result.exitCode}\nOutput: ${result.rawOutput}');
    }

    expect(result.grid, matchesGoldenFile(goldenPath));
  });
}
