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
  Widget build(BuildContext context) {
    Widget dialogContent = widget.child;

    // Wrap with title if provided
    if (widget.title != null) {
      final titleWidget = Text(
        widget.title!,
        style: widget.titleStyle ?? const TextStyle(color: Colors.black),
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

    // Apply background and size constraints
    dialogContent = Container(
      color: widget.backgroundColor,
      width: widget.constraints?.maxWidth.toInt(),
      height: widget.constraints?.maxHeight.toInt(),
      child: dialogContent,
    );

    // Center the dialog based on alignment
    if (widget.alignment == Alignment.center) {
      dialogContent = Center(child: dialogContent);
    }

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
    onDismiss: () => dismissDialog<T>(),
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
    final route = entry.value as _DialogRoute<T>;
    
    SchedulerBinding.instance.removeOverlay(dialog);
    _dialogRoutes.remove(dialog);
    
    route.completer.complete(result);
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
  @override
  void initState() {
    super.initState();
    // TODO: Subscribe to keyboard events for Escape key handling
    _setupKeyboardListener();
  }

  @override
  void dispose() {
    _teardownKeyboardListener();
    super.dispose();
  }
  
  void _setupKeyboardListener() {
    // TODO: Implement keyboard event subscription
    // This would require integration with the terminal input system
  }
  
  void _teardownKeyboardListener() {
    // TODO: Implement keyboard event cleanup
  }

  void _handleEscapeKey() {
    if (widget.barrierDismissible) {
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.dialog;
    
    // Add barrier color background if specified
    if (widget.barrierColor != null) {
      content = Container(
        color: widget.barrierColor,
        child: content,
      );
    }
    
    return content;
  }
}