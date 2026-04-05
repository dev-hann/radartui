# PTY Golden Testing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build PTY-based golden test infrastructure that runs RadarTUI apps in a real pseudo-terminal, captures ANSI output, parses it to a text grid, and compares against `.txt` golden files.

**Architecture:** `package:pty` spawns Dart example apps in a PTY with 80x24 size. Example apps render one frame via `renderFrame()` then exit. The PTY output (ANSI escape sequences) is captured, parsed through a VT100 parser into a `List<String>` grid, and compared against golden `.txt` files.

**Tech Stack:** Dart, `package:pty` (FFI-based PTY), `package:test`, `dart:io`

---

## File Structure

| Action | Path | Purpose |
|--------|------|---------|
| Modify | `pubspec.yaml` | Add `pty: ^0.2.2-pre` to `dev_dependencies` |
| Create | `test/pty/vt100_parser.dart` | ANSI escape → text grid parser |
| Create | `test/pty/pty_test_runner.dart` | PTY process lifecycle, output capture |
| Create | `test/pty/golden_matcher.dart` | Golden file comparison matcher |
| Create | `test/pty/pty_test_helper.dart` | `testPtyWidget()` test registration helper |
| Create | `test/pty/examples/text_app.dart` | Text widget example app |
| Create | `test/pty/examples/button_app.dart` | Button widget example app |
| Create | `test/pty/examples/center_app.dart` | Center widget example app |
| Create | `test/pty/examples/column_app.dart` | Column widget example app |
| Create | `test/pty/examples/row_app.dart` | Row widget example app |
| Create | `test/pty/golden/text_golden.txt` | Text widget golden (auto-generated) |
| Create | `test/pty/golden/button_golden.txt` | Button widget golden (auto-generated) |
| Create | `test/pty/golden/center_golden.txt` | Center widget golden (auto-generated) |
| Create | `test/pty/golden/column_golden.txt` | Column widget golden (auto-generated) |
| Create | `test/pty/golden/row_golden.txt` | Row widget golden (auto-generated) |
| Create | `test/pty/pty_golden_test.dart` | Main test file with all golden tests |
| Modify | `lib/src/binding/widgets_binding.dart` | Add `renderFrame()` and `attachRootWidget()` |

---

### Task 1: Add `package:pty` dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add pty to dev_dependencies**

In `pubspec.yaml`, add `pty` under `dev_dependencies`:

```yaml
dev_dependencies:
  lints: ^4.0.0
  pty: ^0.2.2-pre
```

- [ ] **Step 2: Run dart pub get**

Run: `dart pub get`
Expected: Dependencies resolve successfully.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add package:pty to dev_dependencies for golden testing"
```

---

### Task 2: Add `renderFrame()` to WidgetsBinding

Example apps need a way to render a single frame and exit, without entering the interactive event loop. Currently `runApp()` sets up signal handlers and enters the main loop. We need `attachRootWidget()` + `renderFrame()`.

**Files:**
- Modify: `lib/src/binding/widgets_binding.dart`

- [ ] **Step 1: Add `attachRootWidget()` and `renderFrame()` methods**

Add these two methods to the `WidgetsBinding` mixin in `lib/src/binding/widgets_binding.dart`, after the `runApp()` method (after line 50):

```dart
  void attachRootWidget(Widget app) {
    terminal.clear();
    terminal.hideCursor();
    _rootElement = app.createElement();
    _rootElement!.mount(null);
  }

  void renderFrame() {
    if (_rootElement != null) {
      _build(_rootElement!);
      _layout(_rootElement!);
      outputBuffer.smartClear();
      paintElement(_rootElement!);
    }
    outputBuffer.flush();
  }
```

- [ ] **Step 2: Verify existing tests still pass**

Run: `dart test`
Expected: All existing tests pass.

- [ ] **Step 3: Commit**

```bash
git add lib/src/binding/widgets_binding.dart
git commit -m "feat: add attachRootWidget() and renderFrame() for single-frame rendering"
```

---

### Task 3: Create VT100 Parser

**Files:**
- Create: `test/pty/vt100_parser.dart`

- [ ] **Step 1: Write the VT100 parser**

Create `test/pty/vt100_parser.dart`:

```dart
import 'dart:math';

class Vt100Parser {
  Vt100Parser({this.width = 80, this.height = 24});

  final int width;
  final int height;

