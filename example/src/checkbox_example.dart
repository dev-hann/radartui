import 'dart:async';
import 'package:radartui/radartui.dart';

class CheckboxExample extends StatefulWidget {
  const CheckboxExample();

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool _option1 = false;
  bool _option2 = true;
  bool _option3 = false;
  bool _option4 = true;
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
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checkbox Widget Example',
            style: TextStyle(color: Color.brightCyan, bold: true),
          ),
          const SizedBox(height: 1),
          const Text(
            'Interactive Checkboxes:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Row(
            children: [
              Checkbox(
                value: _option1,
                onChanged: (value) {
                  setState(() {
                    _option1 = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 2),
              Text('Enable notifications ${_option1.toString()}'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _option2,
                onChanged: (value) {
                  setState(() {
                    _option2 = value ?? false;
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Auto-save documents'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _option3,
                onChanged: (value) {
                  setState(() {
                    _option3 = value ?? false;
                  });
                },
                activeColor: Color.green,
              ),
              const SizedBox(width: 2),
              const Text('Green themed checkbox'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _option4,
                onChanged: (value) {
                  setState(() {
                    _option4 = value ?? false;
                  });
                },
                activeColor: Color.red,
                checkColor: Color.yellow,
              ),
              const SizedBox(width: 2),
              const Text('Custom colors checkbox'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Disabled Checkboxes:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          const Row(
            children: [
              Checkbox(value: false, onChanged: null),
              SizedBox(width: 2),
              Text('Disabled unchecked'),
            ],
          ),
          const Row(
            children: [
              Checkbox(value: true, onChanged: null),
              SizedBox(width: 2),
              Text('Disabled checked'),
            ],
          ),
          const SizedBox(height: 1),
          const Text(
            'Current Selection Status:',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          Text(
            'Notifications: ${_option1 ? "ON" : "OFF"}',
            style: TextStyle(color: _option1 ? Color.green : Color.red),
          ),
          Text(
            'Auto-save: ${_option2 ? "ON" : "OFF"}',
            style: TextStyle(color: _option2 ? Color.green : Color.red),
          ),
        ],
      ),
    );
  }
}
