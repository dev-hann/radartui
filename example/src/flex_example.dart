import '../../lib/radartui.dart';

class FlexExample extends StatefulWidget {
  const FlexExample();

  @override
  State<FlexExample> createState() => _FlexExampleState();
}

class _FlexExampleState extends State<FlexExample> {
  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.keyEvents.listen((key) {
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
          Text(
            'Flex Layout Example',
            style: TextStyle(color: Color.cyan, bold: true),
          ),
          SizedBox(height: 2),
          
          Text('Row with MainAxisAlignment.start:', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 1,
            color: Color.brightBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('[A]'),
                Text('[B]'),
                Text('[C]'),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text('Row with MainAxisAlignment.center:', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 1,
            color: Color.brightBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('[A]'),
                Text('[B]'),
                Text('[C]'),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text('Row with MainAxisAlignment.spaceBetween:', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 1,
            color: Color.brightBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('[A]'),
                Text('[B]'),
                Text('[C]'),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text('Expanded widget (fills remaining space):', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 1,
            color: Color.brightBlack,
            child: Row(
              children: [
                Text('[Fixed]'),
                Expanded(
                  child: Text('[EXPANDED - fills remaining space]', style: TextStyle(color: Color.green)),
                ),
                Text('[End]'),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text('Multiple Expanded with flex ratios (1:2:1):', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 1,
            color: Color.brightBlack,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('[1]', style: TextStyle(color: Color.red)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('[2 - larger]', style: TextStyle(color: Color.green)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('[1]', style: TextStyle(color: Color.blue)),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text('Column with CrossAxisAlignment:', style: TextStyle(color: Color.yellow)),
          SizedBox(height: 1),
          Container(
            height: 5,
            color: Color.brightBlack,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start'),
                    Text('Aligned'),
                  ],
                ),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Center'),
                    Text('Aligned'),
                  ],
                ),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('End'),
                    Text('Aligned'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),

          Text(
            'Press ESC to return',
            style: TextStyle(color: Color.brightGreen, italic: true),
          ),
        ],
      ),
    );
  }
}
