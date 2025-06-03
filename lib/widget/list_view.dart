import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

// TODO: scroll offset make stateful
class ListView extends LeafWidget {
  ListView({
    required super.focusID,
    required this.items,
    this.selectedIndex = 0,
    this.onSelect,
    this.style = const Style(),
    this.highlightStyle = const Style(inverted: true),
  });

  final List<String> items;
  int selectedIndex;
  final void Function(int index)? onSelect;

  final Style style;
  final Style highlightStyle;

  int scrollOffset = 0;
  int lastHeight = 0;

  @override
  void render(Canvas canvas, Rect rect) {
    lastHeight = rect.height;
    final visibleLines = rect.height;
    final start = scrollOffset;
    final end = (start + visibleLines).clamp(0, items.length);

    for (int i = start; i < end; i++) {
      canvas.move(rect.x, rect.y + i - start);
      final isSelected = (i == selectedIndex) && hasFocus;
      final currentStyle = isSelected ? highlightStyle : style;
      canvas.setStyle(currentStyle);
      canvas.drawChar(items[i].padRight(rect.width), style: currentStyle);
    }

    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => items.length;

  @override
  void onKey(Key key) {
    if (!hasFocus) return;

    switch (key.type) {
      case KeyType.up:
        if (selectedIndex > 0) {
          selectedIndex--;
          if (selectedIndex < scrollOffset) {
            scrollOffset = selectedIndex;
          }
        }
        break;
      case KeyType.down:
        if (selectedIndex < items.length - 1) {
          selectedIndex++;
          final maxScroll = scrollOffset + lastHeight;
          if (selectedIndex >= maxScroll) {
            scrollOffset++;
          }
        }
        break;
      case KeyType.enter:
        onSelect?.call(selectedIndex);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldUpdate(covariant ListView oldWidget) {
    return items != oldWidget.items ||
        selectedIndex != oldWidget.selectedIndex ||
        onSelect != oldWidget.onSelect ||
        style != oldWidget.style ||
        highlightStyle != oldWidget.highlightStyle;
  }
}
