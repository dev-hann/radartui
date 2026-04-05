import '../../../radartui.dart';

/// A horizontal bar typically rendered at the bottom of the screen.
///
/// Displays [left], [center], and [right] widgets in a row with an optional
/// [backgroundColor] and [foregroundColor].
class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 1,
  });

  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final int height;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (left != null) {
      children.add(left!);
    }
    children.add(const Spacer());
    if (center != null) {
      children.add(center!);
    }
    children.add(const Spacer());
    if (right != null) {
      children.add(right!);
    }

    Widget row = Row(children: children);

    if (foregroundColor != null) {
      row = DefaultTextStyle(
        style: TextStyle(color: foregroundColor),
        child: row,
      );
    }

    return Container(
      height: height,
      color: backgroundColor ?? Color.blue,
      child: row,
    );
  }
}
