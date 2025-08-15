import 'package:radartui/radartui.dart';

class CounterExample extends StatefulWidget {
  const CounterExample();

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  int _counter = 0;

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
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Welcome to the Radartui Counter!'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
          child: Text('Counter: $_counter'),
        ),
        const Text('(Press any key to increment, ESC to return)'),
      ],
    );
  }
}
