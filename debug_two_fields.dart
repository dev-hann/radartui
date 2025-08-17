import 'package:radartui/radartui.dart';

void main() {
  runApp(const DebugTwoFields());
}

class DebugTwoFields extends StatefulWidget {
  const DebugTwoFields();

  @override
  State<DebugTwoFields> createState() => _DebugTwoFieldsState();
}

class _DebugTwoFieldsState extends State<DebugTwoFields> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Two Field Focus Debug', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        const Text('EXACT TEST: Type in Field 1, TAB to Field 2, type "1234"', 
             style: TextStyle(color: Color.cyan)),
        const SizedBox(height: 1),
        
        const Text('Field 1:', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'Type here first',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (TAB here and type 1234):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'Type 1234 after TAB',
          style: const TextStyle(color: Color.green),
        ),
        const SizedBox(height: 2),
        
        Container(
          width: 60,
          height: 6,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Field 1: "${_controller1.text}" (${_controller1.text.length})',
                     style: const TextStyle(color: Color.white)),
                Text('Field 2: "${_controller2.text}" (${_controller2.text.length})',
                     style: const TextStyle(color: Color.white)),
                Text('Cursor 2: ${_controller2.cursorPosition}',
                     style: const TextStyle(color: Color.white)),
                Text(_controller2.text == "123" && _controller2.cursorPosition == 3
                    ? 'BUG: Missing 4th character!'
                    : _controller2.text == "1234" && _controller2.cursorPosition == 4
                        ? 'SUCCESS: All chars present'
                        : 'Status: ${_controller2.text.length}/4 chars',
                     style: TextStyle(
                       color: _controller2.text == "123" ? Color.red : Color.green
                     )),
              ],
            ),
          ),
        ),
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