import '../../lib/radartui.dart';

class TextFieldExample extends StatefulWidget {
  const TextFieldExample();

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1.text = 'Initial text';
    SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
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
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {
                    setState(() {});
                  },
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
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {
                    setState(() {});
                  },
                  style: const TextStyle(color: Color.yellow),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Status:',
                  style: TextStyle(color: Color.magenta, bold: true),
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
