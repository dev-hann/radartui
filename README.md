# 🧲 radartui

**radartui** is a TUI (Text-based User Interface) framework written in Dart, inspired by [ratatui](https://github.com/ratatui-org/ratatui) from the Rust ecosystem.  
It enables developers to build structured, interactive terminal interfaces in a Flutter-like widget system — fully open-source and free for commercial use.

---

## ✨ Features

- 🧱 Widget-based layout system (Row, Column, Expanded, etc.)
- ⌨️ Keyboard event handling with focus management
- 🖋 Input-ready `TextField` with cursor support
- 📋 Scrollable `ListView` 
- 🎨 Rich styling system (bold, underline, inverted, etc.)
- 🧑‍💻 Designed for Dart developers — no native dependencies

---

## 🖥 Supported Platforms

- ✅ Linux terminal
- ✅ macOS terminal (iTerm2, Apple Terminal, etc.)
- ❌ Windows support: not available yet

---

## 🚀 Getting Started

```bash
git clone https://github.com/dev-hann/radartui.git
cd radartui
dart run
```

> ⚠️ Requires Dart SDK. Install it from [https://dart.dev/get-dart](https://dart.dev/get-dart)

---

## 🧪 Example

```dart
void main(List<String> args) {
  Radartui.runApp(
    Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Card(
                child: ListView(items: ["Item 1", "Item 2"]),
              ),
            ),
            Expanded(
              flex: 8,
              child: Card(
                child: TextField(hintText: 'Type here...'),
              ),
            ),
          ],
        ),
        Button(
          label: 'Submit',
          onPressed: () {
            print('Submitted!');
          },
        ),
      ],
    ),
    onKey: (key) {
      if (key.ctrl && key.label == 'q') {
        Radartui.exitApp();
      } else if (key.label == '\t') {
        FocusManager.instance.focusNext();
      } else if (key.label == '\x1b[Z') {
        FocusManager.instance.focusPrevious();
      }

      FocusManager.instance.onKey(key);
    },
  );
}
```

---

## 🧱 Widgets Overview

| Widget       | Description                                        |
|--------------|----------------------------------------------------|
| `Row`        | Places children horizontally                       |
| `Column`     | Places children vertically                         |
| `Expanded`   | Fills available space proportionally               |
| `TextField`  | Editable input field with cursor                   |
| `ListView`   | Scrollable list (static for now)                   |
| `Button`     | Clickable with Enter or Space                      |
| `Card`       | Adds visual container with styling                 |

---

## 📌 Planned Features

- [ ] Scrollable & selectable `ListView`
- [ ] Padding / Align / Center layout widgets
- [ ] Checkbox, Radio button, Dropdown
- [ ] Page routing & state management
- [ ] Widget borders for debug visualization

---

## 🤝 Contributing

Contributions are welcome!  
Feel free to submit pull requests for new widgets, bug fixes, or improvements.

---

## 📄 License

Licensed under the [MIT License](https://opensource.org/licenses/MIT).  
You are free to use, modify, and distribute this software commercially or personally.

---

## 👨‍💻 Author

Created by [@dev-hann](https://github.com/dev-hann) — a Dart developer passionate about terminal UI.

