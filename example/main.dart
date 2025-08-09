import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';
import 'src/calculator_example.dart';
import 'src/dashboard_example.dart';
import 'src/guess_game_example.dart';
import 'src/spinner_example.dart';
import 'src/style_example.dart';

void main() {
  runApp(const RadarTUIExamplesApp());
}

class RadarTUIExamplesApp extends StatefulWidget {
  const RadarTUIExamplesApp();

  @override
  State<RadarTUIExamplesApp> createState() => _RadarTUIExamplesAppState();
}

class _RadarTUIExamplesAppState extends State<RadarTUIExamplesApp> {
  int _selectedExample = 0;
  StreamSubscription? _keySubscription;

  final List<String> _exampleTitles = [
    '메뉴 (Menu)',
    '카운터 (Counter)',
    '계산기 (Calculator)',
    '대시보드 (Dashboard)',
    '숫자 맞추기 (Guess Game)',
    '로딩 스피너 (Spinner)',
    '스타일 데모 (Style Demo)',
  ];

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      if (_selectedExample == 0) {
        _handleMenuKey(key);
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleMenuKey(KeyEvent key) {
    setState(() {
      if (KeyParser.isDigit(key.key)) {
        int num = int.parse(key.key);
        if (num >= 1 && num <= 6) {
          _selectedExample = num;
        }
      }
    });
  }

  void _returnToMenu() {
    setState(() {
      _selectedExample = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_selectedExample) {
      case 0:
        return _buildMenu();
      case 1:
        return CounterExample(onBack: _returnToMenu);
      case 2:
        return CalculatorExample(onBack: _returnToMenu);
      case 3:
        return DashboardExample(onBack: _returnToMenu);
      case 4:
        return GuessGameExample(onBack: _returnToMenu);
      case 5:
        return SpinnerExample(onBack: _returnToMenu);
      case 6:
        return StyleExample(onBack: _returnToMenu);
      default:
        return _buildMenu();
    }
  }

  Widget _buildMenu() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 5,
            color: Color.blue,
            child: const Center(
              child: Text(
                '🚀 RadarTUI Examples Collection 🚀',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          const SizedBox(height: 2),

          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const Text(
                  '예제 선택 (Select Example):',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),

                for (int i = 1; i < _exampleTitles.length; i++)
                  Text(
                    '$i. ${_exampleTitles[i]}',
                    style: const TextStyle(color: Color.white),
                  ),

                const SizedBox(height: 2),

                const Text(
                  '숫자 키를 눌러서 예제를 선택하세요',
                  style: TextStyle(color: Color.yellow, italic: true),
                ),

                const Text(
                  'Press number keys to select examples',
                  style: TextStyle(color: Color.brightYellow, italic: true),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          const Container(
            width: 60,
            color: Color.green,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  '💡 각 예제에서 ESC키를 누르면 메뉴로 돌아옵니다',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text(
                  '💡 Press ESC in any example to return to menu',
                  style: TextStyle(color: Color.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Counter Example
class CounterExample extends StatefulWidget {
  final Function() onBack;
  const CounterExample({required this.onBack});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  int _counter = 0;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = SchedulerBinding.instance.keyboard.keyEvents.listen((
      KeyEvent keyEvent,
    ) {
      if (keyEvent.key == 'Escape') {
        widget.onBack();
        return;
      }
      setState(() {
        _counter++;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Welcome to the Radartui Counter!'),
        Padding(
          padding: const EdgeInsets.symmetric(v: 1, h: 0),
          child: Text('Counter: $_counter'),
        ),
        const Text('(Press any key to increment, ESC to return)'),
      ],
    );
  }
}
