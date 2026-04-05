import '../../../radartui.dart';

/// Displays a transient overlay message at the bottom of the screen.
///
/// Shows the [message] for [duration] (default 2 seconds) using the [Overlay].
/// Optionally customize [backgroundColor] and [textColor].
class Toast {
  /// Shows a toast message via the [Overlay].
  ///
  /// The toast appears at the bottom of the screen and is automatically removed
  /// after [duration] elapses.
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 1,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            color: backgroundColor ?? Color.black,
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Color.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }
}
