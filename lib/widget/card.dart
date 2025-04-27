import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/focusable_mixin.dart';
import 'package:radartui/widget/widget.dart';

class Card extends SingleChildWidget {
  Card({required super.child});
  bool get _isChildFocused {
    if (child is FocusableMixin) {
      final focusableChild = child as FocusableMixin;
      return focusableChild.focusNode.isFocused;
    }
    return false;
  }

  void _drawBorder(Canvas canvas, Rect rect, {bool isFocused = false}) {
    final topLeft = isFocused ? '╔' : '┌';
    final topRight = isFocused ? '╗' : '┐';
    final bottomLeft = isFocused ? '╚' : '└';
    final bottomRight = isFocused ? '╝' : '┘';
    final horizontal = isFocused ? '═' : '─';
    final vertical = isFocused ? '║' : '│';

    // 상단
    canvas.move(rect.x, rect.y);
    canvas.drawChar(topLeft + horizontal * (rect.width - 2) + topRight);

    // 사이드
    for (int y = 1; y < rect.height - 1; y++) {
      canvas.move(rect.x, rect.y + y);
      canvas.drawChar(vertical);
      canvas.move(rect.x + rect.width - 1, rect.y + y);
      canvas.drawChar(vertical);
    }

    // 하단
    canvas.move(rect.x, rect.y + rect.height - 1);
    canvas.drawChar(bottomLeft + horizontal * (rect.width - 2) + bottomRight);
  }

  @override
  void render(Canvas canvas, Rect rect) {
    _drawBorder(canvas, rect, isFocused: _isChildFocused);

    final innerRect = Rect(
      x: rect.x + 1,
      y: rect.y + 1,
      width: rect.width - 2,
      height: rect.height - 2,
    );

    child.render(canvas, innerRect);
  }

  @override
  int preferredHeight(int width) {
    return child.preferredHeight(width);
  }
}
