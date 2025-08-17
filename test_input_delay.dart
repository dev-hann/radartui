import 'package:radartui/radartui.dart';

void main() {
  runApp(const InputDelayTest());
}

class InputDelayTest extends StatefulWidget {
  const InputDelayTest();

  @override
  State<InputDelayTest> createState() => _InputDelayTestState();
}

class _InputDelayTestState extends State<InputDelayTest> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _log = '';

  @override
  void initState() {
    super.initState();
    
    // Add detailed logging to track input behavior
    _controller1.addListener(() {
      _addLog('C1: "${_controller1.text}" cursor:${_controller1.cursorPosition}');
    });
    
    _controller2.addListener(() {
      _addLog('C2: "${_controller2.text}" cursor:${_controller2.cursorPosition}');
    });
  }

  void _addLog(String message) {
    setState(() {
      _log = '$message\n$_log';
      final lines = _log.split('\n');
      if (lines.length > 8) {
        _log = lines.take(8).join('\n');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Input Delay Test', style: TextStyle(color: Color.cyan, bold: true)),
        const SizedBox(height: 1),
        const Text('Field 1:', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'Type here first',
          style: const TextStyle(color: Color.yellow),
          onChanged: (text) => _addLog('onChange1: "$text"'),
        ),
        const SizedBox(height: 1),
        const Text('Field 2 (Tab here):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'Then Tab here and type',
          style: const TextStyle(color: Color.green),
          onChanged: (text) => _addLog('onChange2: "$text"'),
        ),
        const SizedBox(height: 1),
        Container(
          width: 60,
          height: 10,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Text(_log, style: const TextStyle(color: Color.white)),
          ),
        ),
        const Text('Test: Type in field 1, Tab to field 2, type again', 
                   style: TextStyle(color: Color.cyan)),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}