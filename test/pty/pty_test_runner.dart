import 'dart:async';
import 'dart:io';

import 'vt100_parser.dart';

class PtyTestResult {
  PtyTestResult({
    required this.exitCode,
    required this.rawOutput,
    required this.grid,
  });

  final int exitCode;
  final String rawOutput;
  final List<String> grid;
}

class PtyTestRunner {
  PtyTestRunner({
    this.width = 80,
    this.height = 24,
    this.timeout = const Duration(seconds: 15),
  });

  final int width;
  final int height;
  final Duration timeout;

  Future<PtyTestResult> runExample(String examplePath) async {
    final String scriptPath = _resolveExamplePath(examplePath);

    final Process process = await Process.start(
      Platform.executable,
      ['run', scriptPath, '--pty-test'],
      environment: {
        ...Platform.environment,
        'TERM': 'xterm-256color',
        'COLUMNS': '$width',
        'LINES': '$height',
      },
    );

    final StringBuffer output = StringBuffer();
    final StreamSubscription<String> sub = process.stdout
        .transform(const SystemEncoding().decoder)
        .listen(output.write);

    unawaited(process.stderr.drain());

    final int exitCode = await process.exitCode.timeout(
      timeout,
      onTimeout: () {
        process.kill();
        return -1;
      },
    );

    await sub.cancel();

    final String rawOutput = output.toString();
    final Vt100Parser parser = Vt100Parser(width: width, height: height);
    final List<String> grid = parser.parse(rawOutput);

    return PtyTestResult(exitCode: exitCode, rawOutput: rawOutput, grid: grid);
  }

  String _resolveExamplePath(String examplePath) {
    final String testDir = Directory.current.path;
    return '$testDir/test/pty/examples/$examplePath';
  }
}
