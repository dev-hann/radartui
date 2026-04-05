import 'dart:async';
import 'package:radartui/radartui.dart';

class CircularProgressExample extends StatefulWidget {
  const CircularProgressExample();

  @override
  State<CircularProgressExample> createState() =>
      _CircularProgressExampleState();
}

class _CircularProgressExampleState extends State<CircularProgressExample> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '⏳ CircularProgressIndicator Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 40,
            height: 3,
            color: Color.brightBlack,
            child: Row(
              children: [
                SizedBox(width: 1),
                CircularProgressIndicator(label: 'Loading...'),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: 40,
            height: 3,
            color: Color.brightBlack,
            child: Row(
              children: [
                SizedBox(width: 1),
                CircularProgressIndicator(
                  color: Color.cyan,
                  backgroundColor: Color.brightBlack,
                  frames: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
                  label: 'Custom spinner',
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
