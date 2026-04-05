import 'dart:async';
import 'package:radartui/radartui.dart';

class SpacerExample extends StatefulWidget {
  const SpacerExample();

  @override
  State<SpacerExample> createState() => _SpacerExampleState();
}

class _SpacerExampleState extends State<SpacerExample> {
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
                '↕️ Spacer & Flexible Example',
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
                  'Spacer in a Row:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('[A]', style: TextStyle(color: Color.red)),
                    Spacer(),
                    Text('[B]', style: TextStyle(color: Color.green)),
                    Spacer(),
                    Text('[C]', style: TextStyle(color: Color.blue)),
                  ],
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
                  'Spacer in a Column:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Top', style: TextStyle(color: Color.red)),
                          SizedBox(height: 1),
                          Spacer(),
                          Text('Bottom', style: TextStyle(color: Color.blue)),
                        ],
                      ),
                    ),
                  ],
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
                  'Expanded (Flexible) in a Row:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Fixed '),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color.green,
                        child: Text(
                          'Takes remaining space',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    Text(' End'),
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
