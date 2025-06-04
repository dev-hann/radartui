import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart';
import 'package:radartui/widget/widget.dart';

class ScrollController {
  ScrollController({
    this.scrollOffset = 0,
    this.lastHeight = 0,
    this.selectedIndex = 0,
    required this.items,
    this.onSelect,
  });
  int selectedIndex;
  int scrollOffset;
  int lastHeight;
  final List<String> items;
  final void Function(int index, String item)? onSelect;

  void onKey(Key key) {
    switch (key.type) {
      case KeyType.up:
        if (selectedIndex > 0) selectedIndex--;
        break;
      case KeyType.down:
        if (selectedIndex < items.length - 1) selectedIndex++;
        break;
      case KeyType.enter:
        onSelect?.call(selectedIndex, items[selectedIndex]);
        break;
      default:
        break;
    }
    adjustScroll();
  }

  void adjustScroll() {
    if (selectedIndex < scrollOffset) {
      scrollOffset = selectedIndex;
    } else if (selectedIndex >= scrollOffset + lastHeight) {
      scrollOffset = selectedIndex - lastHeight + 1;
    }
  }
}

class ListView extends LeafWidget {
  ListView({
    required super.focusID,
    required this.scrollController,
    this.onSelect,
    this.style = const Style(),
    this.highlightStyle = const Style(inverted: true),
  });

  final ScrollController scrollController;
  final void Function(int index)? onSelect;
  final Style style;
  final Style highlightStyle;
  List<String> get items => scrollController.items;

  @override
  void render(Canvas canvas, Rect rect) {
    super.render(canvas, rect);
    scrollController.lastHeight = rect.height;
    final visibleLines = rect.height;
    final start = scrollController.scrollOffset;
    final end = (start + visibleLines).clamp(0, items.length);

    for (int i = start; i < end; i++) {
      canvas.move(rect.x, rect.y + i - start);
      final isSelected = (i == scrollController.selectedIndex) && isFocused;
      final currentStyle = isSelected ? highlightStyle : style;
      canvas.setStyle(currentStyle);
      canvas.drawChar(items[i].padRight(rect.width), style: currentStyle);
    }

    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => items.length;

  @override
  bool shouldUpdate(covariant ListView oldWidget) {
    return items != oldWidget.items ||
        scrollController.selectedIndex !=
            oldWidget.scrollController.selectedIndex ||
        onSelect != oldWidget.onSelect ||
        style != oldWidget.style ||
        highlightStyle != oldWidget.highlightStyle;
  }
}
