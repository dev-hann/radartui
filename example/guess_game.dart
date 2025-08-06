import 'dart:async';
import 'dart:math';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

void main() {
  runApp(const GuessGameApp());
}

class GuessGameApp extends StatefulWidget {
  const GuessGameApp();

  @override
  State<GuessGameApp> createState() => _GuessGameAppState();
}

class _GuessGameAppState extends State<GuessGameApp> {
  late int _targetNumber;
  String _currentGuess = '';
  List<String> _guessHistory = [];
  int _attempts = 0;
  bool _gameWon = false;
  String _feedback = 'Enter your guess and press Enter!';
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _startNewGame();
    _sub = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
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
    _guessHistory.clear();
    _attempts = 0;
    _gameWon = false;
    _feedback = 'I\'m thinking of a number between 1-100!';
    AppLogger.log('New game started, target: \$_targetNumber');
  }

  void _handleKeyInput(String key) {
    setState(() {
      if (key.contains(RegExp(r'[0-9]'))) {
        if (_currentGuess.length < 3) {
          _currentGuess += key.trim();
        }
      } else if (key.contains('\n') || key.contains('=')) {
        _submitGuess();
      } else if (key.contains('n') || key.contains('N')) {
        _startNewGame();
      } else if (key.contains('\b') || key.contains('backspace')) {
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
    Color resultColor;
    
    if (guess == _targetNumber) {
      result = 'CORRECT! 🎉';
      resultColor = Color.green;
      _gameWon = true;
      _feedback = 'You won in \$_attempts attempts!';
    } else if (guess < _targetNumber) {
      result = 'Too LOW ⬆️';
      resultColor = Color.blue;
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
      resultColor = Color.red;
      int diff = guess - _targetNumber;
      if (diff <= 5) {
        _feedback = 'Very close! Go lower!';
      } else if (diff <= 15) {
        _feedback = 'Close! Try lower!';
      } else {
        _feedback = 'Too high! Much lower!';
      }
    }
    
    _guessHistory.add('\$_attempts. \$_currentGuess → \$result');
    _currentGuess = '';
    
    if (_attempts >= 10 && !_gameWon) {
      _feedback = 'Game Over! The number was \$_targetNumber';
    }
  }

  Widget _buildGuessHistory() {
    if (_guessHistory.isEmpty) {
      return Text(
        'No guesses yet...',
        style: TextStyle(color: Color.brightBlack, italic: true),
      );
    }
    
    return Column(
      children: _guessHistory.reversed.take(5).map((guess) {
        Color color = Color.white;
        if (guess.contains('CORRECT')) color = Color.green;
        else if (guess.contains('LOW')) color = Color.blue;
        else if (guess.contains('HIGH')) color = Color.red;
        
        return Text(guess, style: TextStyle(color: color));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          // Title
          Container(
            width: 60,
            color: Color.magenta,
            child: Center(
              child: Text(
                '🎯 Number Guessing Game 🎯',
                style: TextStyle(
                  color: Color.white,
                  bold: true,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 1),
          
          // Game status
          Container(
            width: 60,
            color: _gameWon ? Color.green : (_attempts >= 10 ? Color.red : Color.blue),
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Attempts: \$_attempts/10',
                  style: TextStyle(color: Color.white, bold: true),
                ),
                Text(
                  _feedback,
                  style: TextStyle(color: Color.white),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 1),
          
          // Input area
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Row(children: [
                  Text('Your guess: ', style: TextStyle(color: Color.yellow)),
                  Text(
                    _currentGuess.isEmpty ? '_' : _currentGuess,
                    style: TextStyle(
                      color: Color.brightYellow,
                      bold: true,
                    ),
                  ),
                ]),
                Text(
                  'Type numbers and press Enter',
                  style: TextStyle(color: Color.brightBlack, italic: true),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 1),
          
          // History
          Container(
            width: 60,
            height: 7,
            color: Color.black,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Recent Guesses:',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                _buildGuessHistory(),
              ],
            ),
          ),
          
          SizedBox(height: 1),
          
          // Controls
          Container(
            width: 60,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Controls:',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text('Numbers: Type your guess', style: TextStyle(color: Color.black)),
                Text('Enter: Submit guess', style: TextStyle(color: Color.black)),
                Text('N: New game', style: TextStyle(color: Color.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}