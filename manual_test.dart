import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

void main() {
  print("=== Manual Test for Focus Issue ===");
  print("1. App will start, you should see '>' on Counter");
  print("2. Press Enter to go to Counter");
  print("3. Press Escape to return to main menu");
  print("4. Check if '>' is still visible on Counter");
  print("=====================================");
  
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu(),
        '/counter': (context) => const CounterPage(),
      },
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu();

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  void _onItemSelected(int index, String item) async {
    if (index == 0) {
      await Navigator.of(context).pushNamed('/counter');
      print("DEBUG: Returned from counter page, checking focus...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Text('Main Menu - Focus Test'),
          SizedBox(height: 1),
          Text('Current focus should be visible below:'),
          SizedBox(height: 1),
          ListView(
            items: ['Counter', 'Calculator', 'Other'],
            focusedBorder: '[=== FOCUSED ===]',
            unfocusedBorder: '[             ]',
            selectedPrefix: '> ',
            unselectedPrefix: '  ',
            onItemSelected: _onItemSelected,
          ),
          SizedBox(height: 1),
          Text('Use Enter to select, arrows to navigate'),
        ],
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage();

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      if (event.key == 'Escape') {
        print("DEBUG: Escape pressed, returning to main menu...");
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Text('Counter Page'),
          SizedBox(height: 1),
          Text('Press Escape to return to main menu'),
          SizedBox(height: 1),
          Text('This is where you test the focus restoration'),
        ],
      ),
    );
  }
}