  List<String> parse(String input) {
    final grid = List.generate(
      height,
      (_) => List<String>.filled(width, ' '),
    );
    int cursorX = 0;
    int cursorY = 0;
    int i = 0;

    while (i < input.length) {
      if (input[i] == '\x1b' && i + 1 < input.length && input[i + 1] == '[') {
        final seqEnd = _findSequenceEnd(input, i + 2);
        if (seqEnd == -1) {
          i++;
          continue;
        }
        final seq = input.substring(i + 2, seqEnd);
        final cmd = input[seqEnd];
        _handleSequence(seq, cmd, grid, (x, y) { cursorX = x; cursorY = y; }, () => cursorX, () => cursorY);
        i = seqEnd + 1;
      } else if (input[i] == '\n') {
        cursorX = 0;
        cursorY++;
        if (cursorY >= height) cursorY = height - 1;
        i++;
      } else if (input[i] == '\r') {
        cursorX = 0;
        i++;
      } else if (input[i].codeUnitAt(0) >= 32) {
        if (cursorX < width && cursorY < height) {
          grid[cursorY][cursorX] = input[i];
          cursorX++;
          if (cursorX >= width) {
            cursorX = 0;
            cursorY++;
            if (cursorY >= height) cursorY = height - 1;
          }
        }
        i++;
      } else {
        i++;
      }
    }

    return grid.map((row) => row.join()).toList();
  }

  int _findSequenceEnd(String input, int start) {
    for (int j = start; j < input.length; j++) {
      final code = input[j].codeUnitAt(0);
      if (code >= 0x40 && code <= 0x7E) {
        return j;
      }
    }
    return -1;
  }

  void _handleSequence(
    String params,
    String cmd,
    List<List<String>> grid,
    void Function(int, int) setCursor,
    int Function() getCursorX,
    int Function() getCursorY,
  ) {
    switch (cmd) {
      case 'H':
      case 'f':
        _handleCursorPosition(params, setCursor);
      case 'J':
        _handleEraseDisplay(params, grid);
      case 'K':
        _handleEraseLine(params, grid, getCursorX(), getCursorY());
      case 'm':
        break;
      case 'l':
      case 'h':
        break;
    }
  }

