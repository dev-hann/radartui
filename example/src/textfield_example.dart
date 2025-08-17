import 'package:radartui/radartui.dart';

class TextFieldExample extends StatefulWidget {
  const TextFieldExample();

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _submittedText = '';
  String _changedText = '';

  @override
  void initState() {
    super.initState();
    _controller1.text = 'Initial text';
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {
      _changedText = text;
    });
  }

  void _onTextSubmitted(String text) {
    setState(() {
      _submittedText = text;
    });
  }

  void _clearFields() {
    _controller1.clear();
    _controller2.clear();
    setState(() {
      _submittedText = '';
      _changedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 60,
            height: 3,
            color: Color.green,
            child: Center(
              child: Text(
                '📝 TextField Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const Text(
                  'Basic TextField with controller:',
                  style: TextStyle(color: Color.cyan),
                ),
                const SizedBox(height: 1),
                TextField(
                  controller: _controller1,
                  placeholder: 'Enter text here...',
                  style: const TextStyle(color: Color.white),
                  onChanged: _onTextChanged,
                  onSubmitted: _onTextSubmitted,
                ),
                const SizedBox(height: 2),
                const Text(
                  'TextField with max length (10):',
                  style: TextStyle(color: Color.cyan),
                ),
                const SizedBox(height: 1),
                TextField(
                  controller: _controller2,
                  placeholder: 'Max 10 chars',
                  maxLength: 10,
                  style: const TextStyle(color: Color.yellow),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Status:',
                  style: TextStyle(color: Color.magenta, bold: true),
                ),
                Text(
                  'Text changed: $_changedText',
                  style: const TextStyle(color: Color.white),
                ),
                Text(
                  'Text submitted: $_submittedText',
                  style: const TextStyle(color: Color.white),
                ),
                Text(
                  'Controller 1: ${_controller1.text}',
                  style: const TextStyle(color: Color.white),
                ),
                Text(
                  'Controller 2: ${_controller2.text}',
                  style: const TextStyle(color: Color.white),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Controls:',
                  style: TextStyle(color: Color.yellow, bold: true),
                ),
                const Text(
                  '• Tab: Switch between fields',
                  style: TextStyle(color: Color.white),
                ),
                const Text(
                  '• Arrow keys: Move cursor',
                  style: TextStyle(color: Color.white),
                ),
                const Text(
                  '• Enter: Submit text',
                  style: TextStyle(color: Color.white),
                ),
                const Text(
                  '• Backspace/Delete: Edit text',
                  style: TextStyle(color: Color.white),
                ),
                const Text(
                  '• Home/End: Jump to start/end',
                  style: TextStyle(color: Color.white),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Press Escape to return to menu',
                  style: TextStyle(color: Color.red, italic: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}