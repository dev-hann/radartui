import 'dart:async';
import 'package:radartui/radartui.dart';

class LinearProgressExample extends StatefulWidget {
  const LinearProgressExample();

  @override
  State<LinearProgressExample> createState() => _LinearProgressExampleState();
}

class _LinearProgressExampleState extends State<LinearProgressExample> {
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
                '📊 LinearProgressIndicator Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 40,
            height: 5,
            color: Color.brightBlack,
            child: Column(
              children: [
                SizedBox(height: 1),
                Text(
                  'Determinate (75%):',
                  style: TextStyle(color: Color.white),
                ),
                SizedBox(height: 1),
                LinearProgressIndicator(value: 0.75),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: 40,
            height: 5,
            color: Color.brightBlack,
            child: Column(
              children: [
                SizedBox(height: 1),
                Text(
                  'Indeterminate (bouncing):',
                  style: TextStyle(color: Color.white),
                ),
                SizedBox(height: 1),
                LinearProgressIndicator(
                  value: null,
                  color: Color.cyan,
                  backgroundColor: Color.brightBlack,
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
