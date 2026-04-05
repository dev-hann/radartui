import 'dart:async';
import 'package:radartui/radartui.dart';

class FocusExample extends StatefulWidget {
  const FocusExample();

  @override
  State<FocusExample> createState() => _FocusExampleState();
}

class _FocusExampleState extends State<FocusExample> {
  String _focusedButton = 'None';
  StreamSubscription? _keySubscription;
  late FocusNode _nodeA;
  late FocusNode _nodeB;
  late FocusNode _nodeC;

  @override
  void initState() {
    super.initState();
    _nodeA = FocusNode();
    _nodeB = FocusNode();
    _nodeC = FocusNode();
    _nodeA.addListener(() => _onFocusChanged('Button A', _nodeA));
    _nodeB.addListener(() => _onFocusChanged('Button B', _nodeB));
    _nodeC.addListener(() => _onFocusChanged('Button C', _nodeC));
    _keySubscription =
        ServicesBinding.instance.keyboard.keyEvents.listen((key) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _nodeA.dispose();
    _nodeB.dispose();
    _nodeC.dispose();
    super.dispose();
  }

  void _onFocusChanged(String name, FocusNode node) {
    if (node.hasFocus) {
      setState(() {
        _focusedButton = name;
      });
    }
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '🎯 Focus Management Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Use Tab to cycle focus between buttons:',
            style: TextStyle(color: Color.cyan),
          ),
          const SizedBox(height: 2),
          Focus(
            focusNode: _nodeA,
            child: Button(
              text: 'Button A',
              focusNode: _nodeA,
              onPressed: () {
                setState(() {
                  _focusedButton = 'Button A pressed!';
                });
              },
            ),
          ),
          const SizedBox(height: 1),
          Focus(
            focusNode: _nodeB,
            child: Button(
              text: 'Button B',
              focusNode: _nodeB,
              onPressed: () {
                setState(() {
                  _focusedButton = 'Button B pressed!';
                });
              },
            ),
          ),
          const SizedBox(height: 1),
          Focus(
            focusNode: _nodeC,
            child: Button(
              text: 'Button C',
              focusNode: _nodeC,
              onPressed: () {
                setState(() {
                  _focusedButton = 'Button C pressed!';
                });
              },
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 40,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Text(
              'Focused: $_focusedButton',
              style: const TextStyle(color: Color.yellow, bold: true),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
