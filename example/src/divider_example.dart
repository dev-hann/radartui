import 'dart:async';
import 'package:radartui/radartui.dart';

class DividerExample extends StatefulWidget {
  const DividerExample();

  @override
  State<DividerExample> createState() => _DividerExampleState();
}

class _DividerExampleState extends State<DividerExample> {
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
                '➖ Divider Widget Example',
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
                Text('Default Divider:'),
                SizedBox(height: 1),
                Divider(),
                SizedBox(height: 1),
                Text('Thick colored divider:'),
                SizedBox(height: 1),
                Divider(thickness: 2, color: Color.cyan),
                SizedBox(height: 1),
                Text('Custom character:'),
                SizedBox(height: 1),
                Divider(character: '=', color: Color.yellow),
                SizedBox(height: 1),
                Text('Double line:'),
                SizedBox(height: 1),
                Divider(character: '═', color: Color.green),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text('Left', style: TextStyle(color: Color.cyan)),
                    VerticalDivider(color: Color.white),
                    Text('Middle', style: TextStyle(color: Color.green)),
                    VerticalDivider(color: Color.white),
                    Text('Right', style: TextStyle(color: Color.magenta)),
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
