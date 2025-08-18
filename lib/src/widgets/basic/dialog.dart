import 'dart:async';
import '../../foundation/color.dart';
import '../../foundation/edge_insets.dart';
import '../../foundation/alignment.dart';
import '../../foundation/box_constraints.dart';
import '../framework.dart';
import 'container.dart';
import 'column.dart';
import 'row.dart';
import 'center.dart';
import 'text.dart';
import 'padding.dart';
import '../focus_manager.dart';
import '../../scheduler/binding.dart';
import '../../services/key_parser.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

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
            )
            as Widget,
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
      columnChildren.add(Row(children: actionWidgets) as Widget);
    }

    // Build the main dialog content
    Widget dialogContent = Column(children: columnChildren) as Widget;

    // Apply padding
    final padding = widget.padding ?? const EdgeInsets.all(2);
    dialogContent = Padding(padding: padding, child: dialogContent) as Widget;

    // Apply background and size constraints
    dialogContent =
        Container(
              color: widget.backgroundColor ?? Color.black,
              width: widget.constraints?.maxWidth.toInt(),
              height: widget.constraints?.maxHeight.toInt(),
              child: dialogContent,
            )
            as Widget;

    return dialogContent;
  }
}

// Dialog route for overlay management
class _DialogRoute<T> {
  final _DialogWrapper dialog;
  final Completer<T?> completer;
  final bool barrierDismissible;
  final Color? barrierColor;

  _DialogRoute({
    required this.dialog,
    required this.completer,
    required this.barrierDismissible,
    this.barrierColor,
  });
}

// Global registry for dialog management
final Map<_DialogWrapper, _DialogRoute> _dialogRoutes = {};

Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  Alignment alignment = Alignment.center,
}) {
  final dialog = builder(context);

  if (dialog is! Dialog) {
    throw ArgumentError('The widget returned by builder must be a Dialog');
  }

  // Create enhanced dialog with barrier
  final enhancedDialog = _DialogWrapper(
    dialog: dialog,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    onDismiss: () => dismissTopDialog(),
  );

  // Add to overlay system
  SchedulerBinding.instance.addOverlay(enhancedDialog);

  // Create route for management
  final completer = Completer<T?>();
  final route = _DialogRoute<T>(
    dialog: enhancedDialog,
    completer: completer,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  );
  _dialogRoutes[enhancedDialog] = route;

  return completer.future;
}

void dismissDialog<T>([T? result]) {
  if (_dialogRoutes.isNotEmpty) {
    final entry = _dialogRoutes.entries.last;
    final dialog = entry.key;
    final route = entry.value;

    // Safely cast and check if the route matches the expected type
    if (route is _DialogRoute<T>) {
      SchedulerBinding.instance.removeOverlay(dialog);
      _dialogRoutes.remove(dialog);

      if (!route.completer.isCompleted) {
        route.completer.complete(result);
      }
    } else {
      // Fallback: remove the dialog but complete with null result
      SchedulerBinding.instance.removeOverlay(dialog);
      _dialogRoutes.remove(dialog);

      if (route.completer is Completer<T?> && !route.completer.isCompleted) {
        (route.completer as Completer<T?>).complete(result);
      }
    }
  }
}

// Helper function to dismiss the topmost dialog without type constraints
void dismissTopDialog() {
  if (_dialogRoutes.isNotEmpty) {
    final entry = _dialogRoutes.entries.last;
    final dialog = entry.key;
    final route = entry.value;

    SchedulerBinding.instance.removeOverlay(dialog);
    _dialogRoutes.remove(dialog);

    if (!route.completer.isCompleted) {
      route.completer.complete(null);
    }
  }
}

// Wrapper widget to handle barriers and keyboard events
class _DialogWrapper extends StatefulWidget {
  final Dialog dialog;
  final bool barrierDismissible;
  final Color? barrierColor;
  final VoidCallback onDismiss;

  const _DialogWrapper({
    required this.dialog,
    required this.barrierDismissible,
    this.barrierColor,
    required this.onDismiss,
  });

  @override
  State<_DialogWrapper> createState() => _DialogWrapperState();
}

class _DialogWrapperState extends State<_DialogWrapper> {
  StreamSubscription<KeyEvent>? _keySubscription;

  @override
  void initState() {
    super.initState();
    _setupDialogFocus();
    _setupKeyboardListener();
  }

  @override
  void dispose() {
    _restorePreviousFocus();
    _teardownKeyboardListener();
    super.dispose();
  }

  void _setupDialogFocus() {
    FocusManager.instance.createNewScope();
  }

  void _restorePreviousFocus() {
    FocusManager.instance.createNewScope();
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
    if (keyEvent.code == KeyCode.escape) {
      _handleEscapeKey();
    }
  }

  void _handleEscapeKey() {
    if (widget.barrierDismissible) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pure UI rendering - no focus logic here
    Widget content = widget.dialog as Widget;

    // Create modal barrier that fills the entire screen
    if (widget.barrierColor != null) {
      // Full-screen barrier with dialog centered on top
      content =
          Container(
                width: SchedulerBinding.instance.terminal.width,
                height: SchedulerBinding.instance.terminal.height,
                color: widget.barrierColor,
                child: Center(child: content) as Widget,
              )
              as Widget;
    } else {
      // No barrier, just center the dialog
      content = Center(child: content) as Widget;
    }

    return content;
  }
}
