# RadarTUI Architecture & Development Guide 🏗️

This document outlines the architecture and development guidelines for **RadarTUI**,  
a Flutter-like TUI framework built with Dart.  
It also describes the workflow rules for using **Claude Code** and **Gemini CLI** together effectively.

---

# Claude Code & Gemini CLI Usage Rules

## 📌 Purpose

In this project, **Claude Code** and **Gemini CLI** are used side by side to maximize productivity.  
Each tool has a **clear and strictly separated role**, ensuring there is no confusion or overlap.

---

## 🛠 Claude Code — Responsibilities

- **Primary role:** Writing and implementing code
- Tasks include:
  - Developing new features
  - Fixing bugs
  - Writing and maintaining test code
  - Refactoring existing code
- **Scope:**
  - Implement changes strictly according to provided specifications and designs
  - Follow the established project structure and style guide

---

## 📄 Gemini CLI — Responsibilities

- **Primary role:** Providing external development support
- Tasks include:
  - Analyzing and reviewing code structure
  - Investigating issues and finding root causes
  - Writing and maintaining technical documentation, README files, and comments
  - Preparing development plans and feature specifications
  - **Listing and describing test cases** for features and bug fixes
  - Researching and summarizing reference or learning materials
- **Limitations:**
  - Must not write or modify any source code (this is Claude Code’s role)
  - Must not implement actual test code (Claude Code will handle that)

---

## 🚦 Mandatory Rules — No Exceptions

1. **All code creation and modification must be handled exclusively by Claude Code.**
   - Gemini CLI must never perform code edits.
2. **All analysis, documentation, and planning must be handled exclusively by Gemini CLI.**
   - Claude Code must not be used for these tasks.
3. If something is unclear during development, use Gemini CLI for clarification or analysis.
4. Document all major decisions and changes in this file (**Claude.md**).
5. These rules are not optional — breaking them will harm both quality and efficiency.

---

## 📌 Notes

- **Keep roles separate:** Clear boundaries allow each tool to perform at its best.
- **If rules are ignored:** Expect reduced code quality, slower delivery, and more bugs.
- **Goal:** Maintain both speed and quality by ensuring each tool stays within its intended role.

---

## 📁 Directory Structure

This directory structure provides a high-level overview. For more details on the role of each directory and its files, **please refer to the `README.md` file within each directory.**

```
lib/
├── radartui.dart
└── src/
    ├── foundation/ (-> see lib/src/foundation/README.md)
    ├── services/   (-> see lib/src/services/README.md)
    ├── rendering/  (-> see lib/src/rendering/README.md)
    ├── scheduler/  (-> see lib/src/scheduler/README.md)
    └── widgets/    (-> see lib/src/widgets/README.md)
        └── basic/  (-> see lib/src/widgets/basic/README.md)
example/            (-> see example/README.md)
└── src/            (-> see example/src/README.md)
```

---

# Dart Style & Lint Rules

All Dart code in RadarTUI must follow the **strict** style guide and lint rules below.

## 📌 General Style (STRICT)

- **MANDATORY:** Use **`dart format`** before committing any code
- **MANDATORY:** Use `final` for ALL variables that are not reassigned
- **FORBIDDEN:** Using `var` - always declare explicit types or use `final`
- **MANDATORY:** Always use explicit types for public APIs (methods, classes, parameters, return values)
- **MANDATORY:** No unused imports, variables, or parameters
- **MANDATORY:** Use `const` constructors wherever possible for immutable objects
- **MANDATORY:** Prefer `const` collections (`const []`, `const {}`, `const <String>[]`)
- **MANDATORY:** Use null safety operators (`?.`, `??`, `!`) appropriately
- **FORBIDDEN:** Using `dynamic` type unless absolutely necessary (document why)

## 📌 Const Usage Rules (STRICT)

- **MANDATORY:** Use `const` constructors for all immutable widgets/objects:
  ```dart
  // ✅ CORRECT
  const Text('Hello');
  const EdgeInsets.all(8.0);
  const SizedBox(width: 10);
  
  // ❌ INCORRECT
  Text('Hello');
  EdgeInsets.all(8.0);
  SizedBox(width: 10);
  ```
- **MANDATORY:** Use `const` for collections when all elements are compile-time constants:
  ```dart
  // ✅ CORRECT
  const List<String> items = ['a', 'b', 'c'];
  const Map<String, int> values = {'x': 1, 'y': 2};
  
  // ❌ INCORRECT
  final List<String> items = ['a', 'b', 'c'];
  final Map<String, int> values = {'x': 1, 'y': 2};
  ```
