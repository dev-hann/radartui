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
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
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
      return;
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
                '🎨 Icon Widget Example',
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
                  'Navigation Icons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.arrowUp, color: Color.green),
                    Icon(icon: Icons.arrowDown, color: Color.green),
                    Icon(icon: Icons.arrowLeft, color: Color.green),
                    Icon(icon: Icons.arrowRight, color: Color.green),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Action Icons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.check, color: Color.green),
                    Icon(icon: Icons.cross, color: Color.red),
                    Icon(icon: Icons.plus, color: Color.yellow),
                    Icon(icon: Icons.minus, color: Color.yellow),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'File Icons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.folder, color: Color.yellow),
                    Icon(icon: Icons.file, color: Color.white),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Status Icons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.info, color: Color.blue),
                    Icon(icon: Icons.warning, color: Color.yellow),
                    Icon(icon: Icons.error, color: Color.red),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'UI Icons:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.menu, color: Color.white),
                    Icon(icon: Icons.search, color: Color.cyan),
                    Icon(icon: Icons.settings, color: Color.magenta),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'ASCII Alternatives (fallback):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon: Icons.arrowUpAscii),
                    Icon(icon: Icons.arrowDownAscii),
                    Icon(icon: Icons.arrowLeftAscii),
                    Icon(icon: Icons.arrowRightAscii),
                    Icon(icon: Icons.checkAscii, color: Color.green),
                    Icon(icon: Icons.crossAscii, color: Color.red),
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
