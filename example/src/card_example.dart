import 'dart:async';
import 'package:radartui/radartui.dart';

class CardExample extends StatefulWidget {
  const CardExample();

  @override
  State<CardExample> createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
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
                '🃏 Card Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Card(
            child: Text('Default card with no color'),
          ),
          SizedBox(height: 1),
          Card(
            color: Color.blue,
            padding: EdgeInsets.all(1),
            child: Text(
              'Blue card with padding',
              style: TextStyle(color: Color.white),
            ),
          ),
          SizedBox(height: 1),
          Card(
            color: Color.green,
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            child: Text(
              'Green card',
              style: TextStyle(color: Color.black, bold: true),
            ),
          ),
          SizedBox(height: 1),
          Card(
            color: Color.red,
            padding: EdgeInsets.all(1),
            child: Text(
              'Error card',
              style: TextStyle(color: Color.white, bold: true),
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
