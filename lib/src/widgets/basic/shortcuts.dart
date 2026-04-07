import '../../../radartui.dart';

/// Represents a keyboard shortcut (key + optional modifiers).
///
/// Use with [Shortcuts] widget to bind actions to key combinations.
/// Example: `ShortcutActivator(key: KeyCode.s, ctrl: true)` for Ctrl+S.
class ShortcutActivator {
  /// Creates a [ShortcutActivator] for the given [key] with optional modifiers.
  const ShortcutActivator({required this.key, this.ctrl, this.alt, this.shift});

  /// The key code that triggers this shortcut.
  final KeyCode key;

  /// Whether the Ctrl modifier must be held.
  final bool? ctrl;

  /// Whether the Alt modifier must be held.
  final bool? alt;

  /// Whether the Shift modifier must be held.
  final bool? shift;

  /// Returns `true` if [event] matches this activator's key and modifiers.
  bool accepts(KeyEvent event) {
    if (event.code != key) return false;
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

/// An opaque object representing a user intent triggered by a shortcut.
class Intent {
  /// Creates an [Intent].
  const Intent();
}

/// An action that can be invoked in response to an [Intent].
class Action<T extends Intent> {
  /// Creates an [Action].
  const Action();

  /// Invokes this action with the given [intent].
  Object? invoke(T intent) {
    return null;
  }
}

/// An [Action] subclass that delegates invocation to a callback.
class CallbackAction extends Action<Intent> {
  /// Creates a [CallbackAction] that calls [onInvoke] when triggered.
  CallbackAction({required this.onInvoke});

  /// The callback to invoke when this action is triggered.
  final Object? Function(Intent) onInvoke;

  @override
  Object? invoke(Intent intent) {
    return onInvoke(intent);
  }
}

/// Dispatches [Action]s in response to [Intent]s.
class ActionDispatcher {
  /// Creates an [ActionDispatcher].
  const ActionDispatcher();

  /// Invokes [action] with [intent] and returns the result.
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

/// A widget that maps [ShortcutActivator]s to [Intent]s for its descendants.
///
/// Place [Shortcuts] above the widgets that should respond to key bindings.
/// Use [ShortcutActionsHandler] to connect shortcuts to actions.
class Shortcuts extends StatefulWidget {
  /// Creates a [Shortcuts] widget with the given [shortcuts] map.
  const Shortcuts({super.key, required this.shortcuts, required this.child});

  /// The map of keyboard shortcuts to intents.
  final Map<ShortcutActivator, Intent> shortcuts;

  /// The widget subtree that can trigger these shortcuts.
  final Widget child;

  /// Retrieves the nearest shortcut map from the widget tree.
  static Map<ShortcutActivator, Intent>? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ShortcutsScope>();
    return scope?.shortcuts;
  }

  /// Looks up the [Intent] for [event] by traversing ancestors.
  static Intent? lookup(KeyEvent event, BuildContext context) {
    final element = context as Element;
    Element? current = element.parent;
    while (current != null) {
      if (current.widget is _ShortcutsScope) {
        final match = _matchShortcut(
          event,
          current.widget as _ShortcutsScope,
        );
        if (match != null) return match;
      }
      current = current.parent;
    }
    return null;
  }

  static Intent? _matchShortcut(KeyEvent event, _ShortcutsScope scope) {
    for (final entry in scope.shortcuts.entries) {
      if (entry.key.accepts(event)) return entry.value;
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

/// A widget that maps [Intent] types to [Action]s for its descendants.
///
/// Place [Actions] above [ShortcutActionsHandler] so intents can be resolved
/// to concrete actions when a shortcut is triggered.
class Actions extends StatefulWidget {
  /// Creates an [Actions] widget with the given [actions] map.
  const Actions({super.key, required this.actions, required this.child});

  /// The map of intent types to actions.
  final Map<Type, Action> actions;

  /// The widget subtree that can invoke these actions.
  final Widget child;

  /// Retrieves the nearest action map from the widget tree.
  static Map<Type, Action>? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ActionsScope>();
    return scope?.actions;
  }

  /// Looks up the [Action] for intent type [T] by traversing ancestors.
  static Action? lookup<T extends Intent>(BuildContext context) {
    return lookupByType(T, context);
  }

  /// Looks up the [Action] for [intentType] by traversing ancestors.
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

  /// Invokes the action matching [intent]'s runtime type.
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

/// A widget that connects [Shortcuts] to [Actions] by listening for key events.
///
/// Must be a descendant of both [Shortcuts] and [Actions] widgets.
/// When a key matches a shortcut, the corresponding intent's action is invoked.
class ShortcutActionsHandler extends StatefulWidget {
  /// Creates a [ShortcutActionsHandler] that wraps [child].
  const ShortcutActionsHandler({super.key, required this.child});

  /// The widget subtree that receives shortcut handling.
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
