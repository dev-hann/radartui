import '../../lib/radartui.dart';

class StackExample extends StatefulWidget {
  const StackExample();

  @override
  State<StackExample> createState() => _StackExampleState();
}

class _StackExampleState extends State<StackExample> {
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
      child: const Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: const Center(
              child: Text(
                '📚 Stack Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          
          // Stack Example 1: Basic Overlapping
          const Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: const Column(
              children: [
                Text(
                  'Basic Stack - Overlapping Widgets:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Stack(
                  children: [
                    Container(
                      width: 20,
                      height: 5,
                      color: Color.red,
                      child: Center(
                        child: Text(
                          'Background Layer',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 15,
                      height: 3,
                      color: Color.green,
                      child: Center(
                        child: Text(
                          'Middle Layer',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 2,
                      color: Color.blue,
                      child: Center(
                        child: Text(
                          'Top Layer',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Stack Example 2: Text Overlay
          const Container(
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: const Column(
              children: [
                Text(
                  'Stack with Text Overlay:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Stack(
                  children: [
                    Container(
                      width: 30,
                      height: 4,
                      color: Color.magenta,
                    ),
                    Text(
                      'Overlaid Text on Background',
                      style: TextStyle(color: Color.white, bold: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Navigation hint
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}