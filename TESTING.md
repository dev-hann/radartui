# Testing

TDD is the core development methodology. See [AGENTS.md](AGENTS.md) for workflow rules.

## TDD Cycle

Every feature MUST follow:

1. **RED** - Write a failing test. Run it. Confirm it fails.
2. **GREEN** - Write the minimum implementation to pass. Run it. Confirm it passes.
3. **REFACTOR** - Clean up code. Run tests again. All must still pass.

No implementation code may exist without a corresponding test.

## TDD Enforcement Tiers

Not all code requires the same level of TDD strictness.
Use this tier system to balance safety and efficiency.

### Tier S — Strict (Per Test Case)

For code with complex logic: foundation types, parsers, encoding.

Protocol:
1. Write ONE test case
2. Run `dart test <file>` → MUST fail (RED)
3. Write minimum code to pass
4. Run `dart test <file>` → MUST pass (GREEN)
5. Repeat from step 1 for next test case

Examples:
- `Size` arithmetic — each operator individually
- `BoxConstraints.isTight` — each edge case individually
- `BoxConstraints.deflate` — negative values, zero, overflow
- `KeyParser.parse` — each escape sequence individually
- `OutputBuffer` ANSI color handling — each color value

### Tier A — Per Class

For code with moderate logic: render objects, widgets, bindings.

Protocol:
1. Write ALL test cases for the class
2. Run `dart test <dir>/` → MUST fail (RED)
3. Write minimum implementation for the entire class
4. Run `dart test <dir>/` → MUST pass (GREEN)

Examples:
- `RenderBox`, `RenderObject` — layout and paint logic
- `StatelessWidget`, `StatefulWidget` — lifecycle
- `RenderObjectWidget` — Widget → Element → RenderObject wiring
- `AppBinding`, `WidgetsBinding` — initialization and frame scheduling

### Tier B — Per Layer

For code with no logic: data classes, type definitions, enumerations.

Protocol:
1. Write all code in the layer (enums, typedefs, colors)
2. Write all tests for the layer
3. Run `dart test` → MUST pass (GREEN)

RED verification is not required — these have no logic to fail.

Examples:
- `Color` values and constants
- `Axis`, `Flex`, `Alignment` enumerations
- `VerticalDirection`, `TextDirection` typedefs
- `Animation<T>`, `Curves` definitions

### Tier Assignment Table

| Component | Tier | Reason |
|-----------|------|--------|
| `Size`, `Offset` arithmetic | S | Mathematical edge cases |
| `BoxConstraints` methods | S | Complex constraint logic, many edge cases |
| `KeyParser.parse` | S | Complex escape sequence parsing |
| `OutputBuffer` write/flush | S | ANSI encoding, multi-byte handling |
| `RenderObject` / `RenderBox` | A | Layout/paint logic, child management |
| Widget (Stateless/Stateful) | A | Lifecycle, Element creation |
| RenderObjectWidget | A | Three-class wiring (Widget→Element→RenderObject) |
| Binding classes | A | Initialization order, frame scheduling |
| Integration tests | A | Multi-layer wiring verification |
| PTY golden tests | A | Visual rendering verification |
| `Color` constants | B | Pure data, no logic |
| Enumerations (`Axis`, `Flex`) | B | No logic |
| Typedefs | B | Type definitions only |
| `Curves` definitions | B | Mathematical functions, no state |
| `Animation<T>` types | B | Type definitions |

## Strict Enforcement Rules

The following rules are NON-NEGOTIABLE regardless of tier.

### Every `dart test` Run Is Mandatory

Every step that says "Run `dart test`" in the AGENTS.md checklist
MUST be executed. The test output MUST be observed before proceeding.

### Prohibited Patterns

1. **Batch TDD** — Writing multiple test files then multiple implementation
   files without running tests in between. Each tier has its own cycle;
   follow it.

2. **Same-batch test+impl** — Writing test and implementation in the
   same tool call. Tests and implementations MUST be written in
   separate steps so the agent can observe RED.

3. **Skipping RED** — For Tier S and A, you MUST verify that tests
   fail before writing implementation. If a test passes immediately,
   either the test is wrong or the implementation already exists.

4. **Skipping test run** — Writing test → implementation → running
   `dart test` once at the end. Each RED→GREEN transition requires
   its own `dart test` execution.

5. **Proceeding before GREEN** — Do not start the next step until the
   current step's `dart test` passes. If it fails, fix it first.

### Minimum Implementation Principle

During GREEN phase, write the MINIMUM code to make the test pass.

- Hardcoded return values are acceptable if that is what makes the test pass.
- Do not anticipate future tests.
- Refactoring comes after GREEN, not during.
- The next test case will force you to generalize.

## Test Levels

### 1. Unit Tests (`test/unit/`)

Isolated tests for individual classes and functions.

