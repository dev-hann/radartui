import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/style.dart';
import 'package:radartui/model/key.dart' as input_key;
import 'package:radartui/enum/key_type.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
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

  void onKey(input_key.Key key) {
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

class ListView extends RenderObjectWidget {
  const ListView({
    super.key,
    required this.scrollController,
    this.style = const Style(),
    this.highlightStyle = const Style(),
  });

  final ScrollController scrollController;
  final Style style;
  final Style highlightStyle;

  @override
  RenderObject createRenderObject() {
    return RenderListView(
      scrollController: scrollController,
      style: style,
      highlightStyle: highlightStyle,
    );
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderListView).scrollController = scrollController;
    (renderObject as RenderListView).style = style;
    (renderObject as RenderListView).highlightStyle = highlightStyle;
  }
}

class RenderListView extends RenderObject {
  RenderListView({
    required this.scrollController,
    required this.style,
    required this.highlightStyle,
  });

  ScrollController scrollController;
  Style style;
  Style highlightStyle;

  List<String> get items => scrollController.items;

  @override
  void paint(Canvas canvas) {
    scrollController.lastHeight = layoutRect.height;
    final visibleLines = layoutRect.height;
    final start = scrollController.scrollOffset;
    final end = (start + visibleLines).clamp(0, items.length);

    for (int i = start; i < end; i++) {
      canvas.move(layoutRect.x, layoutRect.y + i - start);
      final isSelected = (i == scrollController.selectedIndex);
      final currentStyle = isSelected ? highlightStyle : style;
      canvas.setStyle(currentStyle);
      canvas.drawChar(items[i].padRight(layoutRect.width), style: currentStyle);
    }

    canvas.clearStyle();
  }

  @override
  int preferredHeight(int width) => items.length;
}