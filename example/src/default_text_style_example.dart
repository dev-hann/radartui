import 'dart:async';
import 'package:radartui/radartui.dart';

class DefaultTextStyleExample extends StatefulWidget {
  const DefaultTextStyleExample();

  @override
  State<DefaultTextStyleExample> createState() =>
      _DefaultTextStyleExampleState();
}

class _DefaultTextStyleExampleState extends State<DefaultTextStyleExample> {
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
                '🔤 DefaultTextStyle Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Inherited style (cyan, bold):',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          DefaultTextStyle(
            style: TextStyle(color: Color.cyan, bold: true),
            child: Column(
              children: [
                Text('Children inherit this style'),
                Text('No explicit TextStyle needed'),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Override vs inheritance:',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          DefaultTextStyle(
            style: TextStyle(color: Color.green, italic: true),
            child: Column(
              children: [
                Text('Inherited green italic'),
                Text(
                  'Explicit red overrides default',
                  style: TextStyle(color: Color.red),
                ),
                Text('Back to inherited green italic'),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Nested DefaultTextStyle:',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          DefaultTextStyle(
            style: TextStyle(color: Color.yellow),
            child: DefaultTextStyle(
              style: TextStyle(color: Color.magenta, bold: true),
              child: Column(
                children: [
                  Text('Inner style wins (magenta bold)'),
                ],
              ),
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
