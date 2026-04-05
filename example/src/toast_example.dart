import 'dart:async';
import 'package:radartui/radartui.dart';

class ToastExample extends StatefulWidget {
  const ToastExample();

  @override
  State<ToastExample> createState() => _ToastExampleState();
}

class _ToastExampleState extends State<ToastExample> {
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
                '🍞 Toast Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Button(
            text: 'Show Success Toast',
            onPressed: () {
              Toast.show(
                context,
                message: 'Operation completed successfully!',
                backgroundColor: Color.green,
                textColor: Color.white,
              );
            },
            style: const ButtonStyle(
              backgroundColor: Color.green,
              focusBackgroundColor: Color.brightGreen,
            ),
          ),
          const SizedBox(height: 1),
          Button(
            text: 'Show Error Toast',
            onPressed: () {
              Toast.show(
                context,
                message: 'Something went wrong!',
                backgroundColor: Color.red,
                textColor: Color.white,
              );
            },
            style: const ButtonStyle(
              backgroundColor: Color.red,
              focusBackgroundColor: Color.brightRed,
            ),
          ),
          const SizedBox(height: 1),
          Button(
            text: 'Show Info Toast',
            onPressed: () {
              Toast.show(
                context,
                message: 'Here is some useful information.',
                backgroundColor: Color.blue,
                textColor: Color.white,
              );
            },
            style: const ButtonStyle(
              backgroundColor: Color.blue,
              focusBackgroundColor: Color.brightBlue,
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
