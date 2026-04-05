import 'dart:async';
import 'package:radartui/radartui.dart';

class ToggleExample extends StatefulWidget {
  const ToggleExample();

  @override
  State<ToggleExample> createState() => _ToggleExampleState();
}

class _ToggleExampleState extends State<ToggleExample> {
  bool _toggle1 = false;
  bool _toggle2 = true;
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
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '🔀 Toggle Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Toggle(
            value: _toggle1,
            onChanged: (bool value) {
              setState(() {
                _toggle1 = value;
              });
            },
            label: 'WiFi',
          ),
          const SizedBox(height: 1),
          Toggle(
            value: _toggle2,
            onChanged: (bool value) {
              setState(() {
                _toggle2 = value;
              });
            },
            label: 'Bluetooth',
          ),
          const SizedBox(height: 2),
          Text(
            'WiFi: ${_toggle1 ? "ON" : "OFF"}',
            style: TextStyle(color: _toggle1 ? Color.green : Color.red),
          ),
          Text(
            'Bluetooth: ${_toggle2 ? "ON" : "OFF"}',
            style: TextStyle(color: _toggle2 ? Color.green : Color.red),
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
