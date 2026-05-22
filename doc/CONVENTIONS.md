# Conventions

Coding rules for this project. See [ARCHITECTURE.md](ARCHITECTURE.md) for layer boundaries. See [TESTING.md](../TESTING.md) for testing rules.

## Dart Style

- Run `dart analyze` before every commit. Zero errors, warnings, and hints.
- Run `dart format .` before every commit. Zero changes.
- No `var` — use explicit types or `final`.
- `const` for all immutable objects.
- No inline comments. Doc comments (`///`) on public API are allowed and encouraged.
- Import order: `dart:` → `package:` → relative imports.
- Explicit public API types on all method signatures.

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Foundation | `snake_case.dart` | `box_constraints.dart` |
| Service | `snake_case.dart` | `key_parser.dart` |
| RenderObject | `render_*.dart` or `single_child_render_box.dart` | `render_box.dart` |
| Widget (basic) | `snake_case.dart` | `text.dart`, `button.dart` |
| Widget (composite) | `snake_case.dart` | `data_table.dart` |
| Binding | `*_binding.dart` | `app_binding.dart` |
| Barrel export | `layer_name.dart` | `foundation.dart`, `widgets.dart` |
| Test (unit) | `*_test.dart` | `box_constraints_test.dart` |
| Test (integration) | `*_test.dart` | `container_test.dart` |
| PTY example app | `*_app.dart` | `button_app.dart` |
| PTY golden | `*_golden.txt` | `button_golden.txt` |
| Example | `*_example.dart` | `button_example.dart` |

## Naming Conventions

| Target | Convention | Example |
|--------|-----------|---------|
| Classes | `PascalCase` | `RenderBox`, `StatelessWidget` |
| Variables, functions, methods | `camelCase` | `performLayout`, `childNode` |
| Private members | `_camelCase` | `_padding`, `_markNeedsLayout` |
| Files, directories | `snake_case` | `render_box.dart` |
| Static constants | `SCREAMING_SNAKE_CASE` | `MAX_WIDTH`, `DEFAULT_COLOR` |
| Constructor parameters | `camelCase` | `required this.padding` |

## Function Constraints

- MAX 30 lines per function. Prefer < 20.
- MAX 3 levels of nesting.
- Each function does one thing.

## Class Member Order

Flutter convention (follow Flutter's actual pattern):
```
1. Constructors (const, named, factory, generative)
2. Instance fields
3. Static methods
4. Instance methods
5. Override methods
```

## Widget Implementation Rules

### Flutter Reference Principle

Before implementing any widget:
1. Check Flutter source code for the equivalent widget
2. Match constructor parameter names
3. Match method signatures
4. Use identical class names unless technically impossible

### Flutter → RadarTUI Adaptation

| Flutter | RadarTUI | Reason |
|---------|----------|--------|
| `double` | `int` | Terminal cells are discrete |
| `Color(0xFFRRGGBB)` | `Color(value)` | ANSI 16-color |
| `super.key` | Omitted | Not yet implemented |
| Mouse/Touch | Keyboard only | Terminal limitation |

### Widget Types

Use [widget-templates.md](widget-templates.md) for templates:

- **StatelessWidget**: For widgets with no mutable state. Override `build()`.
- **StatefulWidget**: For widgets with mutable state. Override `createState()`.
- **RenderObjectWidget**: For custom layout/paint. Override `createRenderObject()` and `updateRenderObject()`.

### RenderObject Pattern

All render objects follow:
1. Accept configuration via setter (mark dirty on change)
2. `performLayout()` — compute size and position children
3. `paint()` — emit draw commands to `PaintingContext`

Use `RenderObjectWithChildMixin<C>` for single-child render objects.

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

| Type | When | Example |
|------|------|---------|
| `feat:` | New widget or feature | `feat: add DataTable widget with sorting` |
| `fix:` | Bug fix | `fix: correct BoxConstraints.deflate negative values` |
| `refactor:` | Code restructuring | `refactor: simplify Flex performLayout` |
| `test:` | Test additions | `test: add PTY golden tests for Stack widget` |
| `docs:` | Documentation | `docs: update architecture diagram` |
| `chore:` | Maintenance | `chore: upgrade ffi dependency` |
| `perf:` | Performance improvement | `perf: cache TextStyle in RenderDropdownMenu` |
| `style:` | Code style fix | `style: add missing const to Text widgets` |

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feat/xxx` | `feat/add-gridview` |
| Fix | `fix/xxx` | `fix/memory-leak-focus` |
| Refactor | `refactor/xxx` | `refactor/simplify-layout` |
| Docs | `doc/xxx` | `doc/update-readme` |

## Architecture Enforcement

Dependency direction: `widgets → scheduler → rendering → services → foundation`

- `foundation/` has zero imports from other layers
- `services/` only imports `foundation/`
- `rendering/` imports `services/` and `foundation/`
- Reverse imports are prohibited

## Testing

See [TESTING.md](../TESTING.md) for all testing rules, levels, and conventions.
