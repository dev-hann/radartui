import 'package:radartui/radartui.dart';
import 'package:radartui/widget/button.dart';

void main() {
  Radartui.runApp(
    CounterApp(),
    onKey: (key) {
      if (key.ctrl && key.label == 'q') {
        Radartui.exitApp();
      }
    },
  );
}

class CounterApp extends StatefulWidget {
  CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Flutter-like Counter: $_counter'),
        Button(
          key: ValueKey('increaseButton'),
          label: 'Increase',
          onTap: _incrementCounter,
        ),
      ],
    );
  }
}