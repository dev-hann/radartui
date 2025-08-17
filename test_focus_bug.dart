import 'package:radartui/radartui.dart';

void main() {
  runApp(const FocusBugTest());
}

class FocusBugTest extends StatefulWidget {
  const FocusBugTest();

  @override
  State<FocusBugTest> createState() => _FocusBugTestState();
}

class _FocusBugTestState extends State<FocusBugTest> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _testResult = 'NOT TESTED';

  @override
  void initState() {
    super.initState();
    
    // Monitor changes to detect the bug
    _controller2.addListener(() {
      final text = _controller2.text;
      final cursor = _controller2.cursorPosition;
      
      // Test case: if user types "1234", we should see all 4 characters
      if (text == "123" && cursor == 3) {
        setState(() {
          _testResult = 'BUG DETECTED: Expected "1234", got "123"';
        });
      } else if (text == "1234" && cursor == 4) {
        setState(() {
          _testResult = 'SUCCESS: All characters "1234" displayed correctly';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Focus Bug Reproduction Test', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        const Text('1. Type something in Field 1', style: TextStyle(color: Color.cyan)),
        const Text('2. Press TAB to move to Field 2', style: TextStyle(color: Color.cyan)),
        const Text('3. Type "1234" quickly in Field 2', style: TextStyle(color: Color.cyan)),
        const Text('4. Check if all 4 characters appear', style: TextStyle(color: Color.cyan)),
        const SizedBox(height: 2),
        
        const Text('Field 1 (Type here first):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'Type here first, then press TAB',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (TAB here, then type "1234"):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'After TAB, type 1234 here',
          style: const TextStyle(color: Color.green),
        ),
        const SizedBox(height: 2),
        
        Container(
          width: 70,
          height: 8,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Field 1: "${_controller1.text}" (${_controller1.text.length} chars)', 
                     style: const TextStyle(color: Color.white)),
                Text('Field 2: "${_controller2.text}" (${_controller2.text.length} chars)', 
                     style: const TextStyle(color: Color.white)),
                Text('Cursor 2: ${_controller2.cursorPosition}', 
                     style: const TextStyle(color: Color.white)),
                const SizedBox(height: 1),
                Text('Result: $_testResult', 
                     style: TextStyle(
                       color: _testResult.contains('BUG') ? Color.red : 
                              _testResult.contains('SUCCESS') ? Color.green : Color.yellow
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