import 'dart:async';
import 'package:radartui/radartui.dart';

class TextFieldExample extends StatefulWidget {
  const TextFieldExample();

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  String _inputValue = '';
  String _multilineValue = '';
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
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
    _controller1.dispose();
    _controller2.dispose();
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
                '⌨️ TextField Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Single-line input:',
            style: TextStyle(color: Color.cyan),
          ),
          TextField(
            controller: _controller1,
            placeholder: 'Enter text here...',
            onChanged: (String value) {
              setState(() {
                _inputValue = value;
              });
            },
          ),
          const SizedBox(height: 2),
          const Text(
            'Multiline input:',
            style: TextStyle(color: Color.cyan),
          ),
          TextField(
            controller: _controller2,
            placeholder: 'Enter multiple lines...',
            onChanged: (String value) {
              setState(() {
                _multilineValue = value;
              });
            },
          ),
          const SizedBox(height: 2),
          Text(
            'Input: $_inputValue',
            style: const TextStyle(color: Color.white),
          ),
          Text(
            'Multiline: $_multilineValue',
            style: const TextStyle(color: Color.white),
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
