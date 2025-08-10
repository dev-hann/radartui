import 'dart:async';
import 'package:radartui/radartui.dart';

void main() {
  runApp(const TestNavigationApp());
}

class TestNavigationApp extends StatelessWidget {
  const TestNavigationApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainTestPage(),
        '/counter': (context) => const CounterTestPage(),
      },
    );
  }
}

class MainTestPage extends StatefulWidget {
  const MainTestPage();

  @override
  State<MainTestPage> createState() => _MainTestPageState();
}

class _MainTestPageState extends State<MainTestPage> {
  int _step = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // 자동 테스트 시퀀스
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _step = 2;
      });
      // Counter 페이지로 이동
      Navigator.of(context).pushNamed('/counter');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Text('Navigation Focus Test - Step $_step'),
          SizedBox(height: 1),
          Text('Testing focus restoration after navigation...'),
          SizedBox(height: 1),
          ListView(
            items: ['Go to Counter', 'Option 2', 'Option 3'],
            focusedBorder: '[ FOCUSED ]',
            unfocusedBorder: '[         ]',
            onItemSelected: (index, item) async {
              if (index == 0) {
                await Navigator.of(context).pushNamed('/counter');
                setState(() {
                  _step = 4;
                });
              }
            },
          ),
          SizedBox(height: 1),
          Text(_step == 1 
            ? 'Step 1: Initial focus should be visible above'
            : _step == 4
            ? 'Step 4: Focus should be restored after navigation'
            : 'Auto-navigating to test...'),
        ],
      ),
    );
  }
}

class CounterTestPage extends StatefulWidget {
  const CounterTestPage();

  @override
  State<CounterTestPage> createState() => _CounterTestPageState();
}

class _CounterTestPageState extends State<CounterTestPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // 3초 후 자동으로 돌아가기
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          Text('Step 3: Now on counter page...'),
          Text('Will automatically return in 3 seconds'),
          Text('to test focus restoration'),
        ],
      ),
    );
  }
}