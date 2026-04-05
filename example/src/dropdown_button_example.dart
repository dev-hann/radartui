import 'dart:async';
import 'package:radartui/radartui.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample();

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? _selectedFruit;
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
                '▼ DropdownButton Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          DropdownButton<String>(
            value: _selectedFruit,
            hint: 'Select a fruit',
            items: const [
              DropdownMenuItem(value: 'apple', label: 'Apple'),
              DropdownMenuItem(value: 'banana', label: 'Banana'),
              DropdownMenuItem(value: 'cherry', label: 'Cherry'),
              DropdownMenuItem(value: 'durian', label: 'Durian'),
            ],
            onChanged: (String? value) {
              setState(() {
                _selectedFruit = value;
              });
            },
          ),
          const SizedBox(height: 2),
          Text(
            'Selected: ${_selectedFruit ?? "None"}',
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
