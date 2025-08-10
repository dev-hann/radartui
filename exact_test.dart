import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

void main() {
  runApp(const ExactTestApp());
}

class ExactTestApp extends StatelessWidget {
  const ExactTestApp();

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
  int _step = 1;

  @override
  void initState() {
    super.initState();
    
    // Step 1: 초기 표시 (2초 대기)
    Timer(Duration(seconds: 2), () {
      setState(() {
        _step = 2;
      });
      
      // Step 2: Enter 누른 효과 - Counter로 이동
      Navigator.of(context).pushNamed('/counter');
    });
  }

  void _onItemSelected(int index, String item) async {
    if (index == 0) {
      setState(() {
        _step = 2;
      });
      await Navigator.of(context).pushNamed('/counter');
      // 돌아온 후
      setState(() {
        _step = 4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      child: Column(
        children: [
          Text('=== Focus Test - Step $_step ==='),
          SizedBox(height: 1),
          _buildStepDescription(),
          SizedBox(height: 1),
          ListView(
            items: ['Counter', 'Calculator', 'Other'],
            selectedPrefix: '> ',
            unselectedPrefix: '  ',
            onItemSelected: _onItemSelected,
          ),
          SizedBox(height: 1),
          Text('Check: Is ">" visible on Counter above?'),
        ],
      ),
    );
  }
  
  Widget _buildStepDescription() {
    switch (_step) {
      case 1:
        return Text('Step 1: Initial state - ">" should be visible');
      case 2:
        return Text('Step 2: Navigating to Counter page...');
      case 4:
        return Text('Step 4: RETURNED! Is ">" still visible?');
      default:
        return Text('Step $_step: Testing...');
    }
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage();

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  StreamSubscription? _keySubscription;
  Timer? _autoReturnTimer;

  @override
  void initState() {
    super.initState();
    
    // Escape key listener
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      if (event.key == 'Escape') {
        Navigator.of(context).pop();
      }
    });
    
    // Auto return after 3 seconds to test the issue
    _autoReturnTimer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _autoReturnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      child: Column(
        children: [
          Text('=== Counter Page ==='),
          SizedBox(height: 1),
          Text('Step 3: Now on Counter page'),
          Text('Will return to main menu in 3 seconds...'),
          Text('(Or press Escape manually)'),
          SizedBox(height: 1),
          Text('Testing focus restoration after pop()'),
        ],
      ),
    );
  }
}