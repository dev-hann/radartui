# Testing Guide

## Commands

```bash
dart test                        # All tests
dart test test/unit/             # Unit tests only
dart test test/unit/foundation/  # Foundation tests only
dart test test/unit/services/    # Services tests only
dart test test/widgets/          # Widget tests only
dart test test/integration/      # Integration tests only
dart test test/pty/              # PTY golden tests (visual rendering)
```

## Test Structure

```
test/
├── unit/
│   ├── foundation/   # Size, Offset, Color, EdgeInsets, BoxConstraints
│   ├── services/     # KeyParser, OutputBuffer
│   └── widgets/      # Widget unit tests
├── widgets/
│   └── basic/        # Widget rendering tests
├── integration/      # Full app behavior tests
└── pty/
    ├── examples/     # Example app Dart files (one per widget)
    ├── golden/       # Golden .txt files (expected rendering output)
    ├── pty_golden_test.dart    # 30 golden test cases
    ├── pty_test_runner.dart    # Process.start-based ANSI capture
    ├── pty_test_helper.dart    # testPtyWidget() helper
    ├── vt100_parser.dart       # ANSI escape → text grid parser
    └── golden_matcher.dart     # Golden file comparison with diff
```

## PTY Golden Tests

Golden tests verify that widgets render correctly by capturing ANSI output
from real Dart processes and comparing parsed text grids against `.txt` files.

### How It Works

1. Each widget has an example app in `test/pty/examples/` (e.g., `button_app.dart`)
2. The test runner spawns `dart run example.dart --pty-test` via `Process.start`
3. Example apps skip keyboard init (`initializeServices`) and render a single frame
4. ANSI output is captured from piped stdout and parsed by the VT100 parser
5. The parsed text grid is compared against the golden file

### Running

```bash
dart test test/pty/                        # Run all 30 golden tests
dart test test/pty/ --name "Button"        # Run specific widget test
```

### Regenerating Goldens

Delete the golden file and re-run the test — auto-created on first run:

```bash
rm test/pty/golden/button_golden.txt
dart test test/pty/ --name "Button renders"
```

### Adding a New Golden Test

1. Create `test/pty/examples/<widget>_app.dart` following the pattern:

```dart
import 'dart:io';
import 'package:radartui/radartui.dart';

void main(List<String> args) {
  final bool isPtyTest = args.contains('--pty-test');
  final AppBinding binding = AppBinding.ensureInitialized() as AppBinding;

  if (!isPtyTest) {
    binding.initializeServices();
  }

  const widget = MyWidget();

  binding.attachRootWidget(widget);

  if (isPtyTest) {
    binding.renderFrame();
    exit(0);
  } else {
    binding.runApp(widget);
  }
}
```

2. Add a test case in `test/pty/pty_golden_test.dart`:

```dart
testPtyWidget(
  'MyWidget renders correctly',
  example: 'my_widget_app.dart',
  golden: 'my_widget_golden.txt',
);
```

3. Run the test once to auto-create the golden file.

### Key Design Decisions

- **Plain `Process.start`** instead of PTY (`package:pty` or `script`): avoids fd leaks
  and timing-dependent flakiness. Terminal size falls back to 80x24 when stdout is piped.
- **Skip `initializeServices()`** in `--pty-test` mode: avoids stdin.echoMode crash
  when stdin is piped.
- **VT100 parser** converts ANSI escape sequences to a text grid for comparison.

## Bug-Prone Areas (Priority Testing)

| Area | File | Risk |
|------|------|------|
| `isTight` logic | `box_constraints.dart` | HIGH - previously used `>=` instead of `==` |
| `deflate` edge cases | `box_constraints.dart` | HIGH - negative values handling |
| F-key parsing | `key_parser.dart` | HIGH - complex escape sequences |
| Modifier keys | `key_parser.dart` | MEDIUM - shift/alt/ctrl combinations |
| 16-color ANSI | `output_buffer.dart` | MEDIUM - values 10-15 handling |
| Space key | `key_parser.dart` | MEDIUM - was returning `char` instead of `KeyCode.space` |
| `FfiWrite` UTF-8 | `ffi_write.dart` | HIGH - must use `utf8.encode()` not code unit truncation |
| `FfiWrite` isatty | `ffi_write.dart` | MEDIUM - must skip /dev/tty when stdout is piped |

## Widget Test Template

```dart
import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  testWidgets('description', (tester) async {
    tester.pumpWidget(MyWidget());
    await tester.pumpAndSettle();
    // assertions...
  });
}
```

## Unit Test Template

```dart
import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('ClassName', () {
    group('constructor', () {
      test('creates instance with default values', () {
        final instance = ClassName();
        expect(instance.property, equals(defaultValue));
      });
    });

    group('methodName', () {
      test('returns expected result for valid input', () {
        final result = instance.method(validInput);
        expect(result, equals(expectedOutput));
      });
    });
  });
}
```

## Interactive Widget Test Checklist

When testing interactive widgets, verify:

- Space key triggers primary action
- Enter key triggers confirmation
- Tab key navigates focus
- ESC key returns to previous screen
- Visual focus indication works
- State changes render immediately
