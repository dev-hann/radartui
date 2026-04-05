import 'dart:async';
import 'package:radartui/radartui.dart';

class AlignExample extends StatefulWidget {
  const AlignExample();

  @override
  State<AlignExample> createState() => _AlignExampleState();
}

class _AlignExampleState extends State<AlignExample> {
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
                '📐 Align & Center Example',
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
                  'Alignment.topLeft:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Container(
                  width: 40,
                  height: 3,
                  color: Color.red,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'TopLeft',
                      style: TextStyle(color: Color.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Alignment.center:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Container(
                  width: 40,
                  height: 3,
                  color: Color.green,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Center',
                      style: TextStyle(color: Color.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Alignment.bottomRight:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Container(
                  width: 40,
                  height: 3,
                  color: Color.magenta,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'BottomRight',
                      style: TextStyle(color: Color.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Center widget:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Container(
                  width: 40,
                  height: 3,
                  color: Color.cyan,
                  child: Center(
                    child: Text(
                      'Centered Text',
                      style: TextStyle(color: Color.black),
                    ),
                  ),
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
