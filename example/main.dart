import 'dart:async';
import 'dart:io';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart'; // Added import

void main() {
  runApp(const CounterApp());
  // Keep the process alive indefinitely to listen for input
  Future.delayed(Duration(days: 365));
}

class CounterApp extends StatefulWidget {
  const CounterApp();

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    // Subscribe to keyboard events from SchedulerBinding's RawKeyboard
    _sub = SchedulerBinding.instance.keyboard.keyEvents.listen((_) {
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
          padding: const EdgeInsets.symmetric(v: 1, h: 0), // Fixed parameter names
          child: Text('Counter: $_counter'),
        ),
        const Text('(Press any key to increment, Ctrl+C to exit)'),
      ],
    );
  }
}