| Target | What to test |
|--------|-------------|
| Foundation (`Size`, `Offset`, `BoxConstraints`) | Arithmetic, edge cases, immutability |
| Services (`KeyParser`, `OutputBuffer`) | Parsing accuracy, encoding correctness |
| Rendering (`RenderObject`, `RenderBox`) | Layout algorithm, paint output |
| Widgets (unit) | Element creation, lifecycle, state management |

Unit test pattern:
```dart
import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('Size', () {
    group('constructor', () {
      test('creates instance with width and height', () {
        final size = Size(10, 20);
        expect(size.width, equals(10));
        expect(size.height, equals(20));
      });
    });

    group('+', () {
      test('returns sum of two sizes', () {
        final result = Size(10, 20) + Size(5, 10);
        expect(result, equals(Size(15, 30)));
      });
    });
  });
}
```

### 2. Widget Tests (`test/unit/widgets/`)

Test widget rendering and interaction using `testWidgets`.

Widget test pattern:
```dart
import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  testWidgets('renders text content', (tester) async {
    tester.pumpWidget(const Text('hello'));
    await tester.pumpAndSettle();
    expect(tinder.find.text('hello'), findsOne);
  });
}
```

### 3. Integration Tests (`test/integration/`)

Wire up multiple real layers together. No mocks.

- Test complete widget trees (e.g., Container with padding + Text child)
- Verify layout composition across layers
- Test focus management across widgets
- Test navigation flows

### 4. PTY Golden Tests (`test/pty/`)

Visual rendering verification by capturing ANSI output from real Dart processes
and comparing parsed text grids against golden files.

See [doc/testing-guide.md](doc/testing-guide.md) for full PTY golden test guide.

## Test Level Decision Matrix

| Question | Answer → Test Level |
|----------|-------------------|
| "Is this function/class logic correct?" | Unit |
| "Does this widget render correctly?" | Widget |
| "Do multiple layers work together?" | Integration |
| "Does the actual terminal output match expected?" | PTY Golden |

## Bug-Prone Areas (Priority Testing)

| Area | File | Risk | Detail |
|------|------|------|--------|
| `isTight` logic | `box_constraints.dart` | HIGH | Previously used `>=` instead of `==` |
| `deflate` edge cases | `box_constraints.dart` | HIGH | Negative values handling |
| F-key parsing | `key_parser.dart` | HIGH | Complex escape sequences |
| `ShortcutActionsHandler` placement | `shortcuts.dart` | HIGH | Must be INSIDE Shortcuts/Actions tree |
| `FfiWrite` UTF-8 encoding | `ffi_write.dart` | HIGH | Must use `utf8.encode()` not code unit truncation |
| `FfiWrite` isatty check | `ffi_write.dart` | MEDIUM | Must skip /dev/tty when stdout is piped |
| Modifier keys | `key_parser.dart` | MEDIUM | Shift/Alt/Ctrl combinations |
| 16-color ANSI | `output_buffer.dart` | MEDIUM | Values 10-15 handling |
| Space key | `key_parser.dart` | MEDIUM | Was returning `char` instead of `KeyCode.space` |

## Test Anti-Patterns

The following patterns are prohibited:

- **Mock echo**: Asserting the exact value that was set up in setup code. This tests the mock, not the code.
- **No assertions**: A test without at least one `expect` is not a test.
- **Tautology**: Asserting conditions that are always true.
- **Code duplication**: Copying implementation logic into test code and comparing outputs.
- **Testing private members**: Only test public API behavior.
- **Batch writing**: Writing tests and implementations in the same tool call without running `dart test` in between.

## Test Description Format

Use `should [expected] when [condition]`:

```dart
test('should return tight constraints when min equals max', () { ... });
test('should render text centered when wrapped in Center', () { ... });
test('should trigger callback when Enter is pressed', () { ... });
```

## Interactive Widget Test Checklist

When testing interactive widgets, verify:

- Space key triggers primary action
- Enter key triggers confirmation
- Tab key navigates focus
- ESC key returns to previous screen
- Visual focus indication works
- State changes render immediately

## Commands

| Command | Purpose |
|---------|---------|
| `dart test` | Run all tests |
| `dart test test/unit/` | Unit tests only |
| `dart test test/unit/foundation/` | Foundation tests only |
| `dart test test/unit/services/` | Services tests only |
| `dart test test/unit/widgets/` | Widget unit tests only |
| `dart test test/unit/rendering/` | Rendering tests only |
| `dart test test/integration/` | Integration tests only |
| `dart test test/pty/` | PTY golden tests (visual rendering) |

## Current Test Counts

| Level | Directory | Files |
|-------|-----------|-------|
| Unit — Foundation | `test/unit/foundation/` | 10 |
| Unit — Services | `test/unit/services/` | 3 |
| Unit — Rendering | `test/unit/rendering/` | 4 |
| Unit — Widgets | `test/unit/widgets/` | 35+ |
| Unit — Animation | `test/unit/animation/` | 5 |
| Unit — Binding | `test/unit/binding/` | 2 |
| Integration | `test/integration/` | 33 |
| PTY Golden | `test/pty/` | 31 |
| **Total** | | **125+** |
