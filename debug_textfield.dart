import 'package:radartui/radartui.dart';

void main() {
  runApp(const DebugTextFieldApp());
}

class DebugTextFieldApp extends StatefulWidget {
  const DebugTextFieldApp();

  @override
  State<DebugTextFieldApp> createState() => _DebugTextFieldAppState();
}

class _DebugTextFieldAppState extends State<DebugTextFieldApp> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _debugLog = '';
  int _eventCounter = 0;

  @override
  void initState() {
    super.initState();
    _controller1.text = 'Field1';
    
    // 컨트롤러 디버깅
    _controller1.addListener(() {
      _addDebugLog('Controller1 changed: "${_controller1.text}" cursor:${_controller1.cursorPosition}');
    });
    
    _controller2.addListener(() {
      _addDebugLog('Controller2 changed: "${_controller2.text}" cursor:${_controller2.cursorPosition}');
    });
  }

  void _addDebugLog(String message) {
    setState(() {
      _eventCounter++;
      _debugLog = '$_eventCounter: $message\n$_debugLog';
      // 최대 10줄까지만 유지
      final lines = _debugLog.split('\n');
      if (lines.length > 10) {
        _debugLog = lines.take(10).join('\n');
      }
    });
  }

  void _onChanged1(String text) {
    _addDebugLog('onChanged1 called: "$text"');
  }

  void _onChanged2(String text) {
    _addDebugLog('onChanged2 called: "$text"');
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 70,
            height: 3,
            color: Color.red,
            child: Center(
              child: Text(
                'DEBUG: TextField Focus Test',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 1),
          const Text(
            'Field 1:',
            style: TextStyle(color: Color.cyan),
          ),
          TextField(
            controller: _controller1,
            placeholder: 'Field 1',
            style: const TextStyle(color: Color.white),
            onChanged: _onChanged1,
          ),
          const SizedBox(height: 1),
          const Text(
            'Field 2 (TAB to focus here):',
            style: TextStyle(color: Color.yellow),
          ),
          TextField(
            controller: _controller2,
            placeholder: 'Field 2',
            style: const TextStyle(color: Color.green),
            onChanged: _onChanged2,
          ),
          const SizedBox(height: 1),
          const Text(
            'Debug Log:',
            style: TextStyle(color: Color.magenta, bold: true),
          ),
          Container(
            width: 70,
            height: 10,
            color: Color.brightBlack,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                _debugLog,
                style: const TextStyle(color: Color.white),
              ),
            ),
          ),
          const SizedBox(height: 1),
          const Text(
            'Instructions: Type in Field1, then TAB to Field2, then type',
            style: TextStyle(color: Color.cyan, italic: true),
          ),
        ],
      ),
    );
  }
}