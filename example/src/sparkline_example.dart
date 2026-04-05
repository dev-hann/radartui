import 'dart:async';
import 'package:radartui/radartui.dart';

class SparklineExample extends StatefulWidget {
  const SparklineExample();

  @override
  State<SparklineExample> createState() => _SparklineExampleState();
}

class _SparklineExampleState extends State<SparklineExample> {
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
                '📈 Sparkline Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'CPU Usage:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Sparkline(
                  data: [1, 3, 5, 2, 8, 4, 6, 9, 3, 7],
                  color: Color.cyan,
                ),
                SizedBox(height: 2),
                Text(
                  'Memory:',
                  style: TextStyle(color: Color.green, bold: true),
                ),
                SizedBox(height: 1),
                Sparkline(
                  data: [4, 4, 5, 6, 7, 7, 8, 8, 9, 9],
                  color: Color.green,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Net:', style: TextStyle(color: Color.yellow)),
                        SizedBox(height: 1),
                        Sparkline(
                          data: [2, 5, 1, 7, 3, 8, 2, 6, 4, 9],
                          color: Color.yellow,
                        ),
                      ],
                    ),
                    SizedBox(width: 2),
                    Column(
                      children: [
                        Text('Disk:', style: TextStyle(color: Color.magenta)),
                        SizedBox(height: 1),
                        Sparkline(
                          data: [9, 7, 8, 6, 5, 4, 3, 2, 1, 3],
                          color: Color.magenta,
                        ),
                      ],
                    ),
                  ],
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
