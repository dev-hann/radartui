import 'package:radartui/radartui.dart';

class SaveIntent extends Intent {
  const SaveIntent();
}

class QuitIntent extends Intent {
  const QuitIntent();
}

class CopyIntent extends Intent {
  const CopyIntent();
}

class PasteIntent extends Intent {
  const PasteIntent();
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class HelpIntent extends Intent {
  const HelpIntent();
}

class ShortcutsExample extends StatefulWidget {
  const ShortcutsExample();

  @override
  State<ShortcutsExample> createState() => _ShortcutsExampleState();
}

class _ShortcutsExampleState extends State<ShortcutsExample> {
  String _status = 'Press a shortcut key';
  int _saveCount = 0;
  int _copyCount = 0;
  int _pasteCount = 0;
  String _clipboard = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = _handleKeyEvent;
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

  void _save() {
    setState(() {
      _saveCount++;
      _status = 'Saved! (save #$_saveCount)';
    });
  }

  void _quit() {
    Navigator.of(context).pop();
  }

  void _copy() {
    setState(() {
      _copyCount++;
      _clipboard = 'Item #$_copyCount';
      _status = 'Copied: $_clipboard';
    });
  }

  void _paste() {
    setState(() {
      _pasteCount++;
      _status = 'Pasted: $_clipboard (paste #$_pasteCount)';
    });
  }

  void _undo() {
    setState(() {
      _status = 'Undo!';
    });
  }

  void _redo() {
    setState(() {
      _status = 'Redo!';
    });
  }

  void _help() {
    setState(() {
      _status = 'Help: Available shortcuts are listed below';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const ShortcutActivator(
          key: KeyCode.char,
          ctrl: true,
          shift: null,
          alt: null,
        ): const SaveIntent(),
        const ShortcutActivator(key: KeyCode.escape): const QuitIntent(),
        const ShortcutActivator(key: KeyCode.f1): const HelpIntent(),
      },
      child: Actions(
        actions: {
          SaveIntent: CallbackAction(onInvoke: (_) => _save()),
          QuitIntent: CallbackAction(onInvoke: (_) => _quit()),
          HelpIntent: CallbackAction(onInvoke: (_) => _help()),
        },
        child: Shortcuts(
          shortcuts: {
            const ShortcutActivator(key: KeyCode.char, ctrl: true):
                const CopyIntent(),
            const ShortcutActivator(key: KeyCode.char, alt: true):
                const PasteIntent(),
            const ShortcutActivator(key: KeyCode.char, ctrl: true, shift: true):
                const UndoIntent(),
            const ShortcutActivator(key: KeyCode.char, ctrl: true, alt: true):
                const RedoIntent(),
          },
          child: Actions(
            actions: {
              CopyIntent: CallbackAction(onInvoke: (_) => _copy()),
              PasteIntent: CallbackAction(onInvoke: (_) => _paste()),
              UndoIntent: CallbackAction(onInvoke: (_) => _undo()),
              RedoIntent: CallbackAction(onInvoke: (_) => _redo()),
            },
            child: Focus(
              focusNode: _focusNode,
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    const Text(
                      'Shortcuts & Actions Demo',
                      style: TextStyle(bold: true, color: Color.cyan),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      color: Color.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 2,
                      ),
                      child: Text(
                        _status,
                        style: const TextStyle(color: Color.white),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Available Shortcuts:',
                      style: TextStyle(bold: true, color: Color.yellow),
                    ),
                    const SizedBox(height: 1),
                    const Text('Ctrl+S  - Save'),
                    const Text('Ctrl+C  - Copy'),
                    const Text('Alt+P   - Paste'),
                    const Text('Ctrl+Shift+U - Undo'),
                    const Text('Ctrl+Alt+R  - Redo'),
                    const Text('F1      - Help'),
                    const Text('ESC     - Quit'),
                    const SizedBox(height: 2),
                    const Text(
                      'Press any shortcut to test!',
                      style: TextStyle(italic: true, color: Color.brightBlack),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Saves: $_saveCount | Copies: $_copyCount | Pastes: $_pasteCount',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
