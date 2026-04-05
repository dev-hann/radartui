import 'dart:async';
import 'package:radartui/radartui.dart';

class GridViewExample extends StatefulWidget {
  const GridViewExample();

  @override
  State<GridViewExample> createState() => _GridViewExampleState();
}

class _GridViewExampleState extends State<GridViewExample> {
  int _selectedItem = -1;
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
    final List<String> items = List.generate(12, (int i) => 'Item ${i + 1}');

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
                '🔲 GridView Widget Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          if (_selectedItem >= 0)
            Text(
              'Selected: ${items[_selectedItem]}',
              style: const TextStyle(color: Color.green),
            )
          else
            const Text(
              'Use arrow keys to navigate, Enter to select',
              style: TextStyle(color: Color.brightBlack),
            ),
          const SizedBox(height: 1),
          Container(
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Expanded(
              child: GridView<String>(
                items: items,
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                initialSelectedIndex: 0,
                wrapAroundNavigation: true,
                onItemSelected: (int index, String item) {
                  setState(() {
                    _selectedItem = index;
                  });
                },
                selectedBuilder: (String item) => Container(
                  color: Color.blue,
                  child: Text(
                    item,
                    style: const TextStyle(color: Color.white, bold: true),
                  ),
                ),
                unselectedBuilder: (String item) => Container(
                  color: Color.brightBlack,
                  child: Text(item),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
