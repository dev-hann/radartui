# RadarTUI - AI Development Guide

> Flutter-like TUI framework for Dart. See [CHANGELOG.md](CHANGELOG.md) for history.

---

## 0. MANDATORY: Git Worktree Workflow

All AI work MUST use worktrees. Never edit the main directory directly.

```bash
git worktree add ../.worktrees/<branch> -b <branch>   # Create
git worktree list                                       # Check
git worktree remove ../.worktrees/<branch>              # Cleanup
```

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feat/xxx` | `feat/add-gridview` |
| Fix | `fix/xxx` | `fix/memory-leak-focus` |
| Refactor | `refactor/xxx` | `refactor/simplify-layout` |
| Docs | `docs/xxx` | `docs/update-readme` |

---

## 1. Flutter Reference Principle

**CRITICAL: All implementations MUST reference Flutter's design patterns.**

Before implementing any widget:
1. Check Flutter source: https://github.com/flutter/flutter/tree/master/packages/flutter/lib/src/widgets
2. Match constructor parameters and method signatures
3. Use identical class/parameter names unless technically impossible

### Flutter → RadarTUI Adaptation

| Flutter | RadarTUI | Reason |
|---------|----------|--------|
| `double` coordinates | `int` coordinates | Terminal cells are discrete |
| `Color(0xFFRRGGBB)` | `Color(value)` | ANSI 16-color palette |
| Mouse/Touch events | Keyboard only | Terminal limitation |
| `super.key` in constructors | No `super.key` | Key support not yet implemented |

When to deviate: terminal limitations, performance (simplified algorithms OK), missing dependencies.

---

## 2. Project Structure

```
lib/src/
├── foundation/     # Size, Offset, Color, EdgeInsets, BoxConstraints
├── services/       # Terminal I/O, key parsing, logging
├── rendering/      # RenderObject tree, layout, RenderBox
├── scheduler/      # Frame scheduling, binding
└── widgets/
    ├── framework.dart       # Widget, Element, State base classes
    ├── focus_manager.dart   # Focus management
    ├── navigation.dart      # Navigator, Route
    └── basic/               # Concrete widgets (Text, Button, etc.)

test/
├── unit/           # Foundation, Services logic
├── widgets/        # Widget rendering, lifecycle
├── integration/    # Full app behavior
└── pty/            # PTY golden tests (ANSI output → text grid comparison)
    ├── examples/   # Example app Dart files (one per widget)
    └── golden/     # Golden .txt files (expected rendering)
```

Dependency flow: `Application → radartui.dart → widgets/ → scheduler/ → rendering/ → services/ → foundation/`

---

## 3. Coding Standards

### Non-Obvious Rules

- No `var` — use explicit types or `final`
- `const` for all immutable objects (`const Text('hello')`)
- Explicit public API types (`Size layout(BoxConstraints c)`)
- One public class per file
- Functions: MAX 30 lines, prefer < 20
- Nesting: MAX 3 levels
- Class member order: static fields → instance fields → constructors → methods
- File naming: `snake_case.dart`, static constants: `SCREAMING_SNAKE_CASE`

---

## 4. Widget Implementation

See [docs/widget-templates.md](docs/widget-templates.md) for StatelessWidget, StatefulWidget, and RenderObjectWidget templates.

Key pattern: all widgets follow Flutter's Widget → Element → RenderObject architecture. Use `RenderObjectWithChildMixin<C>` for single-child render objects.

---

## 5. Testing

See [docs/testing-guide.md](docs/testing-guide.md) for templates, structure, and bug-prone areas.

```bash
dart test                        # All tests
dart test test/unit/             # Unit tests only
dart test test/integration/      # Integration tests only
dart test test/pty/              # PTY golden tests (visual rendering verification)
```

### Bug-Prone Areas

| Area | Risk | Detail |
|------|------|--------|
| `isTight` in `box_constraints.dart` | HIGH | Used `>=` instead of `==` |
| `deflate` in `box_constraints.dart` | HIGH | Negative values handling |
| F-key parsing in `key_parser.dart` | HIGH | Complex escape sequences |
| `ShortcutActionsHandler` placement | HIGH | Must be INSIDE Shortcuts/Actions tree, not outside |
| `FfiWrite` UTF-8 encoding | HIGH | Must use `utf8.encode()` not code unit truncation |
| `FfiWrite` isatty check | MEDIUM | Must skip /dev/tty when stdout is piped |

---

## 6. Quality Verification

**MANDATORY before any commit:**

```bash
dart format .
dart analyze    # Must return: No issues found!
```

Zero tolerance for errors, warnings, and hints.

---

## 7. Known Gotchas

- `Element.parent` returns `Element?` — always null-check
- Cast to `BuildContext` with `element as BuildContext`
- `List.map()` returns `Iterable`, not `List` — use `.toList()` or for-loops
- Container has no `border`/`borderColor` parameters
- Text widget uses `data` property (not `text`) for string content
- `Shortcuts.lookup()` traverses UP the tree — `ShortcutActionsHandler` must be a descendant of `Shortcuts`
- PTY golden test example apps MUST guard `initializeServices()` with `if (!isPtyTest)` to avoid stdin.echoMode crash when stdin is piped
- `FfiWrite.writeString()` MUST use `utf8.encode()` for proper multi-byte character handling

---

## 8. Current Limitations

| Feature | Status |
|---------|--------|
| Mouse events | N/A (terminal limitation) |
| Scrolling | Basic (limited ListView) |
| Animations | Full animation system (AnimationController, Tween, CurvedAnimation, Curves) |
| Key system | No `super.key` support yet |
