import '../../lib/radartui.dart';

class DividerExample extends StatefulWidget {
  const DividerExample();

  @override
  State<DividerExample> createState() => _DividerExampleState();
}

class _DividerExampleState extends State<DividerExample> {
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
                '➖ Divider Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          
          // Horizontal Dividers
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Horizontal Dividers:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                
                Text('Section 1: Default Divider'),
                Divider(),
                
                Text('Section 2: Thick Red Divider'),
                Divider(
                  thickness: 2,
                  color: Color.red,
                ),
                
                Text('Section 3: Custom Character Divider'),
                Divider(
                  character: '=',
                  color: Color.yellow,
                ),
                
                Text('Section 4: Double Line Divider'),
                Divider(
                  character: '═',
                  color: Color.green,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 2),
          
          // Vertical Divider in Row
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Vertical Dividers in Row Layout:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Left Column'),
                    VerticalDivider(color: Color.white),
                    Text('Middle Column'),
                    VerticalDivider(
                      color: Color.red,
                      character: '┃',
                    ),
                    Text('Right Column'),
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