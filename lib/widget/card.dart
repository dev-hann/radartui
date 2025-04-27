import 'package:radartui/canvas/canvas.dart';
import 'package:radartui/canvas/rect.dart';
import 'package:radartui/widget/widget.dart';

class EdgeInsets {
  const EdgeInsets.all(int value)
    : left = value,
      right = value,
      top = value,
      bottom = value;

  const EdgeInsets.only({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
  });

  final int left;
  final int right;
  final int top;
  final int bottom;
}

class Card extends WithChildWidget {
  Card({required super.child});

  @override
  void render(Canvas canvas, Rect rect) {
    // 테두리 그리기
    _drawBorder(canvas, rect);

    // 내부 콘텐츠 영역 계산
    final innerRect = Rect(
      x: rect.x + 1,
      y: rect.y + 1,
      width: rect.width - 2,
      height: rect.height - 2,
    );

    // 자식 위젯을 내부 영역에 렌더링
    child.render(canvas, innerRect);
  }

  void _drawBorder(Canvas canvas, Rect rect) {
    final topLeft = '┌';
    final topRight = '┐';
    final bottomLeft = '└';
    final bottomRight = '┘';
    final horizontal = '─';
    final vertical = '│';

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
  int preferredHeight(int width) {
    return child.preferredHeight(width);
  }
}
