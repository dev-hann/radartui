import 'dart:async';
import 'package:radartui/radartui.dart';

class StackExample extends StatefulWidget {
  const StackExample();

  @override
  State<StackExample> createState() => _StackExampleState();
}

class _StackExampleState extends State<StackExample> {
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
                '📚 Stack Widget Example',
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
                  'Stack with Positioned children:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 7,
                      color: Color.red,
                    ),
                    Positioned(
                      top: 0,
                      left: 2,
                      child: Text(
                        'TopLeft',
                        style: TextStyle(color: Color.white, bold: true),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      left: 15,
                      child: Text(
                        'Center',
                        style: TextStyle(color: Color.yellow, bold: true),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 2,
                      child: Text(
                        'BottomRight',
                        style: TextStyle(color: Color.white, bold: true),
                      ),
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
