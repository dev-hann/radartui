import 'package:radartui/radartui.dart';

class SpacerExample extends StatefulWidget {
  const SpacerExample();

  @override
  State<SpacerExample> createState() => _SpacerExampleState();
}

class _SpacerExampleState extends State<SpacerExample> {
  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                'Spacer & Flexible Demo',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 70,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Without Spacer:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
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
          Container(
            width: 70,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'With Spacer (pushes items apart):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('[A]', style: TextStyle(color: Color.red)),
                    Spacer(),
                    Text('[B]', style: TextStyle(color: Color.green)),
                    Spacer(),
                    Text('[C]', style: TextStyle(color: Color.blue)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 70,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Spacer with flex ratio (1:2:1):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('[A]', style: TextStyle(color: Color.red)),
                    Spacer(flex: 1),
                    Text('[B]', style: TextStyle(color: Color.green)),
                    Spacer(flex: 2),
                    Text('[C]', style: TextStyle(color: Color.blue)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 70,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Expanded (takes available space):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Fixed: ', style: TextStyle(color: Color.white)),
                    Expanded(
                      child: Text(
                        'This text takes remaining space',
                        style: TextStyle(color: Color.yellow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 70,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Expanded with flex ratio (1:2:1):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Color.red,
                        child: Center(
                            child: Text('1',
                                style: TextStyle(color: Color.white))),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Color.green,
                        child: Center(
                            child: Text('2',
                                style: TextStyle(color: Color.white))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Color.blue,
                        child: Center(
                            child: Text('1',
                                style: TextStyle(color: Color.white))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 70,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Difference:',
                    style: TextStyle(color: Color.black, bold: true)),
                Text('Spacer: Empty space between items',
                    style: TextStyle(color: Color.black)),
                Text('Expanded: Widget that fills available space',
                    style: TextStyle(color: Color.black)),
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
