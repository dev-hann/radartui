import 'package:radartui/radartui.dart';
import 'src/button_example.dart';
import 'src/calculator_example.dart';
import 'src/counter_example.dart';
import 'src/dashboard_example.dart';
import 'src/dialog_example.dart';
import 'src/focus_example.dart';
import 'src/guess_game_example.dart';
import 'src/manual_test.dart';
import 'src/spinner_example.dart';
import 'src/style_example.dart';
import 'src/textfield_example.dart';

void main() {
  runApp(const RadarTUIExamplesApp());
}

class RadarTUIExamplesApp extends StatelessWidget {
  const RadarTUIExamplesApp();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/button': (context) => ButtonExample(),
        '/counter': (context) => const CounterExample(),
        '/calculator': (context) => const CalculatorExample(),
        '/dashboard': (context) => const DashboardExample(),
        '/dialog': (context) => DialogExample(),
        '/guess_game': (context) => const GuessGameExample(),
        '/spinner': (context) => const SpinnerExample(),
        '/style': (context) => const StyleExample(),
        '/focus': (context) => const FocusExample(),
        '/textfield': (context) => const TextFieldExample(),
        '/manual_test': (context) => const ManualTest(),
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
  final List<String> _exampleTitles = [
    'Button',
    'Counter',
    'Calculator',
    'Dashboard',
    'Dialog',
    'Guess Game',
    'Spinner',
    'Style Demo',
    'Focus Example',
    'TextField Example',
    'Manual Test',
  ];

  final List<String> _exampleRoutes = [
    '/button',
    '/counter',
    '/calculator',
    '/dashboard',
    '/dialog',
    '/guess_game',
    '/spinner',
    '/style',
    '/focus',
    '/textfield',
    '/manual_test',
  ];

  void _onExampleSelected(int index, String item) async {
    await Navigator.of(context).pushNamed(_exampleRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          const Container(
            width: 60,
            height: 5,
            color: Color.blue,
            child: Center(
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
                  'Select Example:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                ListView(
                  initialSelectedIndex: 0,
                  items: _exampleTitles,
                  onItemSelected: _onExampleSelected,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Use Arrow keys to move, Enter to select',
                  style: TextStyle(color: Color.yellow, italic: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
