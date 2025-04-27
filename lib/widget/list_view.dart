import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/focusable_mixin.dart';
import 'package:radartui/widget/widget.dart';

class ListView extends Widget with FocusableMixin {
  ListView({
    required this.items,
    this.selectedIndex = 0,
    this.style = const Style(),
    this.selectedPrefix = "➤ ",
    this.highlightStyle = const Style(bold: true),
  });

  final List<String> items;
  int selectedIndex;
  final Style style;
  final String selectedPrefix;
  final Style highlightStyle;

  @override
  void render(Canvas canvas, Rect rect) {
    final visibleLines = rect.height;
    final startIndex = _startScrollIndex(rect.height);
    final endIndex = (startIndex + visibleLines).clamp(0, items.length);

    for (int i = startIndex; i < endIndex; i++) {
      final line = items[i];
      final isSelected = i == selectedIndex;

      canvas.move(rect.x, rect.y + (i - startIndex));
      canvas.drawChar(
        (isSelected ? selectedPrefix : "  ") + line.padRight(rect.width - 2),
        style: isSelected ? highlightStyle : style,
      );
    }
  }

  @override
  int preferredHeight(int width) {
    return items.length;
  }

  void moveUp() {
    if (selectedIndex > 0) selectedIndex--;
  }

  void moveDown() {
    if (selectedIndex < items.length - 1) selectedIndex++;
  }

  int _startScrollIndex(int visibleLines) {
    if (items.length <= visibleLines) return 0;

    final half = (visibleLines / 2).floor();
    return (selectedIndex - half).clamp(0, items.length - visibleLines);
  }

  @override
  void onKey(Key key) {
    if (key.type == KeyType.up) {
      selectedIndex = (selectedIndex - 1).clamp(0, items.length - 1);
    }
    if (key.type == KeyType.down) {
      selectedIndex = (selectedIndex + 1).clamp(0, items.length - 1);
    }
  }
}
