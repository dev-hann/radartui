import 'package:radartui/radartui.dart';

void main() {
  runApp(const FocusNavigationTestApp());
}

class FocusNavigationTestApp extends StatelessWidget {
  const FocusNavigationTestApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/page2': (context) => const Page2Screen(),
      },
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen();

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> _items = [
    'Option 1',
    'Option 2', 
    'Option 3',
    'Go to Page 2',
  ];

  void _onItemSelected(int index, String item) async {
    if (index == 3) { // "Go to Page 2"
      await Navigator.of(context).pushNamed('/page2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Text('Menu Screen - Test Focus Navigation'),
          const Text('Use j/k to move, Enter to select, ESC to go back'),
          const SizedBox(height: 1),
          ListView(
            initialSelectedIndex: 0,
            items: _items,
            onItemSelected: _onItemSelected,
          ),
          const SizedBox(height: 1),
          const Text('Problem: After going to Page 2 and coming back, j/k keys don\'t work'),
        ],
      ),
    );
  }
}

class Page2Screen extends StatefulWidget {
  const Page2Screen();

  @override
  State<Page2Screen> createState() => _Page2ScreenState();
}

class _Page2ScreenState extends State<Page2Screen> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event.key == 'Escape') {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Text('Page 2 Screen'),
          const SizedBox(height: 1),
          const Text('This is the second page.'),
          const Text('Press ESC to go back to menu.'),
          const SizedBox(height: 1),
          const Text('Expected: When you go back, j/k should still work in ListView'),
          const Text('Actual: j/k keys don\'t move the selection arrow anymore'),
        ],
      ),
    );
  }
}