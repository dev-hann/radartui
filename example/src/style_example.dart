import 'dart:async';
import 'package:radartui/radartui.dart';

class StyleExample extends StatefulWidget {
  const StyleExample();

  @override
  State<StyleExample> createState() => _StyleExampleState();
}

class _StyleExampleState extends State<StyleExample> {
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
                '✨ Text Styling Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Bold text',
            style: TextStyle(bold: true),
          ),
          SizedBox(height: 1),
          Text(
            'Italic text',
            style: TextStyle(italic: true),
          ),
          SizedBox(height: 1),
          Text(
            'Underline text',
            style: TextStyle(underline: true),
          ),
          SizedBox(height: 1),
          Text(
            'Bold + Italic',
            style: TextStyle(bold: true, italic: true),
          ),
          SizedBox(height: 1),
          Text(
            'Bold + Underline',
            style: TextStyle(bold: true, underline: true),
          ),
          SizedBox(height: 2),
          Text(
            'Red text',
            style: TextStyle(color: Color.red),
          ),
          SizedBox(height: 1),
          Text(
            'Green text',
            style: TextStyle(color: Color.green),
          ),
          SizedBox(height: 1),
          Text(
            'Cyan text',
            style: TextStyle(color: Color.cyan),
          ),
          SizedBox(height: 1),
          Text(
            'Yellow text',
            style: TextStyle(color: Color.yellow),
          ),
          SizedBox(height: 1),
          Text(
            'Magenta text',
            style: TextStyle(color: Color.magenta),
          ),
          SizedBox(height: 2),
          Text(
            'Bold colored',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          SizedBox(height: 1),
          Text(
            'Italic colored',
            style: TextStyle(color: Color.green, italic: true),
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
