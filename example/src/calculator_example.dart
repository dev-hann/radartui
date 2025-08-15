import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class CalculatorExample extends StatefulWidget {
  const CalculatorExample();

  @override
  State<CalculatorExample> createState() => _CalculatorExampleState();
}

class _CalculatorExampleState extends State<CalculatorExample> {
  String _display = '0';
  String _operation = '';
  double _firstNumber = 0;
  bool _isNewNumber = true;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.code == KeyCode.escape) {
        Navigator.of(context).pop();
        return;
      }
      _handleKeyInput(key);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  bool isDigit(String? char) {
    if (char == null) return false;
    return '0123456789'.contains(char);
  }

  void _handleKeyInput(KeyEvent key) {
    setState(() {
      if (key.code == KeyCode.char && isDigit(key.char)) {
        _inputNumber(key.char!);
      } else if (key.code == KeyCode.char && key.char == '+') {
        _inputOperation('+');
      } else if (key.code == KeyCode.char && key.char == '-') {
        _inputOperation('-');
      } else if (key.code == KeyCode.char && key.char == '*') {
        _inputOperation('*');
      } else if (key.code == KeyCode.char && key.char == '/') {
        _inputOperation('/');
      } else if ((key.code == KeyCode.char && key.char == '=') ||
          key.code == KeyCode.enter) {
        _calculate();
      } else if (key.code == KeyCode.char &&
          (key.char == 'c' || key.char == 'C')) {
        _clear();
      }
    });
  }

  void _inputNumber(String number) {
    if (_isNewNumber) {
      _display = number;
      _isNewNumber = false;
    } else {
      _display += number;
    }
  }

  void _inputOperation(String op) {
    _firstNumber = double.parse(_display);
    _operation = op;
    _isNewNumber = true;
  }

  void _calculate() {
    if (_operation.isEmpty) return;

    double secondNumber = double.parse(_display);
    double result = 0;

    switch (_operation) {
      case '+':
        result = _firstNumber + secondNumber;
        break;
      case '-':
        result = _firstNumber - secondNumber;
        break;
      case '*':
        result = _firstNumber * secondNumber;
        break;
      case '/':
        result = secondNumber != 0 ? _firstNumber / secondNumber : 0;
        break;
    }

    _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
    _operation = '';
    _isNewNumber = true;
  }

  void _clear() {
    _display = '0';
    _operation = '';
    _firstNumber = 0;
    _isNewNumber = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 40,
            color: Color.blue,
            child: Center(
              child: Text(
                '🧮 RadarTUI Calculator 🧮',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          const SizedBox(height: 1),

          Container(
            width: 40,
            height: 3,
            color: Color.black,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text('Display:', style: TextStyle(color: Color.green)),
                  ],
                ),
                Container(
                  width: 36,
                  color: Color.brightBlack,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Text(
                      _display,
                      style: const TextStyle(
                        color: Color.brightGreen,
                        bold: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          const Container(
            width: 40,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text('Numbers: 0-9', style: TextStyle(color: Color.black)),
                Text(
                  'Operators: + - * /',
                  style: TextStyle(color: Color.black),
                ),
                Text(
                  'Calculate: = or Enter',
                  style: TextStyle(color: Color.black),
                ),
                Text(
                  'Clear: C | Back: ESC',
                  style: TextStyle(color: Color.black),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Row(
            children: [
              const Text('Current Operation: '),
              Text(
                _operation.isEmpty ? 'None' : '$_firstNumber $_operation',
                style: const TextStyle(color: Color.cyan, bold: true),
              ),
            ],
          ),

          const SizedBox(height: 1),

          const Text(
            'Start typing numbers and operators!',
            style: TextStyle(color: Color.magenta, italic: true),
          ),
        ],
      ),
    );
  }
}
