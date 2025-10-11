import '../../lib/radartui.dart';

class AlignExample extends StatefulWidget {
  const AlignExample();

  @override
  State<AlignExample> createState() => _AlignExampleState();
}

class _AlignExampleState extends State<AlignExample> {
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
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text('Top Center'),
              ),
              Text('Bottom Center')
            ],
          ),
          Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '✨ Align & Center Widget Example',
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
                  'Align Widget Examples:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Container(
                  width: 40,
                  height: 10,
                  color: Colors.blue,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('TopLeft'),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text('TopCenter'),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text('TopRight'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('CenterLeft'),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Center'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('CenterRight'),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('BottomLeft'),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('BottomCenter'),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text('BottomRight'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 2),
          // Container(
          //   color: Color.brightBlack,
          //   padding: EdgeInsets.all(1),
          //   child: Column(
          //     children: [
          //       Text(
          //         'Center Widget Example (Refactored):',
          //         style: TextStyle(color: Color.cyan, bold: true),
          //       ),
          //       SizedBox(height: 1),
          //       Container(
          //         width: 40,
          //         height: 5,
          //         color: Colors.green,
          //         child: Center(
          //           child: Text('This is centered!'),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 2),
          // Text(
          //   'Press ESC to return to main menu',
          //   style: TextStyle(color: Color.yellow, italic: true),
          // ),
        ],
      ),
    );
  }
}
