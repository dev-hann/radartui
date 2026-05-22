# RadarTUI - AI Development Guide

> Flutter-like TUI framework for Dart. See [CHANGELOG.md](CHANGELOG.md) for history.

---

## 0. Development Workflow: TDD

See [TESTING.md](TESTING.md) for full TDD cycle, enforcement tiers, and rules.

TDD is MANDATORY. Enforcement varies by code tier:

| Tier | Scope | TDD Cycle | Applies To |
|------|-------|-----------|------------|
| S (Strict) | Per test case | RED→GREEN per individual test case | Foundation (`Size`, `Offset`, `BoxConstraints`), Services (`KeyParser`, `OutputBuffer`) |
| A (Per-class) | Per class | RED→GREEN per class | RenderObject, Widget (Stateless/Stateful/RenderObjectWidget), Binding |
| B (Per-layer) | Per layer | Write tests then impl, no RED required | Animation, Enums, Typedefs, Color |

**CRITICAL**: Every implementation step MUST be followed by `dart test`.
Skipping `dart test` between steps is a PROHIBITED ACTION.

---

## 1. Mandatory Checks Before Committing

```bash
dart format .
dart analyze    # Must return: No issues found!
dart test       # All tests must pass
```

All three must pass with zero errors. No exceptions.

---

## 2. Flutter Reference Principle

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
| `super.key` in constructors | `super.key` is OK | Key reconciliation (GlobalKey/ValueKey matching) not yet implemented |

When to deviate: terminal limitations, performance (simplified algorithms OK), missing dependencies.

---

## 3. Project Structure

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

See [doc/ARCHITECTURE.md](doc/ARCHITECTURE.md) for full layer details.

---

## 4. Coding Standards

See [doc/CONVENTIONS.md](doc/CONVENTIONS.md) for full details.

Key constraints:

