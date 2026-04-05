import 'dart:async';
import 'package:radartui/radartui.dart';

class IconExample extends StatefulWidget {
  const IconExample();

  @override
  State<IconExample> createState() => _IconExampleState();
}

class _IconExampleState extends State<IconExample> {
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
                '🖼️ Icon Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Icon(icon: Icons.arrowUp, color: Color.green),
              SizedBox(width: 1),
              Text('Up', style: TextStyle(color: Color.green)),
              SizedBox(width: 2),
              Icon(icon: Icons.arrowDown, color: Color.green),
              SizedBox(width: 1),
              Text('Down', style: TextStyle(color: Color.green)),
              SizedBox(width: 2),
              Icon(icon: Icons.arrowLeft, color: Color.cyan),
              SizedBox(width: 1),
              Text('Left', style: TextStyle(color: Color.cyan)),
              SizedBox(width: 2),
              Icon(icon: Icons.arrowRight, color: Color.cyan),
              SizedBox(width: 1),
              Text('Right', style: TextStyle(color: Color.cyan)),
            ],
          ),
          SizedBox(height: 1),
          Row(
            children: [
              Icon(icon: Icons.check, color: Color.green),
              SizedBox(width: 1),
              Text('Check', style: TextStyle(color: Color.green)),
              SizedBox(width: 2),
              Icon(icon: Icons.cross, color: Color.red),
              SizedBox(width: 1),
              Text('Cross', style: TextStyle(color: Color.red)),
              SizedBox(width: 2),
              Icon(icon: Icons.plus, color: Color.yellow),
              SizedBox(width: 1),
              Text('Plus', style: TextStyle(color: Color.yellow)),
            ],
          ),
          SizedBox(height: 1),
          Row(
            children: [
              Icon(icon: Icons.info, color: Color.blue),
              SizedBox(width: 1),
              Text('Info', style: TextStyle(color: Color.blue)),
              SizedBox(width: 2),
              Icon(icon: Icons.warning, color: Color.yellow),
              SizedBox(width: 1),
              Text('Warning', style: TextStyle(color: Color.yellow)),
              SizedBox(width: 2),
              Icon(icon: Icons.error, color: Color.red),
              SizedBox(width: 1),
              Text('Error', style: TextStyle(color: Color.red)),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Icon(icon: Icons.menu, color: Color.white),
              SizedBox(width: 1),
              Text('Menu'),
              SizedBox(width: 2),
              Icon(icon: Icons.search, color: Color.cyan),
              SizedBox(width: 1),
              Text('Search', style: TextStyle(color: Color.cyan)),
              SizedBox(width: 2),
              Icon(icon: Icons.settings, color: Color.magenta),
              SizedBox(width: 1),
              Text('Settings', style: TextStyle(color: Color.magenta)),
            ],
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
