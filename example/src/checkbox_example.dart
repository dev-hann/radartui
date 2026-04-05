import 'dart:async';
import 'package:radartui/radartui.dart';

class CheckboxExample extends StatefulWidget {
  const CheckboxExample();

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _checked1 = false;
  bool _checked2 = true;
  bool _checked3 = false;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkbox Widget Example',
            style: TextStyle(color: Color.brightCyan, bold: true),
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Checkbox(
                value: _checked1,
                onChanged: (bool? value) {
                  setState(() {
                    _checked1 = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 1),
              const Text('Enable notifications'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _checked2,
                onChanged: (bool? value) {
                  setState(() {
                    _checked2 = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 1),
              const Text('Auto-save documents'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _checked3,
                onChanged: (bool? value) {
                  setState(() {
                    _checked3 = value ?? false;
                  });
                },
                activeColor: Color.green,
              ),
              const SizedBox(width: 1),
              const Text('Dark mode'),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            'Notifications: ${_checked1 ? "ON" : "OFF"}',
            style: TextStyle(color: _checked1 ? Color.green : Color.red),
          ),
          Text(
            'Auto-save: ${_checked2 ? "ON" : "OFF"}',
            style: TextStyle(color: _checked2 ? Color.green : Color.red),
          ),
          Text(
            'Dark mode: ${_checked3 ? "ON" : "OFF"}',
            style: TextStyle(color: _checked3 ? Color.green : Color.red),
          ),
          const SizedBox(height: 1),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
