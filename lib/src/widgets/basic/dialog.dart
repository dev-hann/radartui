import 'dart:async';
import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/foundation/edge_insets.dart';
import 'package:radartui/src/foundation/alignment.dart';
import 'package:radartui/src/foundation/box_constraints.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/widgets/basic/container.dart';
import 'package:radartui/src/widgets/basic/column.dart';
import 'package:radartui/src/widgets/basic/row.dart';
import 'package:radartui/src/widgets/basic/center.dart';
import 'package:radartui/src/widgets/basic/text.dart';
import 'package:radartui/src/widgets/basic/padding.dart';
import 'package:radartui/src/scheduler/binding.dart';

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
  void initState() {
    super.initState();
    // TODO: Subscribe to keyboard events for Escape key handling
  }

  @override
  void dispose() {
    // TODO: Unsubscribe from keyboard events
    super.dispose();
  }

  void _handleEscapeKey() {
    if (widget.barrierDismissible) {
      // TODO: Close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget dialogContent = widget.child;

    // Wrap with title if provided
    if (widget.title != null) {
      final titleWidget = Text(
        widget.title!,
        style: widget.titleStyle ?? const TextStyle(color: Colors.white),
      );
      
      final contentWithTitle = Column(
        children: [
          titleWidget,
          dialogContent,
        ],
      );
      dialogContent = contentWithTitle;
    }

    // Add actions if provided
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      final actionsRow = Row(children: widget.actions!);
      dialogContent = Column(
        children: [
          dialogContent,
          actionsRow,
        ],
      );
    }

    // Apply padding
    final padding = widget.padding ?? const EdgeInsets.all(1);
    dialogContent = Padding(
      padding: padding,
      child: dialogContent,
    );

    // Apply background and constraints
    dialogContent = Container(
      color: widget.backgroundColor,
      width: widget.constraints?.maxWidth,
      height: widget.constraints?.maxHeight,
      child: dialogContent,
    );

    // Center the dialog based on alignment
    if (widget.alignment == Alignment.center) {
      dialogContent = Center(child: dialogContent);
    }

    return dialogContent;
  }
}

// Global variable to track current dialog
Dialog? _currentDialog;
void Function()? _currentDialogCompleter;

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

  // Store current dialog for overlay management
  _currentDialog = dialog;
  
  // Add to overlay system
  SchedulerBinding.instance.addOverlay(dialog);
  
  // Return a Future that completes when dialog is closed
  final completer = Completer<T?>();
  _currentDialogCompleter = () => completer.complete(null);
  
  return completer.future;
}

void dismissDialog<T>([T? result]) {
  if (_currentDialog != null) {
    SchedulerBinding.instance.removeOverlay(_currentDialog!);
    _currentDialog = null;
    
    if (_currentDialogCompleter != null) {
      _currentDialogCompleter!();
      _currentDialogCompleter = null;
    }
  }
}