import '../../../radartui.dart';

class Divider extends StatelessWidget {
  final int? height;
  final int? thickness;
  final Color? color;
  final String? character;

  const Divider({
    this.height,
    this.thickness,
    this.color,
    this.character,
  });

  @override
  Widget build(BuildContext context) {
    return _DividerRenderWidget(
      height: height ?? 1,
      thickness: thickness ?? 1,
      color: color ?? Color.brightBlack,
      character: character ?? '─',
    );
  }
}

class VerticalDivider extends StatelessWidget {
  final int? width;
  final int? thickness;
  final Color? color;
  final String? character;

  const VerticalDivider({
    this.width,
    this.thickness,
    this.color,
    this.character,
  });

  @override
  Widget build(BuildContext context) {
    return _VerticalDividerRenderWidget(
      width: width ?? 1,
      thickness: thickness ?? 1,
      color: color ?? Color.brightBlack,
      character: character ?? '│',
    );
  }
}

class _DividerRenderWidget extends RenderObjectWidget {
  final int height;
  final int thickness;
  final Color color;
  final String character;

  const _DividerRenderWidget({
    required this.height,
    required this.thickness,
    required this.color,
    required this.character,
  });

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderDivider createRenderObject(BuildContext context) => RenderDivider(
        height: height,
        thickness: thickness,
        color: color,
        character: character,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final divider = renderObject as RenderDivider;
    divider.height = height;
    divider.thickness = thickness;
    divider.color = color;
    divider.character = character;
  }
}

class _VerticalDividerRenderWidget extends RenderObjectWidget {
  final int width;
  final int thickness;
  final Color color;
  final String character;

  const _VerticalDividerRenderWidget({
    required this.width,
    required this.thickness,
    required this.color,
    required this.character,
  });

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderVerticalDivider createRenderObject(BuildContext context) =>
      RenderVerticalDivider(
        width: width,
        thickness: thickness,
        color: color,
        character: character,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final divider = renderObject as RenderVerticalDivider;
    divider.width = width;
    divider.thickness = thickness;
    divider.color = color;
    divider.character = character;
  }
}

class RenderDivider extends RenderBox {
  int height;
  int thickness;
  Color color;
  String character;

  RenderDivider({
    required this.height,
    required this.thickness,
    required this.color,
    required this.character,
  });

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    size = Size(boxConstraints.maxWidth, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final textStyle = TextStyle(color: color);
    final lineChar = character.isNotEmpty ? character[0] : '─';

    for (int y = 0; y < thickness && y < height; y++) {
      for (int x = 0; x < size!.width; x++) {
        context.buffer.writeStyled(
          offset.x + x,
          offset.y + y,
          lineChar,
          textStyle,
        );
      }
    }
  }
}

class RenderVerticalDivider extends RenderBox {
  int width;
  int thickness;
  Color color;
  String character;

  RenderVerticalDivider({
    required this.width,
    required this.thickness,
    required this.color,
    required this.character,
  });

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints as BoxConstraints;
    size = Size(width, boxConstraints.maxHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final textStyle = TextStyle(color: color);
    final lineChar = character.isNotEmpty ? character[0] : '│';

    for (int x = 0; x < thickness && x < width; x++) {
      for (int y = 0; y < size!.height; y++) {
        context.buffer.writeStyled(
          offset.x + x,
          offset.y + y,
          lineChar,
          textStyle,
        );
      }
    }
  }
}