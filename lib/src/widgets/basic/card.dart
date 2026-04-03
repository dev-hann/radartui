import '../../../radartui.dart';

class Card extends SingleChildRenderObjectWidget {
  const Card({super.key, Widget? child, this.color, this.padding})
    : super(child: child ?? const SizedBox());
  final Color? color;
  final EdgeInsets? padding;

  @override
  RenderCard createRenderObject(BuildContext context) =>
      RenderCard(color: color, padding: padding);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final card = renderObject as RenderCard;
    card.color = color;
    card.padding = padding;
  }
}

class RenderCard extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  RenderCard({this.color, this.padding});
  Color? color;
  EdgeInsets? padding;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;
    final totalPadding = padding ?? const EdgeInsets.all(0);

    const borderSize = 2;
    final availableWidth = boxConstraints.maxWidth - borderSize;
    final availableHeight = boxConstraints.maxHeight - borderSize;

    int cardWidth;
    int cardHeight;

    if (child != null) {
      final childMaxWidth =
          availableWidth - totalPadding.left - totalPadding.right;
      final childMaxHeight =
          availableHeight - totalPadding.top - totalPadding.bottom;

      final childConstraints = BoxConstraints(
        minWidth: 0,
        maxWidth: childMaxWidth,
        minHeight: 0,
        maxHeight: childMaxHeight,
      );
      child!.layout(childConstraints);

      if (boxConstraints.minWidth >= boxConstraints.maxWidth) {
        cardWidth = boxConstraints.maxWidth;
      } else {
        cardWidth =
            child!.size!.width +
            totalPadding.left +
            totalPadding.right +
            borderSize;
      }

      if (boxConstraints.minHeight >= boxConstraints.maxHeight) {
        cardHeight = boxConstraints.maxHeight;
      } else {
        cardHeight =
            child!.size!.height +
            totalPadding.top +
            totalPadding.bottom +
            borderSize;
      }

      final minHeight = borderSize + totalPadding.top + 1 + totalPadding.bottom;
      if (cardHeight < minHeight) {
        cardHeight = minHeight;
      }
    } else {
      cardWidth = boxConstraints.maxWidth;
      cardHeight = LayoutConstants.defaultContainerHeight;
    }

    size = Size(cardWidth, cardHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final totalPadding = padding ?? const EdgeInsets.all(0);
    final width = size!.width;
    final height = size!.height;
    final borderStyle = TextStyle(backgroundColor: color);
    final bgStyle = TextStyle(backgroundColor: color);

    if (color != null) {
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          context.buffer.writeStyled(offset.x + x, offset.y + y, ' ', bgStyle);
        }
      }
    }

    if (child != null) {
      context.paintChild(
        child!,
        offset + Offset(1 + totalPadding.left, 1 + totalPadding.top),
      );
    }

    // Draw borders AFTER child to ensure they're not overwritten
    // Draw top border: ┌─┐
    context.buffer.writeStyled(offset.x, offset.y, '┌', borderStyle);
    for (int x = 1; x < width - 1; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, '─', borderStyle);
    }
    context.buffer.writeStyled(
      offset.x + width - 1,
      offset.y,
      '┐',
      borderStyle,
    );

    // Draw side borders: │ │
    for (int y = 1; y < height - 1; y++) {
      context.buffer.writeStyled(offset.x, offset.y + y, '│', borderStyle);
      context.buffer.writeStyled(
        offset.x + width - 1,
        offset.y + y,
        '│',
        borderStyle,
      );
    }

    // Draw bottom border: └─┘
    context.buffer.writeStyled(
      offset.x,
      offset.y + height - 1,
      '└',
      borderStyle,
    );
    for (int x = 1; x < width - 1; x++) {
      context.buffer.writeStyled(
        offset.x + x,
        offset.y + height - 1,
        '─',
        borderStyle,
      );
    }
    context.buffer.writeStyled(
      offset.x + width - 1,
      offset.y + height - 1,
      '┘',
      borderStyle,
    );
  }
}
