import 'dart:async';
import 'package:radartui/radartui.dart';

class _SaveIntent extends Intent {
  const _SaveIntent();
}

class _CopyIntent extends Intent {
  const _CopyIntent();
}

class _DeleteIntent extends Intent {
  const _DeleteIntent();
}

class ShortcutsExample extends StatefulWidget {
  const ShortcutsExample();

  @override
  State<ShortcutsExample> createState() => _ShortcutsExampleState();
}

class _ShortcutsExampleState extends State<ShortcutsExample> {
  String _lastAction = 'No shortcut triggered yet';
  int _saveCount = 0;
  int _copyCount = 0;
  int _deleteCount = 0;
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Shortcuts(
        shortcuts: {
          const ShortcutActivator(key: KeyCode.char, ctrl: true):
              const _SaveIntent(),
          const ShortcutActivator(key: KeyCode.char, alt: true):
              const _CopyIntent(),
          const ShortcutActivator(key: KeyCode.delete): const _DeleteIntent(),
        },
        child: Actions(
          actions: {
            _SaveIntent: CallbackAction(onInvoke: (_) {
              setState(() {
                _saveCount++;
                _lastAction = 'Save triggered (Ctrl+S) - count: $_saveCount';
              });
              return null;
            }),
            _CopyIntent: CallbackAction(onInvoke: (_) {
              setState(() {
                _copyCount++;
                _lastAction = 'Copy triggered (Alt+C) - count: $_copyCount';
              });
              return null;
            }),
            _DeleteIntent: CallbackAction(onInvoke: (_) {
              setState(() {
                _deleteCount++;
                _lastAction = 'Delete triggered - count: $_deleteCount';
              });
              return null;
            }),
          },
          child: ShortcutActionsHandler(
            child: Column(
              children: [
                const Container(
                  width: 50,
                  height: 3,
                  color: Color.blue,
                  child: Center(
                    child: Text(
                      '⌨️ Shortcuts & Actions Example',
                      style: TextStyle(color: Color.white, bold: true),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Available shortcuts:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                const Text('Ctrl+S  - Save'),
                const Text('Alt+C   - Copy'),
                const Text('Delete  - Delete'),
                const SizedBox(height: 2),
                Container(
                  width: 45,
                  color: Color.brightBlack,
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    _lastAction,
                    style: const TextStyle(color: Color.yellow),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Press ESC to return to main menu',
                  style: TextStyle(color: Color.yellow, italic: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
