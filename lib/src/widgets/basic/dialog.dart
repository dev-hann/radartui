import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/foundation/alignment.dart';
import 'package:radartui/src/foundation/box_constraints.dart';
import 'package:radartui/src/widgets/basic/builder.dart';

class Dialog extends StatefulWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Alignment alignment;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final BoxConstraints? constraints;

  const Dialog({
    required this.child,
    this.title,
    this.actions,
    this.barrierDismissible = true,
    this.barrierColor,
    this.alignment = Alignment.center,
    this.padding,
    this.titleStyle,
    this.backgroundColor = Colors.white,
    this.constraints,
  });

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[];

    // Add title if provided
    if (widget.title != null) {
      columnChildren.add(
        Text(
          widget.title!,
          style:
              widget.titleStyle ??
              const TextStyle(color: Color.white, bold: true),
        ),
      );
      // Add spacing after title
      columnChildren.add(const Container(height: 1) as Widget);
    }

    // Add main content
    columnChildren.add(widget.child);

    // Add actions if provided
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      // Add spacing before actions
      columnChildren.add(const Container(height: 1) as Widget);

      // Create actions row with proper spacing
      final actionWidgets = <Widget>[];
      for (int i = 0; i < widget.actions!.length; i++) {
        if (i > 0) {
          actionWidgets.add(
            const Container(width: 2) as Widget,
          ); // Space between buttons
        }
        actionWidgets.add(widget.actions![i]);
      }
      columnChildren.add(Row(children: actionWidgets));
    }

    // Build the main dialog content
    Widget dialogContent = Column(children: columnChildren);

    // Apply padding
    final padding = widget.padding ?? const EdgeInsets.all(2);
    dialogContent = Padding(padding: padding, child: dialogContent);

    // Apply background and size constraints
    dialogContent = Container(
      color: widget.backgroundColor ?? Color.black,
      width: widget.constraints?.maxWidth.toInt(),
      height: widget.constraints?.maxHeight.toInt(),
      child: dialogContent,
    );

    return dialogContent;
  }
}

// Modal route for Navigator-based dialog management
class ModalRoute<T> extends Route {
  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Alignment alignment;

  const ModalRoute({
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor,
    this.alignment = Alignment.center,
    super.settings,
  });

  @override
  bool get fullScreenRender => false;

  @override
  Widget buildPage(BuildContext context) {
    return _ModalBarrier(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      alignment: alignment,
      child: Builder(
        builder: (BuildContext context) {
          final dialog = builder(context);
          if (dialog is! Dialog) {
            throw ArgumentError(
              'The widget returned by builder must be a Dialog',
            );
          }
          return dialog;
        },
      ),
    );
  }
}

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

// Modal barrier widget to handle background and keyboard events
class _ModalBarrier extends StatefulWidget {
  final Widget child;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Alignment alignment;

  const _ModalBarrier({
    required this.child,
    required this.barrierDismissible,
    this.barrierColor,
    this.alignment = Alignment.center,
  });

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
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen(
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

    // Create modal barrier that fills the entire screen
    if (widget.barrierColor != null) {
      content = Container(
        width: SchedulerBinding.instance.terminal.width,
        height: SchedulerBinding.instance.terminal.height,
        color: widget.barrierColor,
        child: content,
      );
    }

    return content;
  }
}
