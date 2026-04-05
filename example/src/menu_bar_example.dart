import 'dart:async';
import 'package:radartui/radartui.dart';

class MenuBarExample extends StatefulWidget {
  const MenuBarExample();

  @override
  State<MenuBarExample> createState() => _MenuBarExampleState();
}

class _MenuBarExampleState extends State<MenuBarExample> {
  String _lastAction = 'None';
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
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
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '☰ MenuBar Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          MenuBar(
            items: [
              MenuBarItem(
                label: 'File',
                children: [
                  MenuItem(
                    label: 'New',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'File > New';
                      });
                    },
                  ),
                  MenuItem(
                    label: 'Open',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'File > Open';
                      });
                    },
                  ),
                  MenuItem(
                    label: 'Save',
                    shortcut: 'Ctrl+S',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'File > Save';
                      });
                    },
                  ),
                  MenuItem(
                    label: 'Exit',
                    onSelected: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              MenuBarItem(
                label: 'Edit',
                children: [
                  MenuItem(
                    label: 'Cut',
                    shortcut: 'Ctrl+X',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'Edit > Cut';
                      });
                    },
                  ),
                  MenuItem(
                    label: 'Copy',
                    shortcut: 'Ctrl+C',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'Edit > Copy';
                      });
                    },
                  ),
                  MenuItem(
                    label: 'Paste',
                    shortcut: 'Ctrl+V',
                    onSelected: () {
                      setState(() {
                        _lastAction = 'Edit > Paste';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 1),
          Container(
            width: 44,
            height: 5,
            color: Color.brightBlack,
            child: Column(
              children: [
                const SizedBox(height: 1),
                const Text(
                  'Last action:',
                  style: TextStyle(color: Color.white),
                ),
                Text(
                  _lastAction,
                  style: const TextStyle(color: Color.green, bold: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
