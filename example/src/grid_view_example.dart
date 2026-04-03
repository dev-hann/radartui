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
    final items = List.generate(12, (i) => 'Item ${i + 1}');

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GridView Widget Example',
            style: TextStyle(color: Color.brightCyan, bold: true),
          ),
          const SizedBox(height: 1),
          const Text(
            'Arrow keys to navigate, Space/Enter to select',
            style: TextStyle(color: Color.brightBlack),
          ),
          const SizedBox(height: 1),
          if (_selectedItem >= 0)
            Text(
              'Selected: ${items[_selectedItem]}',
              style: const TextStyle(color: Color.green),
            ),
          Expanded(
            child: GridView<String>(
              items: items,
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              initialSelectedIndex: 0,
              onItemSelected: (index, item) {
                setState(() {
                  _selectedItem = index;
                });
              },
              selectedBuilder: (item) => Container(
                width: 16,
                height: 2,
                color: Color.blue,
                child: Text(
                  item,
                  style: const TextStyle(color: Color.white, bold: true),
                ),
              ),
              unselectedBuilder: (item) => Container(
                width: 16,
                height: 2,
                color: Color.black,
                child: Text(item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
