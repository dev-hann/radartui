import 'dart:async';
import 'package:radartui/radartui.dart';

class ButtonExample extends StatefulWidget {
  const ButtonExample();

  @override
  State<ButtonExample> createState() => _ButtonExampleState();
}

class _ButtonExampleState extends State<ButtonExample> {
  int _pressCount = 0;
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
                '🔘 Button Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Press count: $_pressCount',
            style: const TextStyle(color: Color.cyan),
          ),
          const SizedBox(height: 1),
          Button(
            text: 'Press Me',
            onPressed: () {
              setState(() {
                _pressCount++;
              });
            },
          ),
          const SizedBox(height: 1),
          Button(
            text: 'Disabled',
            enabled: false,
            onPressed: () {},
          ),
          const SizedBox(height: 1),
          Row(
            children: [
              Button(
                text: 'Red',
                onPressed: () {
                  setState(() {
                    _pressCount++;
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: Color.red,
                  focusBackgroundColor: Color.brightRed,
                ),
              ),
              const SizedBox(width: 2),
              Button(
                text: 'Green',
                onPressed: () {
                  setState(() {
                    _pressCount++;
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: Color.green,
                  focusBackgroundColor: Color.brightGreen,
                ),
              ),
            ],
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