- **MANDATORY:** Mark all compile-time constant fields as `static const`

## 📌 Naming Conventions (STRICT)

- **Classes**: `UpperCamelCase` (e.g., `RadarWidget`, `InputHandler`)
- **Methods & variables**: `lowerCamelCase` (e.g., `handleInput`, `currentValue`)
- **Constants**: `lowerCamelCase` for const constructors, `SCREAMING_SNAKE_CASE` for static const
- **Private members**: MUST prefix with `_` (e.g., `_internalState`, `_handlePrivateEvent`)
- **Files**: `snake_case.dart` (e.g., `radar_widget.dart`, `input_handler.dart`)
- **Directories**: `snake_case` (e.g., `user_input`, `text_rendering`)

## 📌 Code Structure (STRICT)

- **MANDATORY:** Keep functions short and focused (MAX 30 lines, prefer < 20)
- **MANDATORY:** Break long expressions into multiple lines for readability
- **MANDATORY:** Avoid deeply nested code (MAX 3 levels, prefer early returns)
- **MANDATORY:** One public class per file unless tightly coupled
- **MANDATORY:** Order class members: static fields → instance fields → constructors → methods
- **MANDATORY:** Group imports: dart core → third party → local imports
- **MANDATORY:** Use trailing commas for multi-line function calls and collections

## 📌 Null Safety (STRICT)

- **MANDATORY:** Use non-nullable types by default
- **MANDATORY:** Use `late` only when initialization is guaranteed before access
- **FORBIDDEN:** Using `!` operator without clear documentation why it's safe
- **MANDATORY:** Prefer `?.` and `??` operators over explicit null checks
- **MANDATORY:** Use `assert()` statements to document non-null assumptions

## 📌 Performance Rules (STRICT)

- **MANDATORY:** Use `const` constructors to enable object reuse
- **MANDATORY:** Avoid creating objects in build/render methods when possible
- **MANDATORY:** Use `identical()` for reference equality checks
- **MANDATORY:** Prefer `StringBuffer` for string concatenation in loops
- **FORBIDDEN:** Using `+` operator for multiple string concatenations

## 📌 Lint Rules (COMPREHENSIVE)

Use **`flutter_lints`** or **`dart_lints`** package with these additional rules:

### Required Lint Rules:
```yaml
linter:
  rules:
    # Style
    - always_declare_return_types
    - always_use_package_imports
    - avoid_print
    - avoid_unnecessary_containers
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_locals
    - prefer_final_fields
    - prefer_final_in_for_each
    - use_super_parameters
    
    # Performance
    - avoid_function_literals_in_foreach_calls
    - prefer_collection_literals
    - prefer_spread_collections
    - unnecessary_lambdas
    
    # Safety
    - avoid_dynamic_calls
    - avoid_type_to_string
    - cancel_subscriptions
    - close_sinks
    - hash_and_equals
    - no_adjacent_strings_in_list
    - test_types_in_equals
    
    # Null Safety
    - avoid_null_checks_in_equality_operators
    - prefer_null_aware_operators
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
```

### **ZERO TOLERANCE:** Treat ALL warnings as errors in CI and development

## 📌 Testing

- Follow the test case list provided by Gemini CLI
- Test names must describe the exact behavior being tested
- Use `testWidgets` for UI-related tests

### 🖥️ Terminal Example Testing

For testing terminal UI examples and interactive components, use the **`inputTest`** method provided by **SchedulerBinding**:

```dart
// Use SchedulerBinding.instance.inputTest() for terminal interaction testing
SchedulerBinding.instance.inputTest(/* test parameters */);
```

This method allows proper simulation of user input and keyboard events in terminal environments, ensuring accurate testing of TUI components like dialogs, buttons, and navigation.

## 📌 Code Quality Verification

**MANDATORY:** After writing or modifying any code, always run static analysis to ensure code quality:

```bash
dart analyze
```

### ✅ Code Quality Requirements:

**Always Fix These Issues:**
- Unused imports, variables, or parameters
- Missing return type annotations on all public APIs
- Syntax errors and typos
- Logic errors and potential runtime issues
- Missing null safety annotations
- Improper error handling

### 🎯 Verification Strategy:

1. **Run analysis:** `dart analyze lib/`
2. **Fix ALL issues:** Address every error, warning, and hint reported
3. **Test thoroughly:** Ensure all functionality works as expected
4. **Document changes:** Update documentation and comments as needed

**Goal:** Maintain production-quality code with zero tolerance for technical debt.