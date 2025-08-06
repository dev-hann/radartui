import 'package:radartui/src/foundation/axis.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart'; // Added import for framework.dart

class Text extends RenderObjectWidget {
  final String data;
  const Text(this.data);
  @override
  RenderObjectElement createElement() => RenderObjectElement(this);
  @override
  RenderText createRenderObject(BuildContext context) => RenderText(data);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderText).text = data;
  }
}

class RenderText extends RenderBox {
  String text;
  RenderText(this.text);
  @override
  void performLayout(Constraints constraints) {
    size = Size(text.length, 1);
  }
  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < text.length; i++) {
      context.buffer.write(offset.x + i, offset.y, text[i]);
    }
  }
}

class Padding extends SingleChildRenderObjectWidget {
  final EdgeInsets padding;
  const Padding({required this.padding, required super.child});
  @override
  RenderPadding createRenderObject(BuildContext context) => RenderPadding(padding: padding);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderPadding).padding = padding;
  }
}

class RenderPadding extends RenderBox with ContainerRenderObjectMixin<RenderBox, ParentData> {
  EdgeInsets padding;
  RenderPadding({required this.padding});
  @override
  void performLayout(Constraints constraints) {
    if (children.isNotEmpty) {
      final child = children.first;
      child.layout((constraints as BoxConstraints).deflate(padding));
      size = Size(
        child.size!.width + padding.left + padding.right,
        child.size!.height + padding.top + padding.bottom,
      );
    } else {
      size = Size(padding.left + padding.right, padding.top + padding.bottom);
    }
  }
  @override
  void paint(PaintingContext context, Offset offset) {
    if (children.isNotEmpty) {
      context.paintChild(children.first, offset + Offset(padding.left, padding.top));
    }
  }
}

class Column extends Flex {
  const Column({required List<Widget> children}) : super(children: children, direction: Axis.vertical);
}

class Row extends Flex {
  const Row({required List<Widget> children}) : super(children: children, direction: Axis.horizontal);
}

abstract class Flex extends MultiChildRenderObjectWidget {
  final Axis direction;
  const Flex({required super.children, required this.direction});
  @override
  RenderFlex createRenderObject(BuildContext context) => RenderFlex(direction: direction);
  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as RenderFlex).direction = direction;
  }
}

class RenderFlex extends RenderBox with ContainerRenderObjectMixin<RenderBox, ParentData> {
  Axis direction;
  RenderFlex({required this.direction});

  @override
  void performLayout(Constraints constraints) {
    int main = 0, cross = 0;
    for (final child in children) {
      child.layout(constraints);
      if (direction == Axis.vertical) {
        main += child.size!.height;
        cross = cross > child.size!.width ? cross : child.size!.width;
      } else {
        main += child.size!.width;
        cross = cross > child.size!.height ? cross : child.size!.height;
      }
    }
    size = direction == Axis.vertical ? Size(cross, main) : Size(main, cross);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    int currentMain = 0;
    for (final child in children) {
      final childOffset = direction == Axis.vertical
        ? offset + Offset(0, currentMain)
        : offset + Offset(currentMain, 0);
      context.paintChild(child, childOffset);
      currentMain += direction == Axis.vertical ? child.size!.height : child.size!.width;
    }
  }
}