import 'dart:async';
import 'dart:io';

import 'package:pty/pty.dart';

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
    this.timeout = const Duration(seconds: 5),
  });

  final int width;
  final int height;
  final Duration timeout;

  Future<PtyTestResult> runExample(String examplePath) async {
    final String scriptPath = _resolveExamplePath(examplePath);

    final PseudoTerminal pty = PseudoTerminal.start(
      Platform.executable,
      ['run', scriptPath, '--pty-test'],
      environment: Platform.environment,
    );

    pty.init();
    pty.resize(width, height);

    final StringBuffer buffer = StringBuffer();
    final Completer<int> exitCompleter = Completer<int>();
    final Completer<void> outputDone = Completer<void>();

    pty.out.listen(
      buffer.write,
      onDone: () {
        if (!outputDone.isCompleted) outputDone.complete();
      },
    );

    unawaited(
      pty.exitCode.then((int code) {
        if (!exitCompleter.isCompleted) exitCompleter.complete(code);
      }),
    );

    int exitCode = -1;
    try {
      exitCode = await exitCompleter.future.timeout(timeout);
    } on TimeoutException {
      pty.kill();
    }

    await outputDone.future.timeout(
      const Duration(seconds: 2),
      onTimeout: () {},
    );

    final String rawOutput = buffer.toString();
    final Vt100Parser parser = Vt100Parser(width: width, height: height);
    final List<String> grid = parser.parse(rawOutput);

    return PtyTestResult(exitCode: exitCode, rawOutput: rawOutput, grid: grid);
  }

  String _resolveExamplePath(String path) {
    final File direct = File(path);
    if (direct.existsSync()) return path;
    final File fallback = File('test/pty/examples/$path');
    if (fallback.existsSync()) return fallback.path;
    return path;
  }
}
