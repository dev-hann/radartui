import 'dart:async';
import 'package:radartui/radartui.dart';

class StatusBarExample extends StatefulWidget {
  const StatusBarExample();

  @override
  State<StatusBarExample> createState() => _StatusBarExampleState();
}

class _StatusBarExampleState extends State<StatusBarExample> {
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
                '📟 StatusBar Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Default StatusBar (blue background):',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          StatusBar(
            left: Text('LEFT', style: TextStyle(color: Color.white)),
            center: Text('CENTER',
                style: TextStyle(color: Color.yellow, bold: true)),
            right: Text('RIGHT', style: TextStyle(color: Color.white)),
          ),
          SizedBox(height: 2),
          Text(
            'StatusBar with custom green background:',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          StatusBar(
            backgroundColor: Color.green,
            foregroundColor: Color.black,
            left: Text('File: main.dart'),
            center: Text('Ln 42, Col 15'),
            right: Text('Dart'),
          ),
          SizedBox(height: 2),
          Text(
            'StatusBar with red background:',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          StatusBar(
            backgroundColor: Color.red,
            foregroundColor: Color.white,
            left: Text('ERROR'),
            center: Text('Build failed'),
            right: Text('3 errors'),
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
