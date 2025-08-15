import 'dart:async';
import 'dart:math';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class GuessGameExample extends StatefulWidget {
  const GuessGameExample();

  @override
  State<GuessGameExample> createState() => _GuessGameExampleState();
}

class _GuessGameExampleState extends State<GuessGameExample> {
  late int _targetNumber;
  String _currentGuess = '';
  List<String> guessHistory = [];
  int _attempts = 0;
  bool _gameWon = false;
  String _feedback = 'Enter your guess and press Enter!';
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _startNewGame();
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

  void _startNewGame() {
    _targetNumber = Random().nextInt(100) + 1;
    _currentGuess = '';
    guessHistory.clear();
    _attempts = 0;
    _gameWon = false;
    _feedback = 'I\'m thinking of a number between 1-100!';
  }

  bool isDigit(String? char) {
    if (char == null) return false;
    return '0123456789'.contains(char);
  }

  void _handleKeyInput(KeyEvent key) {
    setState(() {
      if (key.code == KeyCode.char && isDigit(key.char)) {
        if (_currentGuess.length < 3) {
          _currentGuess += key.char!;
        }
      } else if (key.code == KeyCode.enter) {
        _submitGuess();
      } else if (key.code == KeyCode.char &&
          (key.char == 'n' || key.char == 'N')) {
        _startNewGame();
      } else if (key.code == KeyCode.backspace) {
        if (_currentGuess.isNotEmpty) {
          _currentGuess = _currentGuess.substring(0, _currentGuess.length - 1);
        }
      }
    });
  }

  void _submitGuess() {
    if (_currentGuess.isEmpty) return;

    int guess = int.parse(_currentGuess);
    _attempts++;

    String result;

    if (guess == _targetNumber) {
      result = 'CORRECT! 🎉';
      _gameWon = true;
      _feedback = 'You won in $_attempts attempts!';
    } else if (guess < _targetNumber) {
      result = 'Too LOW ⬆️';
      int diff = _targetNumber - guess;
      if (diff <= 5) {
        _feedback = 'Very close! Go higher!';
      } else if (diff <= 15) {
        _feedback = 'Close! Try higher!';
      } else {
        _feedback = 'Too low! Much higher!';
      }
    } else {
      result = 'Too HIGH ⬇️';
      int diff = guess - _targetNumber;
      if (diff <= 5) {
        _feedback = 'Very close! Go lower!';
      } else if (diff <= 15) {
        _feedback = 'Close! Try lower!';
      } else {
        _feedback = 'Too high! Much lower!';
      }
    }

    guessHistory.add('$_attempts. $_currentGuess → $result');
    _currentGuess = '';

    if (_attempts >= 10 && !_gameWon) {
      _feedback = 'Game Over! The number was $_targetNumber';
    }
  }

  Widget _buildGuessHistory() {
    if (guessHistory.isEmpty) {
      return const Text(
        'No guesses yet...',
        style: TextStyle(color: Color.brightBlack, italic: true),
      );
    }

    return Column(
      children:
          guessHistory.reversed.take(5).map((guess) {
            Color color = Color.white;
            if (guess.contains('CORRECT'))
              color = Color.green;
            else if (guess.contains('LOW'))
              color = Color.blue;
            else if (guess.contains('HIGH'))
              color = Color.red;

            return Text(guess, style: TextStyle(color: color));
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 60,
            color: Color.magenta,
            child: Center(
              child: Text(
                '🎯 Number Guessing Game 🎯',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),

          const SizedBox(height: 1),

          Container(
            width: 60,
            color:
                _gameWon
                    ? Color.green
                    : (_attempts >= 10 ? Color.red : Color.blue),
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Attempts: $_attempts/10',
                  style: const TextStyle(color: Color.white, bold: true),
                ),
                Text(_feedback, style: const TextStyle(color: Color.white)),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Your guess: ',
                      style: TextStyle(color: Color.yellow),
                    ),
                    Text(
                      _currentGuess.isEmpty ? '_' : _currentGuess,
                      style: const TextStyle(
                        color: Color.brightYellow,
                        bold: true,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Type numbers and press Enter',
                  style: TextStyle(color: Color.brightBlack, italic: true),
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Container(
            width: 60,
            height: 7,
            color: Color.black,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Recent Guesses:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                _buildGuessHistory(),
              ],
            ),
          ),

          const SizedBox(height: 1),

          const Container(
            width: 60,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Controls:',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text(
                  'Numbers: Type your guess',
                  style: TextStyle(color: Color.black),
                ),
                Text(
                  'Enter: Submit | N: New game | ESC: Return',
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
