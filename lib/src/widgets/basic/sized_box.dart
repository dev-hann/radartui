import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

class SizedBox extends RenderObjectWidget {
  final int width;
  final int height;
  final Widget? child;

  const SizedBox({this.width = 0, this.height = 0, this.child});
  const SizedBox.shrink({this.child}) : width = 0, height = 0;
  const SizedBox.square({required int dimension, this.child})
    : width = dimension,
      height = dimension;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderSizedBox createRenderObject(BuildContext context) =>
      RenderSizedBox(width, height);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final sizedBox = renderObject as RenderSizedBox;
    sizedBox.width = width;
    sizedBox.height = height;
  }
}

class RenderSizedBox extends RenderBox {
  int width;
  int height;

  RenderSizedBox(this.width, this.height);

  @override
  void performLayout(Constraints constraints) {
    size = Size(width, height);
    AppLogger.log('RenderSizedBox.performLayout: size=\$size');
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // SizedBox doesn't paint anything
  }
}
