import '../../lib/radartui.dart';

class CardExample extends StatefulWidget {
  const CardExample();

  @override
  State<CardExample> createState() => _CardExampleState();
}

class _CardExampleState extends State<CardExample> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
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
                'Card Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),

          // Basic Cards
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Basic Cards:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Card(
                  color: Color.blue,
                  // padding: EdgeInsets.all(2),
                  child: Text('Card with blue background'),
                ),
                SizedBox(height: 1),
                Card(
                  padding: EdgeInsets.all(2),
                  child: Text('Card without background color'),
                ),
                SizedBox(height: 1),
                Card(
                  color: Color.green,
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  child: Column(
                    children: [
                      Text('Card with multiple children'),
                      Text('Second line of text'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2),

          // Different Colors
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Different Background Colors:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Card(
                      color: Color.red,
                      padding: EdgeInsets.all(1),
                      child: Text('Red'),
                    ),
                    SizedBox(width: 1),
                    Card(
                      color: Color.yellow,
                      padding: EdgeInsets.all(1),
                      child: Text('Yellow'),
                    ),
                    SizedBox(width: 1),
                    Card(
                      color: Color.magenta,
                      padding: EdgeInsets.all(1),
                      child: Text('Magenta'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2),

          // Navigation hint
          Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
