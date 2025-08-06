import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/single_child_render_object_widget.dart';
import 'package:radartui/widget/widget.dart';

class Card extends SingleChildRenderObjectWidget {
  const Card({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject() {
    return RenderCard(child: child);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    // No properties to update for now
  }
}

class RenderCard extends RenderObject {
  RenderCard({required super.child});

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
  void paint(Canvas canvas) {
    _drawBorder(canvas, layoutRect, isFocused: false); // TODO: Implement focus

    final innerRect = Rect(
      x: layoutRect.x + 1,
      y: layoutRect.y + 1,
      width: layoutRect.width - 2,
      height: layoutRect.height - 2,
    );

    if (child != null) {
      child!.layout(innerRect);
      child!.paint(canvas);
    }
  }

  @override
  int preferredHeight(int width) {
    if (child == null) return 0;
    return child!.preferredHeight(width) + 2; // Add 2 for border
  }

  @override
  int preferredWidth(int height) {
    if (child == null) return 0;
    return child!.preferredWidth(height) + 2; // Add 2 for border
  }
}