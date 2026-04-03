import '../../../radartui.dart';

class ShortcutActivator {
  const ShortcutActivator({required this.key, this.ctrl, this.alt, this.shift});

  final KeyCode key;
  final bool? ctrl;
  final bool? alt;
  final bool? shift;

  bool accepts(KeyEvent event) {
    if (event.code != key) {
      if (key == KeyCode.char) {
        if (event.code != KeyCode.char) return false;
      } else {
        return false;
      }
    }

    if (ctrl != null && ctrl != event.isCtrlPressed) return false;
    if (alt != null && alt != event.isAltPressed) return false;
    if (shift != null && shift != event.isShiftPressed) return false;

    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortcutActivator &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          ctrl == other.ctrl &&
          alt == other.alt &&
          shift == other.shift;

  @override
  int get hashCode => Object.hash(key, ctrl, alt, shift);

  @override
  String toString() {
    final parts = <String>[];
    if (ctrl == true) parts.add('Ctrl');
    if (alt == true) parts.add('Alt');
    if (shift == true) parts.add('Shift');
    parts.add(key.name);
    return 'ShortcutActivator(${parts.join('+')})';
  }
}

class Intent {
  const Intent();
}

class Action<T extends Intent> {
  const Action();

  Object? invoke(T intent) {
    return null;
  }
}

class CallbackAction extends Action<Intent> {
  CallbackAction({required this.onInvoke});

  final Object? Function(Intent) onInvoke;

  @override
  Object? invoke(Intent intent) {
    return onInvoke(intent);
  }
}

class ActionDispatcher {
  const ActionDispatcher();

  Object? invokeAction(Action action, Intent intent) {
    return action.invoke(intent);
  }
}

class _ShortcutsScope extends InheritedWidget {
  const _ShortcutsScope({required this.shortcuts, required super.child});

  final Map<ShortcutActivator, Intent> shortcuts;

  @override
  bool updateShouldNotify(_ShortcutsScope oldWidget) {
    if (shortcuts.length != oldWidget.shortcuts.length) return true;
    for (final key in shortcuts.keys) {
      if (!oldWidget.shortcuts.containsKey(key)) return true;
      if (shortcuts[key] != oldWidget.shortcuts[key]) return true;
    }
    return false;
  }
}

class Shortcuts extends StatefulWidget {
  const Shortcuts({super.key, required this.shortcuts, required this.child});

  final Map<ShortcutActivator, Intent> shortcuts;
  final Widget child;

  static Map<ShortcutActivator, Intent>? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ShortcutsScope>();
    return scope?.shortcuts;
  }

  static Intent? lookup(KeyEvent event, BuildContext context) {
    final element = context as Element;
    Element? current = element.parent;
    while (current != null) {
      if (current.widget is _ShortcutsScope) {
        final scope = current.widget as _ShortcutsScope;
        for (final entry in scope.shortcuts.entries) {
          if (entry.key.accepts(event)) {
            return entry.value;
          }
        }
      }
      current = current.parent;
    }
    return null;
  }

  @override
  State<Shortcuts> createState() => _ShortcutsState();
}

class _ShortcutsState extends State<Shortcuts> {
  @override
  Widget build(BuildContext context) {
    return _ShortcutsScope(shortcuts: widget.shortcuts, child: widget.child);
  }
}

class _ActionsScope extends InheritedWidget {
  const _ActionsScope({required this.actions, required super.child});

  final Map<Type, Action> actions;

  @override
  bool updateShouldNotify(_ActionsScope oldWidget) {
    if (actions.length != oldWidget.actions.length) return true;
    for (final key in actions.keys) {
      if (!oldWidget.actions.containsKey(key)) return true;
      if (actions[key] != oldWidget.actions[key]) return true;
    }
    return false;
  }
}

class Actions extends StatefulWidget {
  const Actions({super.key, required this.actions, required this.child});

  final Map<Type, Action> actions;
  final Widget child;

  static Map<Type, Action>? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ActionsScope>();
    return scope?.actions;
  }

  static Action? lookup<T extends Intent>(BuildContext context) {
    final element = context as Element;
    Element? current = element.parent;
    while (current != null) {
      if (current.widget is _ActionsScope) {
        final scope = current.widget as _ActionsScope;
        final action = scope.actions[T];
        if (action != null) return action;
      }
      current = current.parent;
    }
    return null;
  }

  static Action? lookupByType(Type intentType, BuildContext context) {
    final element = context as Element;
    Element? current = element.parent;
    while (current != null) {
      if (current.widget is _ActionsScope) {
        final scope = current.widget as _ActionsScope;
        final action = scope.actions[intentType];
        if (action != null) return action;
      }
      current = current.parent;
    }
    return null;
  }

  static Object? invoke(BuildContext context, Intent intent) {
    final action = lookupByType(intent.runtimeType, context);
    if (action == null) return null;
    return const ActionDispatcher().invokeAction(action, intent);
  }

  @override
  State<Actions> createState() => _ActionsState();
}

class _ActionsState extends State<Actions> {
  @override
  Widget build(BuildContext context) {
    return _ActionsScope(actions: widget.actions, child: widget.child);
  }
}

class ShortcutActionsHandler extends StatefulWidget {
  const ShortcutActionsHandler({super.key, required this.child});

  final Widget child;

  @override
  State<ShortcutActionsHandler> createState() => _ShortcutActionsHandlerState();
}

class _ShortcutActionsHandlerState extends State<ShortcutActionsHandler> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    final intent = Shortcuts.lookup(event, context);
    if (intent != null) {
      Actions.invoke(context, intent);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }
}
