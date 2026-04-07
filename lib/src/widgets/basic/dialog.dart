import 'dart:async';
import '../../../radartui.dart';

/// A modal dialog with a title, message, and optional action buttons.
///
/// Use [showDialog] to display. Actions are laid out in a row at the bottom.
/// Pressing Escape dismisses the dialog.
class Dialog extends StatelessWidget {
  /// Creates a [Dialog] containing [child] with optional [title] and [actions].
  const Dialog({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.titleStyle,
    this.backgroundColor = Colors.white,
  });

  /// The content widget displayed in the dialog body.
  final Widget child;

  /// An optional title displayed above the content.
  final String? title;

  /// Optional action widgets displayed at the bottom of the dialog.
  final List<Widget>? actions;

  /// Padding around the dialog content.
  final EdgeInsets? padding;

  /// The text style for the [title].
  final TextStyle? titleStyle;

  /// The background color of the dialog card.
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[];

    if (title != null) {
      columnChildren.add(
        Text(
          title!,
          style: titleStyle ?? const TextStyle(color: Color.white, bold: true),
        ),
      );
      columnChildren.add(const Container(height: 1));
    }

    columnChildren.add(child);

    if (actions != null && actions!.isNotEmpty) {
      columnChildren.add(const Container(height: 1));
      columnChildren.add(_buildActionRow());
    }

    final effectivePadding = padding ?? const EdgeInsets.all(2);

    return Card(
      color: backgroundColor,
      padding: effectivePadding,
      child: Column(children: columnChildren),
    );
  }

  Widget _buildActionRow() {
    final actionWidgets = <Widget>[];
    final int actionCount = actions!.length;
    for (int i = 0; i < actionCount; i++) {
      if (i > 0) {
        actionWidgets.add(const Container(width: 2));
      }
      actionWidgets.add(actions![i]);
    }
    return Row(children: actionWidgets);
  }
}

/// A route that displays a modal dialog with a barrier overlay.
class ModalRoute<T> extends Route<T> {
  /// Creates a [ModalRoute] that displays the widget built by [builder].
  ModalRoute({
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor,
    this.alignment = Alignment.center,
    super.settings,
  });

  /// Builds the dialog widget to display.
  final WidgetBuilder builder;

  /// Whether tapping outside the dialog dismisses it.
  final bool barrierDismissible;

  /// The color of the barrier behind the dialog.
  final Color? barrierColor;

  /// The alignment of the dialog within the screen.
  final Alignment alignment;

  @override
  bool get fullScreenRender => false;

  @override
  void didPush() {
    super.didPush();
    FocusManager.instance.pushDialogScope();
  }

  @override
  void didPop(T? result) {
    FocusManager.instance.popDialogScope();
    super.didPop(result);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _ModalBarrier(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      alignment: alignment,
      child: Builder(builder: _buildValidatedDialog),
    );
  }

  Widget _buildValidatedDialog(BuildContext context) {
    final dialog = builder(context);
    if (dialog is! Dialog) {
      throw ArgumentError(
        'The widget returned by builder must be a Dialog',
      );
    }
    return dialog;
  }
}

/// Displays a modal [Dialog] above the current route.
///
/// Returns a `Future` that completes with the result when the dialog is dismissed.
/// Pressing Escape dismisses with `null`.
Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  Alignment alignment = Alignment.center,
}) {
  return Navigator.push<T>(
    context,
    ModalRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      alignment: alignment,
    ),
  );
}

class _ModalBarrier extends StatefulWidget {
  const _ModalBarrier({
    required this.child,
    required this.barrierDismissible,
    this.barrierColor,
    this.alignment = Alignment.center,
  });
  final Widget child;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Alignment alignment;

  @override
  State<_ModalBarrier> createState() => _ModalBarrierState();
}

class _ModalBarrierState extends State<_ModalBarrier> {
  StreamSubscription<KeyEvent>? _keySubscription;

  @override
  void initState() {
    super.initState();
    _setupKeyboardListener();
  }

  @override
  void dispose() {
    _teardownKeyboardListener();
    super.dispose();
  }

  void _setupKeyboardListener() {
    _keySubscription = WidgetsBinding.instance.keyboard.keyEvents.listen(
      _handleKeyEvent,
    );
  }

  void _teardownKeyboardListener() {
    _keySubscription?.cancel();
    _keySubscription = null;
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape && widget.barrierDismissible) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: widget.child);

    if (widget.barrierColor != null) {
      content = Container(
        width: WidgetsBinding.instance.terminal.width,
        height: WidgetsBinding.instance.terminal.height,
        color: widget.barrierColor,
        child: content,
      );
    }

    return content;
  }
}
