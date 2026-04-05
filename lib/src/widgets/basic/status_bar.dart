import '../../../radartui.dart';

/// A horizontal bar typically rendered at the bottom of the screen.
///
/// Displays [left], [center], and [right] widgets in a row with an optional
/// [backgroundColor] and [foregroundColor].
class StatusBar extends StatelessWidget {
  /// Creates a [StatusBar] with optional [left], [center], and [right] widgets.
  const StatusBar({
    super.key,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 1,
  });

  /// The widget displayed on the left side of the bar.
  final Widget? left;

  /// The widget displayed in the center of the bar.
  final Widget? center;

  /// The widget displayed on the right side of the bar.
  final Widget? right;

  /// The background color of the bar.
  final Color? backgroundColor;

  /// The foreground (text) color applied to children.
  final Color? foregroundColor;

  /// The height of the bar in terminal rows.
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
