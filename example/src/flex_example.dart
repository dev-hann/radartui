import 'dart:async';
import 'package:radartui/radartui.dart';

class FlexExample extends StatefulWidget {
  const FlexExample();

  @override
  State<FlexExample> createState() => _FlexExampleState();
}

class _FlexExampleState extends State<FlexExample> {
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
                '📏 Flex Layout Example',
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
                  'Row with 3 containers:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Container(
                      width: 15,
                      height: 3,
                      color: Color.red,
                      child: Center(
                        child:
                            Text('Red', style: TextStyle(color: Color.white)),
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 3,
                      color: Color.green,
                      child: Center(
                        child: Text(
                          'Green',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 3,
                      color: Color.blue,
                      child: Center(
                        child:
                            Text('Blue', style: TextStyle(color: Color.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Column with 3 containers:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 2,
                      color: Color.red,
                      child: Text(
                        ' Row 1',
                        style: TextStyle(color: Color.white),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      color: Color.green,
                      child: Text(
                        ' Row 2',
                        style: TextStyle(color: Color.white),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      color: Color.blue,
                      child: Text(
                        ' Row 3',
                        style: TextStyle(color: Color.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Expanded inside a Row:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('[Fixed] '),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color.green,
                        child: Text(
                          'Expanded fills remaining space',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    Text(' [End]'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'MainAxisAlignment.spaceBetween:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('[A]', style: TextStyle(color: Color.red)),
                    Text('[B]', style: TextStyle(color: Color.green)),
                    Text('[C]', style: TextStyle(color: Color.blue)),
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