  void _handleCursorPosition(String params, void Function(int, int) setCursor) {
    if (params.isEmpty) {
      setCursor(0, 0);
      return;
    }
    final parts = params.split(';');
    final row = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 1) - 1 : 0;
    final col = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) - 1 : 0;
    setCursor(col.clamp(0, width - 1), row.clamp(0, height - 1));
  }

  void _handleEraseDisplay(String params, List<List<String>> grid) {
    final mode = params.isEmpty ? 0 : int.tryParse(params) ?? 0;
    switch (mode) {
      case 2:
        for (int y = 0; y < height; y++) {
          for (int x = 0; x < width; x++) {
            grid[y][x] = ' ';
          }
        }
      case 0:
      case 1:
        break;
    }
  }

  void _handleEraseLine(String params, List<List<String>> grid, int cursorX, int cursorY) {
    if (cursorY < 0 || cursorY >= height) return;
    final mode = params.isEmpty ? 0 : int.tryParse(params) ?? 0;
    switch (mode) {
      case 0:
        for (int x = cursorX; x < width; x++) {
          grid[cursorY][x] = ' ';
        }
      case 1:
        for (int x = 0; x <= min(cursorX, width - 1); x++) {
          grid[cursorY][x] = ' ';
        }
      case 2:
        for (int x = 0; x < width; x++) {
          grid[cursorY][x] = ' ';
        }
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add test/pty/vt100_parser.dart
git commit -m "feat: add VT100 parser for ANSI output to text grid conversion"
```

---

### Task 4: Create PTY Test Runner

**Files:**
- Create: `test/pty/pty_test_runner.dart`

- [ ] **Step 1: Write the PTY test runner**

Create `test/pty/pty_test_runner.dart`:

```dart
import 'dart:async';
import 'dart:io';

import 'package:pty/pty.dart';

import 'vt100_parser.dart';

class PtyTestResult {
  PtyTestResult({required this.exitCode, required this.rawOutput, required this.grid});
  final int exitCode;
  final String rawOutput;
  final List<String> grid;
}

class PtyTestRunner {
  PtyTestRunner({this.width = 80, this.height = 24, this.timeout = const Duration(seconds: 5)});

  final int width;
  final int height;
  final Duration timeout;

  Future<PtyTestResult> runExample(String examplePath) async {
    final dartExecutable = Platform.executable;
    final scriptPath = _resolveExamplePath(examplePath);

    final pty = PseudoTerminal.start(
      dartExecutable,
      ['run', scriptPath, '--pty-test'],
      environment: Platform.environment,
      rows: height,
      columns: width,
    );

    final outputBuffer = StringBuffer();
    final completer = Completer<int>();

    pty.out.listen(
      (data) {
        outputBuffer.write(data);
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete(0);
        }
      },
      onError: (e) {
        if (!completer.isCompleted) {
          completer.complete(1);
        }
      },
    );

    final exitCode = await completer.future.timeout(
      timeout,
      onTimeout: () {
        pty.kill();
        return -1;
      },
    );

    final rawOutput = outputBuffer.toString();
    final parser = Vt100Parser(width: width, height: height);
    final grid = parser.parse(rawOutput);

    return PtyTestResult(exitCode: exitCode, rawOutput: rawOutput, grid: grid);
  }

  String _resolveExamplePath(String examplePath) {
    if (File(examplePath).existsSync()) return examplePath;
    final relativePath = 'test/pty/examples/$examplePath';
    if (File(relativePath).existsSync()) return relativePath;
    throw FileSystemException('Example not found: $examplePath');
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add test/pty/pty_test_runner.dart
git commit -m "feat: add PTY test runner for spawning and capturing example apps"
```

---

### Task 5: Create Golden Matcher

**Files:**
- Create: `test/pty/golden_matcher.dart`

- [ ] **Step 1: Write the golden matcher**

Create `test/pty/golden_matcher.dart`:

```dart
import 'dart:io';

import 'package:test/test.dart';

Matcher matchesGoldenFile(String goldenPath) => _GoldenMatcher(goldenPath);

class _GoldenMatcher extends Matcher {
  _GoldenMatcher(this.goldenPath);
  final String goldenPath;

  static bool updateGoldens = false;

  @override
  bool matches(Object? item, Map matchState) {
    final grid = item as List<String>;
    final file = File(goldenPath);

    if (updateGoldens || !file.existsSync()) {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(_gridToString(grid));
      matchState['autoUpdated'] = true;
      return true;
    }

    final expected = file.readAsStringSync();
    final actual = _gridToString(grid);
    matchState['expected'] = expected;
    matchState['actual'] = actual;
    return actual == expected;
  }

  @override
  Description describe(Description description) =>
      description.add('matches golden file $goldenPath');

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState['autoUpdated'] == true) {
      return mismatchDescription.add('golden file was auto-created/updated');
    }
    final expected = matchState['expected'] as String;
    final actual = matchState['actual'] as String;
    return mismatchDescription.add(_diff(expected, actual));
  }

  String _gridToString(List<String> grid) {
    final trimmed = _trimTrailingEmptyLines(grid);
    return trimmed.map((line) => line.trimRight()).join('\n');
  }

  List<String> _trimTrailingEmptyLines(List<String> grid) {
    int lastNonEmpty = grid.length - 1;
    while (lastNonEmpty >= 0 && grid[lastNonEmpty].trimRight().isEmpty) {
      lastNonEmpty--;
    }
    if (lastNonEmpty < 0) return [''];
    return grid.sublist(0, lastNonEmpty + 1);
  }

  String _diff(String expected, String actual) {
    final expectedLines = expected.split('\n');
    final actualLines = actual.split('\n');
    final buffer = StringBuffer();
    buffer.writeln('\n--- Expected ($goldenPath)');
    buffer.writeln('+++ Actual (PTY output)');
    final maxLen = expectedLines.length > actualLines.length
        ? expectedLines.length
        : actualLines.length;
    for (int i = 0; i < maxLen; i++) {
      final exp = i < expectedLines.length ? expectedLines[i] : '<missing>';
      final act = i < actualLines.length ? actualLines[i] : '<missing>';
      if (exp != act) {
        buffer.writeln('- line ${i + 1}: "$exp"');
        buffer.writeln('+ line ${i + 1}: "$act"');
      }
    }
    return buffer.toString();
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add test/pty/golden_matcher.dart
git commit -m "feat: add golden file matcher for PTY test output comparison"
```

---

### Task 6: Create PTY Test Helper

**Files:**
- Create: `test/pty/pty_test_helper.dart`

- [ ] **Step 1: Write the test helper**

Create `test/pty/pty_test_helper.dart`:

```dart
import 'dart:io';

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
      fail('PTY process exited with code ${result.exitCode}\nOutput: ${result.rawOutput}');
    }

    expect(result.grid, matchesGoldenFile(goldenPath));
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add test/pty/pty_test_helper.dart
git commit -m "feat: add testPtyWidget() helper for PTY golden tests"
```

---

### Task 7: Create Example Apps

Each example app imports `radartui`, builds a widget tree, renders one frame, and exits.

**Files:**
- Create: `test/pty/examples/text_app.dart`
- Create: `test/pty/examples/button_app.dart`
- Create: `test/pty/examples/center_app.dart`
- Create: `test/pty/examples/column_app.dart`
- Create: `test/pty/examples/row_app.dart`

- [ ] **Step 1: Create text_app.dart**

Create `test/pty/examples/text_app.dart`:

```dart
import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();

  binding.attachRootWidget(const Text('Hello, PTY!'));

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(const Text('Hello, PTY!'));
  }
}
```

- [ ] **Step 2: Create button_app.dart**

Create `test/pty/examples/button_app.dart`:

```dart
import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();

  binding.attachRootWidget(
    Button(
      onPressed: () {},
      child: const Text('Click Me'),
    ),
  );

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(
      Button(
        onPressed: () {},
        child: const Text('Click Me'),
      ),
    );
  }
}
```

- [ ] **Step 3: Create center_app.dart**

Create `test/pty/examples/center_app.dart`:

```dart
import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();

  binding.attachRootWidget(
    const Center(
      child: Text('Centered'),
    ),
  );

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(
      const Center(
        child: Text('Centered'),
      ),
    );
  }
}
```

- [ ] **Step 4: Create column_app.dart**

Create `test/pty/examples/column_app.dart`:

```dart
import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();

  binding.attachRootWidget(
    const Column(
      children: [
        Text('Line 1'),
        Text('Line 2'),
        Text('Line 3'),
      ],
    ),
  );

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(
      const Column(
        children: [
          Text('Line 1'),
          Text('Line 2'),
          Text('Line 3'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Create row_app.dart**

Create `test/pty/examples/row_app.dart`:

```dart
import 'dart:io';

import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final isPtyTest = args.contains('--pty-test');
  final binding = AppBinding.ensureInitialized();
  binding.initializeServices();

  binding.attachRootWidget(
    const Row(
      children: [
        Text('A'),
        Text('B'),
        Text('C'),
      ],
    ),
  );

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(
      const Row(
        children: [
          Text('A'),
          Text('B'),
          Text('C'),
        ],
      ),
    );
  }
}
```

- [ ] **Step 6: Commit**

```bash
git add test/pty/examples/
git commit -m "feat: add PTY example apps for golden testing"
```

---

### Task 8: Create Main PTY Golden Test File

**Files:**
- Create: `test/pty/pty_golden_test.dart`

- [ ] **Step 1: Write the test file**

Create `test/pty/pty_golden_test.dart`:

```dart
import 'golden_matcher.dart';
import 'pty_test_helper.dart';

void main() {
  group('PTY Golden Tests', () {
    testPtyWidget(
      'Text renders correctly',
      example: 'text_app.dart',
      golden: 'text_golden.txt',
    );

    testPtyWidget(
      'Button renders correctly',
      example: 'button_app.dart',
      golden: 'button_golden.txt',
    );

    testPtyWidget(
      'Center renders correctly',
      example: 'center_app.dart',
      golden: 'center_golden.txt',
    );

    testPtyWidget(
      'Column renders correctly',
      example: 'column_app.dart',
      golden: 'column_golden.txt',
    );

    testPtyWidget(
      'Row renders correctly',
      example: 'row_app.dart',
      golden: 'row_golden.txt',
    );
  });
}
```

- [ ] **Step 2: Run tests to auto-generate golden files**

Run: `dart test test/pty/pty_golden_test.dart`
Expected: All tests PASS. Golden files are auto-created in `test/pty/golden/` since they don't exist yet.

- [ ] **Step 3: Run tests again to verify golden comparison**

Run: `dart test test/pty/pty_golden_test.dart`
Expected: All tests PASS, comparing against the generated golden files.

- [ ] **Step 4: Run `dart analyze`**

Run: `dart analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add test/pty/pty_golden_test.dart test/pty/golden/
git commit -m "feat: add PTY golden tests with initial golden files"
```

---

### Task 9: Verify full test suite

- [ ] **Step 1: Run all existing tests to verify no regressions**

Run: `dart test`
Expected: All existing tests pass.

- [ ] **Step 2: Run PTY tests specifically**

Run: `dart test test/pty/`
Expected: All PTY golden tests pass.

- [ ] **Step 3: Run `dart format` and `dart analyze`**

Run: `dart format . && dart analyze`
Expected: No issues found.

- [ ] **Step 4: Commit any formatting changes**

```bash
git add -A
git commit -m "chore: format and lint fixes for PTY test infrastructure"
```
