import 'dart:async';
import '../../../radartui.dart';

class Dialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;
  final Color backgroundColor;

  const Dialog({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.padding,
    this.titleStyle,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> columnChildren = <Widget>[];

    if (title != null) {
      columnChildren.add(
        Text(
          title!,
          style: titleStyle ??
              const TextStyle(color: Color.white, bold: true),
        ),
      );
      columnChildren.add(const Container(height: 1));
    }

    columnChildren.add(child);

    if (actions != null && actions!.isNotEmpty) {
      columnChildren.add(const Container(height: 1));

      final actionWidgets = <Widget>[];
      for (int i = 0; i < actions!.length; i++) {
        if (i > 0) {
          actionWidgets.add(const Container(width: 2));
        }
        actionWidgets.add(actions![i]);
      }
      columnChildren.add(Row(children: actionWidgets));
    }

    Widget dialogContent = Column(children: columnChildren);

    final effectivePadding = padding ?? const EdgeInsets.all(2);
    dialogContent = Padding(padding: effectivePadding, child: dialogContent);

    dialogContent = Container(
      color: backgroundColor,
      child: dialogContent,
    );

    return dialogContent;
  }
}

class ModalRoute<T> extends Route<T> {
  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Alignment alignment;

  ModalRoute({
    required this.builder,
    this.barrierDismissible = true,
    this.barrierColor,
    this.alignment = Alignment.center,
    super.settings,
  });

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
