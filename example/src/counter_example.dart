import 'dart:async';

import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class CounterExample extends StatefulWidget {
  const CounterExample();

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
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        AppLogger.log('###################');
        AppLogger.log('CounterExample counter: $_counter');
        AppLogger.log('###################');
        _counter++;
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    AppLogger.log('###################');
    AppLogger.log('CounterExample dispose');
    AppLogger.log('###################');
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
