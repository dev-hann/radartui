import 'dart:async';
import 'package:radartui/radartui.dart';

class RadioExample extends StatefulWidget {
  const RadioExample();

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String _selectedValue = 'option1';
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
                '◉ Radio Button Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Radio<String>(
                value: 'option1',
                groupValue: _selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value ?? 'option1';
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Option 1'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'option2',
                groupValue: _selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value ?? 'option1';
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Option 2'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'option3',
                groupValue: _selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value ?? 'option1';
                  });
                },
              ),
              const SizedBox(width: 2),
              const Text('Option 3'),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Selected: $_selectedValue',
            style: const TextStyle(color: Color.cyan),
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
