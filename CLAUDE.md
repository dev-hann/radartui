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

All Dart code in RadarTUI must follow the style guide and lint rules below.

## 📌 General Style

- Use **`dart format`** before committing any code
- Prefer `final` for variables that are not reassigned
- Avoid using `var` unless type inference is clear and unambiguous
- Always use explicit types for public APIs (methods, classes, parameters, return values)
- No unused imports, variables, or parameters

## 📌 Naming Conventions

- **Classes**: `UpperCamelCase`
- **Methods & variables**: `lowerCamelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private members**: Prefix with `_`

## 📌 Code Structure

- Keep functions short and focused (ideally < 40 lines)
- Break long expressions into multiple lines for readability
- Avoid deeply nested code (prefer early returns)
- One public class per file unless grouping is logical

## 📌 Lint Rules (summary)

- Use `pedantic` or `lints` package as a base
- Enable:
  - `always_declare_return_types`
  - `prefer_const_constructors`
  - `avoid_print`
  - `prefer_final_locals`
  - `use_super_parameters` (Dart 3+)
- Treat all warnings as errors in CI

## 📌 Testing

- Follow the test case list provided by Gemini CLI
- Test names must describe the exact behavior being tested
- Use `testWidgets` for UI-related tests

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