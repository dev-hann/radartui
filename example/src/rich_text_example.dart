import 'dart:async';
import 'package:radartui/radartui.dart';

class RichTextExample extends StatefulWidget {
  const RichTextExample();

  @override
  State<RichTextExample> createState() => _RichTextExampleState();
}

class _RichTextExampleState extends State<RichTextExample> {
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
                '🎨 RichText Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Hello ', style: TextStyle(color: Color.red)),
                TextSpan(text: 'World ', style: TextStyle(color: Color.green)),
                TextSpan(
                    text: '!', style: TextStyle(color: Color.cyan, bold: true)),
              ],
            ),
          ),
          SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Normal ', style: TextStyle()),
                TextSpan(text: 'Bold ', style: TextStyle(bold: true)),
                TextSpan(text: 'Italic ', style: TextStyle(italic: true)),
                TextSpan(text: 'Underline', style: TextStyle(underline: true)),
              ],
            ),
          ),
          SizedBox(height: 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'ERROR: ',
                    style: TextStyle(color: Color.red, bold: true)),
                TextSpan(
                    text: 'File not found', style: TextStyle(color: Color.red)),
              ],
            ),
          ),
          SizedBox(height: 1),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'WARN: ',
                    style: TextStyle(color: Color.yellow, bold: true)),
                TextSpan(
                    text: 'Low disk space',
                    style: TextStyle(color: Color.yellow)),
              ],
            ),
          ),
          SizedBox(height: 1),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'OK: ',
                    style: TextStyle(color: Color.green, bold: true)),
                TextSpan(
                    text: 'All systems go',
                    style: TextStyle(color: Color.green)),
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
