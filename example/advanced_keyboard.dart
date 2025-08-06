import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';
import 'package:radartui/src/services/key_parser.dart';

void main() {
  runApp(const AdvancedKeyboardApp());
}

class AdvancedKeyboardApp extends StatefulWidget {
  const AdvancedKeyboardApp();

  @override
  State<AdvancedKeyboardApp> createState() => _AdvancedKeyboardAppState();
}

class _AdvancedKeyboardAppState extends State<AdvancedKeyboardApp> {
  List<String> _keyHistory = [];
  String _currentInput = '';
  int _cursor = 0;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = SchedulerBinding.instance.keyboard.keyEvents.listen((KeyEvent keyEvent) {
      _handleKeyEvent(keyEvent);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    setState(() {
      _keyHistory.add('${keyEvent.key} (${keyEvent.isSpecial ? keyEvent.specialType : 'printable'})');
      if (_keyHistory.length > 15) {
        _keyHistory.removeAt(0);
      }
      
      // Handle text input
      if (!keyEvent.isSpecial) {
        _currentInput = _currentInput.substring(0, _cursor) + 
                       keyEvent.key + 
                       _currentInput.substring(_cursor);
        _cursor++;
      } else {
        switch (keyEvent.key) {
          case 'Backspace':
            if (_cursor > 0) {
              _currentInput = _currentInput.substring(0, _cursor - 1) + 
                             _currentInput.substring(_cursor);
              _cursor--;
            }
            break;
          case 'Delete':
            if (_cursor < _currentInput.length) {
              _currentInput = _currentInput.substring(0, _cursor) + 
                             _currentInput.substring(_cursor + 1);
            }
            break;
          case 'ArrowLeft':
            if (_cursor > 0) _cursor--;
            break;
          case 'ArrowRight':
            if (_cursor < _currentInput.length) _cursor++;
            break;
          case 'Home':
            _cursor = 0;
            break;
          case 'End':
            _cursor = _currentInput.length;
            break;
          case 'Enter':
            _currentInput = '';
            _cursor = 0;
            break;
          case 'Escape':
            _currentInput = '';
            _cursor = 0;
            _keyHistory.clear();
            break;
        }
      }
    });
  }

  Widget _buildInputDisplay() {
    if (_currentInput.isEmpty) {
      return Text(
        '_',
        style: TextStyle(color: Color.brightYellow, bold: true),
      );
    }
    
    List<Widget> chars = [];
    for (int i = 0; i < _currentInput.length; i++) {
      if (i == _cursor) {
        chars.add(Text(
          '|${_currentInput[i]}',
          style: TextStyle(color: Color.brightYellow, bold: true),
        ));
      } else {
        chars.add(Text(_currentInput[i], style: TextStyle(color: Color.white)));
      }
    }
    
    // Add cursor at the end if needed
    if (_cursor == _currentInput.length) {
      chars.add(Text('|', style: TextStyle(color: Color.brightYellow, bold: true)));
    }
    
    return Row(children: chars);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          // Title
          Container(
            width: 70,
            color: Color.cyan,
            child: Center(
              child: Text(
                '⌨️  RadarTUI Advanced Keyboard Test ⌨️',
                style: TextStyle(
                  color: Color.black,
                  bold: true,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 1),
          
          // Current input
          Container(
            width: 70,
            height: 3,
            color: Color.brightBlack,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Text Input (Cursor: $_cursor):',
                  style: TextStyle(color: Color.green, bold: true),
                ),
                _buildInputDisplay(),
              ],
            ),
          ),
          
          SizedBox(height: 1),
          
          // Key history
          Container(
            width: 70,
            height: 17,
            color: Color.black,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Key Event History:',
                  style: TextStyle(color: Color.yellow, bold: true),
                ),
                SizedBox(height: 1),
                ...(_keyHistory.reversed.take(14).map((key) {
                  Color color = Color.white;
                  if (key.contains('arrow')) color = Color.blue;
                  else if (key.contains('control')) color = Color.red;
                  else if (key.contains('edit')) color = Color.magenta;
                  else if (key.contains('navigation')) color = Color.cyan;
                  else if (key.contains('printable')) color = Color.green;
                  
                  return Text(key, style: TextStyle(color: color));
                })),
              ],
            ),
          ),
          
          SizedBox(height: 1),
          
          // Instructions
          Container(
            width: 70,
            color: Color.yellow,
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                Text(
                  'Test All Keys:',
                  style: TextStyle(color: Color.black, bold: true),
                ),
                Text('• Arrow keys for cursor movement', style: TextStyle(color: Color.black)),
                Text('• Backspace/Delete for editing', style: TextStyle(color: Color.black)),
                Text('• Home/End for line navigation', style: TextStyle(color: Color.black)),
                Text('• Enter to clear input', style: TextStyle(color: Color.black)),
                Text('• Escape to clear all', style: TextStyle(color: Color.black)),
                Text('• Try Ctrl combinations too!', style: TextStyle(color: Color.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}