# Testing Guide

## Commands

```bash
dart test                        # All tests
dart test test/unit/             # Unit tests only
dart test test/unit/foundation/  # Foundation tests only
dart test test/unit/services/    # Services tests only
dart test test/widgets/          # Widget tests only
dart test test/integration/      # Integration tests only
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
└── integration/      # Full app behavior tests
```

## Bug-Prone Areas (Priority Testing)

| Area | File | Risk |
|------|------|------|
| `isTight` logic | `box_constraints.dart` | HIGH - previously used `>=` instead of `==` |
| `deflate` edge cases | `box_constraints.dart` | HIGH - negative values handling |
| F-key parsing | `key_parser.dart` | HIGH - complex escape sequences |
| Modifier keys | `key_parser.dart` | MEDIUM - shift/alt/ctrl combinations |
| 16-color ANSI | `output_buffer.dart` | MEDIUM - values 10-15 handling |
| Space key | `key_parser.dart` | MEDIUM - was returning `char` instead of `KeyCode.space` |

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
