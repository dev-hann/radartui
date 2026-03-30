import 'package:radartui/radartui.dart';

class IndexedStackExample extends StatefulWidget {
  const IndexedStackExample();

  @override
  State<IndexedStackExample> createState() => _IndexedStackExampleState();
}

class _IndexedStackExampleState extends State<IndexedStackExample> {
  int _currentIndex = 0;
  static const _pageColors = [Color.red, Color.green, Color.blue];
  static const _pageNames = ['Red Page', 'Green Page', 'Blue Page'];

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.keyEvents.listen(_handleKeyEvent);
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
      return;
    }
    if (keyEvent.code == KeyCode.arrowLeft) {
      setState(() {
        _currentIndex = (_currentIndex - 1).clamp(0, 2);
      });
    } else if (keyEvent.code == KeyCode.arrowRight) {
      setState(() {
        _currentIndex = (_currentIndex + 1).clamp(0, 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                'IndexedStack Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 50,
            height: 10,
            color: Color.brightBlack,
            child: IndexedStack(
              index: _currentIndex,
              children: _buildPages(),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Page ${_currentIndex + 1} of 3: ${_pageNames[_currentIndex]}',
            style: const TextStyle(color: Color.cyan, bold: true),
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentIndex > 0 ? '< Prev' : '       ',
                style: const TextStyle(color: Color.yellow),
              ),
              const SizedBox(width: 4),
              Text(
                _currentIndex < 2 ? 'Next >' : '      ',
                style: const TextStyle(color: Color.yellow),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Arrow keys to switch pages, ESC to return',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      for (int i = 0; i < 3; i++)
        Center(
          child: Container(
            width: 30,
            height: 6,
            color: _pageColors[i],
            child: Center(
              child: Text(
                _pageNames[i],
                style: const TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
        ),
    ];
  }
}