- No `var` — use explicit types or `final`
- `const` for all immutable objects (`const Text('hello')`)
- Explicit public API types (`Size layout(BoxConstraints c)`)
- One public class per file (except Flutter core framework files: `framework.dart`, `navigation.dart`, `render_object.dart`, `render_box.dart` which mirror Flutter's multi-class-per-file pattern)
- Functions: MAX 30 lines, prefer < 20
- Nesting: MAX 3 levels
- Class member order (Flutter convention): constructors → instance fields → static methods → instance methods → override methods
- File naming: `snake_case.dart`, static constants: `SCREAMING_SNAKE_CASE` (except Flutter-parity constants like `Size.zero`, `Color.red` which use `camelCase`)
- No inline comments. Doc comments (`///`) on public API are allowed and encouraged.

---

## 5. Widget Implementation

See [doc/widget-templates.md](doc/widget-templates.md) for StatelessWidget, StatefulWidget, and RenderObjectWidget templates.

Key pattern: all widgets follow Flutter's Widget → Element → RenderObject architecture. Use `RenderObjectWithChildMixin<C>` for single-child render objects.

---

## 6. Testing

See [TESTING.md](TESTING.md) for full TDD tiers, test levels, templates, and bug-prone areas.

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

## 7. MANDATORY: Git Worktree Workflow

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
| Docs | `doc/xxx` | `doc/update-readme` |

---

## 8. Feature Implementation Checklist

Follow this checklist IN ORDER when adding a new widget or significant feature.
Each step is a complete TDD cycle. Do NOT proceed to step N+1 until step N is fully GREEN.

### Step 1: Foundation Layer (Tier B — Per-layer)

1. Write Foundation types if needed (e.g., new `EdgeInsets`, `BoxConstraints` variant)
2. Write tests for all of the above
3. Run `dart test test/unit/foundation/` → Confirm GREEN

### Step 2: Services Layer (Tier S/A — Per class or per test case)

1. Write ALL failing service tests (e.g., `KeyParser`, `OutputBuffer` changes)
2. Run `dart test test/unit/services/` → Confirm RED
3. Write minimum service implementation
4. Run `dart test test/unit/services/` → Confirm GREEN

### Step 3: RenderObject (Tier A — Per-class)

1. Write ALL failing RenderObject tests
2. Run `dart test test/unit/rendering/` → Confirm RED
3. Write minimum RenderObject implementation (`performLayout`, `paint`)
4. Run `dart test test/unit/rendering/` → Confirm GREEN

### Step 4: Widget (Tier A — Per-class)

1. Write ALL failing Widget tests
2. Run `dart test test/unit/widgets/` → Confirm RED
3. Write minimum Widget implementation
4. Run `dart test test/unit/widgets/` → Confirm GREEN

### Step 5: Integration Test

1. Write integration test wiring real layers
2. Run `dart test test/integration/` → Confirm GREEN

### Step 6: PTY Golden Test

1. Create example app in `test/pty/examples/<widget>_app.dart`
2. Add test case in `test/pty/pty_golden_test.dart`
3. Run `dart test test/pty/` → Confirm GREEN (auto-creates golden)

### Step 7: Example App

1. Create example in `example/src/<widget>_example.dart`
2. Export in `example/src/exports.dart`
3. Verify manually if needed

### Step 8: Final Check

1. Run `dart format .` → No changes
2. Run `dart analyze` → Zero issues
3. Run `dart test` → All pass
4. Update [ROADMAP.md](ROADMAP.md) if feature status changed
5. Update [CHANGELOG.md](CHANGELOG.md) with new feature
6. Commit only when all pass

**RULE**: Every `dart test` run in steps 1-7 is MANDATORY.
Skipping any of them is a PROHIBITED ACTION.

---

## 9. Commit Convention

Use Conventional Commits:

```
feat: add DataTable widget with sorting
fix: correct BoxConstraints.deflate negative values
refactor: simplify Flex performLayout
test: add PTY golden tests for Stack widget
docs: update architecture diagram
chore: upgrade ffi dependency
perf: cache TextStyle in RenderDropdownMenu
style: add missing const to Text widgets
```

---

## 10. Prohibited Actions

- Writing implementation code without tests
- Writing test and implementation in the same tool call batch — they MUST be separate steps
- Proceeding to the next component before the current component is GREEN
- Writing multiple test files before writing any implementation code
- Skipping `dart test` verification between RED and GREEN phases
- Using `var` instead of explicit types or `final`
- Adding comments unless explicitly requested
- Committing code with failing tests
- Skipping `dart analyze` before committing
- Deviating from Flutter's Widget → Element → RenderObject pattern without documented reason

---

## 11. Pre-Commit Document Update (MANDATORY)

Code changes before commit, check if changes affect related documents and update if needed:

| Change Type | Document to Update | Check Items |
|-------------|-------------------|-------------|
| Widget added/removed/modified | [ROADMAP.md](ROADMAP.md) §Widget Catalog | Widget status, Flutter parity |
| Architecture change | [doc/ARCHITECTURE.md](doc/ARCHITECTURE.md) | Layers, Data Flow, Design Decisions |
| Test added/removed/modified | [TESTING.md](TESTING.md) | Test counts, known failures |
| New file created | [doc/CONVENTIONS.md](doc/CONVENTIONS.md) | Directory structure, naming |
| New dependency | `pubspec.yaml` + [doc/ARCHITECTURE.md](doc/ARCHITECTURE.md) | Dependency list |
| Coding standard change | [doc/CONVENTIONS.md](doc/CONVENTIONS.md) | Rules, naming |
| Widget template change | [doc/widget-templates.md](doc/widget-templates.md) | Templates |

### Check Method

1. `git diff --stat` to see changed files
2. Identify affected documents from the table above
3. Read document → reflect changes → save
4. Include document updates in the commit

---

## 12. Known Gotchas

- `Element.parent` returns `Element?` — always null-check
- Cast to `BuildContext` with `element as BuildContext`
- `List.map()` returns `Iterable`, not `List` — use `.toList()` or for-loops
- Container has no `border`/`borderColor` parameters
- Text widget uses `data` property (not `text`) for string content
- `Shortcuts.lookup()` traverses UP the tree — `ShortcutActionsHandler` must be a descendant of `Shortcuts`
- PTY golden test example apps MUST guard `initializeServices()` with `if (!isPtyTest)` to avoid stdin.echoMode crash when stdin is piped
- `FfiWrite.writeString()` MUST use `utf8.encode()` for proper multi-byte character handling

---

## 13. Current Limitations

| Feature | Status |
|---------|--------|
| Mouse events | N/A (terminal limitation) |
| Scrolling | Basic (limited ListView) |
| Animations | Full animation system (AnimationController, Tween, CurvedAnimation, Curves) |
| Key system | No `super.key` support yet |

---

## Reference Documents

- **[TESTING.md](TESTING.md)** — TDD tiers, test levels, bug-prone areas, templates
- **[ROADMAP.md](ROADMAP.md)** — Feature matrix, milestones, widget catalog
- **[doc/ARCHITECTURE.md](doc/ARCHITECTURE.md)** — System architecture, layers, rendering pipeline
- **[doc/CONVENTIONS.md](doc/CONVENTIONS.md)** — Coding rules, naming, file placement
- **[doc/widget-templates.md](doc/widget-templates.md)** — Widget implementation templates
- **[doc/testing-guide.md](doc/testing-guide.md)** — PTY golden test guide, test commands
- **[CHANGELOG.md](CHANGELOG.md)** — Version history
