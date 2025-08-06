import 'package:radartui/widget/widget.dart';
import 'package:radartui/model/key.dart' as input_key;
import 'package:radartui/widget/render_object.dart';
import 'package:radartui/widget/render_object_widget.dart';
import 'package:radartui/widget/single_child_render_object_widget.dart';

typedef VoidCallback = void Function();
typedef KeyCallback = void Function(input_key.Key key);
typedef StringCallback = void Function(String value);

class GestureDetector extends SingleChildRenderObjectWidget {
  const GestureDetector({
    super.key,
    required super.child,
    this.onTap,
    this.onKey,
  });

  final VoidCallback? onTap;
  final KeyCallback? onKey;

  @override
  RenderObject createRenderObject() {
    return RenderGestureDetector(onTap: onTap, onKey: onKey);
  }

  @override
  void updateRenderObject(RenderObject renderObject) {
    (renderObject as RenderGestureDetector)
      ..onTap = onTap
      ..onKey = onKey;
  }

  @override
  void render(Canvas canvas, Rect rect) {
    child.render(canvas, rect);
  }

  @override
  int preferredHeight(int width) {
    return child.preferredHeight(width);
  }

  @override
  int preferredWidth(int height) {
    return child.preferredWidth(height);
  }
}

class RenderGestureDetector extends RenderObject {
  RenderGestureDetector({
    this.onTap,
    this.onKey,
  });

  VoidCallback? onTap;
  KeyCallback? onKey;

  @override
  void paint(Canvas canvas) {
    // GestureDetector doesn't paint anything itself, it just passes through its child
  }

  @override
  int preferredHeight(int width) {
    return 0; // Should be handled by the child
  }

  @override
  int preferredWidth(int height) {
    return 0; // Should be handled by the child
  }
}

// Flutter-like button with callbacks
class ElevatedButton extends StatefulWidget {
  const ElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<ElevatedButton> createState() => _ElevatedButtonState();
}

class _ElevatedButtonState extends State<ElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onKey: _handleKey,
      child: widget.child,
    );
  }

  void _handleKey(input_key.Key key) {
    if (key.label == '' || key.label == ' ') {
      // Visual feedback could be added here
    }
  }
}