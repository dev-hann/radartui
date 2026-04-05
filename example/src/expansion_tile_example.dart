import 'dart:async';
import 'package:radartui/radartui.dart';

class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample();

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
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
                '📂 ExpansionTile Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 44,
            color: Color.brightBlack,
            child: Column(
              children: [
                ExpansionTile(
                  title: 'Getting Started',
                  initiallyExpanded: true,
                  expandedColor: Color.cyan,
                  collapsedColor: Color.white,
                  children: [
                    Text(
                      '  Welcome to RadarTUI!',
                      style: TextStyle(color: Color.white),
                    ),
                    Text(
                      '  A Flutter-like TUI framework for Dart.',
                      style: TextStyle(color: Color.white),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                ExpansionTile(
                  title: 'Installation',
                  expandedColor: Color.cyan,
                  collapsedColor: Color.white,
                  children: [
                    Text(
                      '  Add radartui to your pubspec.yaml',
                      style: TextStyle(color: Color.white),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                ExpansionTile(
                  title: 'Usage',
                  expandedColor: Color.cyan,
                  collapsedColor: Color.white,
                  children: [
                    Text(
                      '  Import and create your first widget!',
                      style: TextStyle(color: Color.white),
                    ),
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
