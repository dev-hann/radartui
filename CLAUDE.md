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

## 📌 Testing Rules & Guidelines

### 🎯 General Testing Principles

- **MANDATORY:** Every new widget and feature must be thoroughly tested
- Follow the test case list provided by Gemini CLI
- Test names must describe the exact behavior being tested
- Use `testWidgets` for UI-related tests when applicable
- **CRITICAL:** Always test keyboard input functionality using `inputTest`

### 🖥️ Terminal UI Input Testing

**MANDATORY:** For all interactive terminal UI components (buttons, checkboxes, radio buttons, text fields, navigation, etc.), use the **`inputTest`** method provided by **SchedulerBinding**.

#### 📋 Required Testing Procedure:

1. **Initialize Test Environment:**
```dart
final binding = SchedulerBinding.instance;
binding.runApp(YourTestWidget());
FocusManager.instance.initialize(); // CRITICAL: Always initialize FocusManager
```

2. **Test Key Input Simulation:**
```dart
// Test various key inputs
binding.inputTest(' ');      // Space key
binding.inputTest('\t');     // Tab key  
binding.inputTest('q');      // Character keys
// Add delays between inputs for proper processing
Future.delayed(Duration(milliseconds: 100), () => binding.inputTest('next_key'));
```

3. **Test All Interactive Elements:**
   - **Navigation Keys:** Tab, Shift+Tab, Arrow keys
   - **Action Keys:** Space, Enter
   - **Special Keys:** ESC (back navigation), character inputs
   - **Focus Management:** Ensure proper focus transitions

#### ⚡ Mandatory Key Input Tests:

**For Every Interactive Widget, Test:**

- ✅ **Space Key:** Primary selection/toggle action
- ✅ **Enter Key:** Alternative selection/confirmation action  
- ✅ **Tab Key:** Focus navigation (forward)
- ✅ **ESC Key:** Back/cancel navigation
- ✅ **Focus Behavior:** Visual feedback when focused/unfocused
- ✅ **State Changes:** Immediate visual updates after interaction

#### 🔧 Testing Template:

```dart
import 'dart:io';
import 'lib/radartui.dart';

void main() {
  final binding = SchedulerBinding.instance;
  
  print('Testing [Widget Name] functionality...');
  
  final app = YourTestWidget();
  binding.runApp(app);
  
  // CRITICAL: Initialize FocusManager
  FocusManager.instance.initialize();
  
  // Wait for initialization
  Future.delayed(const Duration(milliseconds: 200), () {
    print('Testing Space key...');
    binding.inputTest(' ');
    
    Future.delayed(const Duration(milliseconds: 100), () {
      print('Testing Enter key...');
      binding.inputTest('\n');
      
      Future.delayed(const Duration(milliseconds: 100), () {
        print('Test completed successfully');
        exit(0);
      });
    });
  });
}
```

#### 🚨 Critical Testing Requirements:

**Before Any Widget Is Considered Complete:**

1. **Space Key Test:** Widget must respond to space key input
2. **Enter Key Test:** Widget must respond to enter key input  
3. **Focus Test:** Widget must show visual focus indication
4. **State Sync Test:** Widget state changes must be immediately visible
5. **ESC Navigation Test:** All examples must support ESC to return to menu

#### 📊 Testing Verification Checklist:

- [ ] `inputTest(' ')` triggers expected action
- [ ] `inputTest('\n')` triggers expected action  
- [ ] Focus transitions work with Tab key
- [ ] Visual feedback appears immediately
- [ ] State changes are synchronized with rendering
- [ ] No input lag or delayed responses
- [ ] ESC key returns to main menu

### 🎪 Complex Interaction Testing

**For Multi-Component UIs:**

```dart
// Test component interaction flows
binding.inputTest('\t');  // Move to first component
binding.inputTest(' ');   // Activate first component
binding.inputTest('\t');  // Move to second component  
binding.inputTest(' ');   // Activate second component
// Verify state changes across components
```

### 🔍 Debugging Failed Tests

**When Tests Fail:**

1. **Check FocusManager:** Ensure `FocusManager.instance.initialize()` is called
2. **Check Key Parsing:** Verify Space is parsed as `KeyCode.char` with `char == ' '`
3. **Check Timing:** Add sufficient delays between input simulations
4. **Check State Updates:** Ensure `setState()` and `didUpdateWidget()` are properly implemented
5. **Check Rendering:** Ensure `markNeedsLayout()` is called when needed

### ⚠️ Testing Anti-Patterns to Avoid:

- ❌ **Never** test widgets without initializing FocusManager
- ❌ **Never** assume input works without explicit `inputTest` verification  
- ❌ **Never** commit interactive widgets that fail Space/Enter key tests
- ❌ **Never** skip testing state synchronization
- ❌ **Never** ignore visual feedback testing

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

### ⚡ Critical Enforcement Rule:

**MANDATORY:** After running `dart analyze`, ALL issues including errors, warnings, and info/hints **MUST** be resolved immediately. No code should be committed or considered complete until `dart analyze` returns **"No issues found!"**

- **Errors:** Fix immediately - code will not compile
- **Warnings:** Fix immediately - indicates potential runtime issues
- **Info/Hints:** Fix immediately - ensures code follows best practices and style guidelines

**Goal:** Maintain production-quality code with zero tolerance for technical debt.

---

# Development History & Implementation Notes

## 2025-10-19: StreamBuilder & FutureBuilder Implementation

### ✅ Implemented Features

Added asynchronous widget builders to RadarTUI for handling Stream and Future data:

#### New Files Created:
1. **`lib/src/widgets/basic/async_snapshot.dart`**
   - `ConnectionState` enum: none, waiting, active, done
   - `AsyncSnapshot<T>` class: Immutable snapshot of async computation state
   - Factory constructors: `nothing()`, `waiting()`, `withData()`, `withError()`
   - Null-safe API with `hasData`, `hasError` getters

2. **`lib/src/widgets/basic/async_widget_builder.dart`**
   - `AsyncWidgetBuilder<T>` typedef for builder callbacks
   - Shared between StreamBuilder and FutureBuilder

3. **`lib/src/widgets/basic/stream_builder.dart`**
   - `StreamBuilder<T>` widget for reactive Stream data
   - Automatic subscription/unsubscription lifecycle management
   - Error handling with stack traces
   - Support for initial data
   - ConnectionState tracking: waiting → active → done

4. **`lib/src/widgets/basic/future_builder.dart`**
   - `FutureBuilder<T>` widget for one-time Future data
   - Callback identity tracking to prevent stale updates
   - Error handling with stack traces
   - Support for initial data
   - ConnectionState tracking: waiting → done

#### Updated Files:
- **`lib/src/widgets/basic.dart`**: Added exports for new async widgets
- **`lib/src/widgets/basic/README.md`**: Documented new async widgets

### 🎯 Design Decisions

- **Separated AsyncWidgetBuilder**: Created dedicated file to avoid ambiguous exports
- **No Key Parameter**: StatefulWidget in RadarTUI doesn't support key parameter (unlike Flutter)
- **Flutter API Compatibility**: Maintains same API surface as Flutter's async builders
- **Generic Type Support**: Full `<T>` generic support for type safety
- **Testing Strategy**: Examples only (no unit tests) - following project convention

### 📝 Notes

- **Test files removed**: Project uses examples instead of traditional tests
- **Code quality verified**: All files pass `dart analyze` with zero issues
- **Ready for examples**: Widgets are production-ready, awaiting example implementations