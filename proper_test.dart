import 'package:radartui/radartui.dart';

void main() async {
  print('=== Proper TextField Bug Test ===');
  
  // Start the app
  runApp(const ProperTestApp());
  
  // Wait for initialization
  await Future.delayed(Duration(milliseconds: 200));
  
  print('1. App started - First field should have focus');
  
  // Type "abc" in first field
  print('2. Typing "abc" in first field...');
  _sendCharInput('a');
  await Future.delayed(Duration(milliseconds: 50));
  _sendCharInput('b');
  await Future.delayed(Duration(milliseconds: 50));
  _sendCharInput('c');
  await Future.delayed(Duration(milliseconds: 100));
  
  // Send Tab to switch focus
  print('3. Pressing Tab to switch focus...');
  _sendTabInput();
  await Future.delayed(Duration(milliseconds: 100));
  
  // Type "1234" rapidly in second field  
  print('4. Typing "1234" rapidly in second field...');
  _sendCharInput('1');
  await Future.delayed(Duration(milliseconds: 30));
  _sendCharInput('2');
  await Future.delayed(Duration(milliseconds: 30));
  _sendCharInput('3');
  await Future.delayed(Duration(milliseconds: 30));
  _sendCharInput('4');
  await Future.delayed(Duration(milliseconds: 200));
  
  print('5. Test completed!');
  print('   Check the TUI output above:');
  print('   - Field 1 should show: "abc"');
  print('   - Field 2 should show: "1234" (NOT "123")');
  
  // Keep running to see the result
  await Future.delayed(Duration(seconds: 3));
}

void _sendCharInput(String char) {
  // Use the public inputTest method for character input
  SchedulerBinding.instance.inputTest(char);
}

void _sendTabInput() {
  // For Tab, we need to create the event properly
  // Since inputTest only handles chars, we'll simulate Tab differently
  print('   [Simulating Tab key press for focus switch]');
  FocusManager.instance.currentScope?.nextFocus();
}

class ProperTestApp extends StatefulWidget {
  const ProperTestApp();

  @override
  State<ProperTestApp> createState() => _ProperTestAppState();
}

class _ProperTestAppState extends State<ProperTestApp> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize focus manager
    FocusManager.instance.initialize();
    
    // Add detailed logging
    _controller1.addListener(() {
      print('   >>> Field 1: "${_controller1.text}" (${_controller1.text.length} chars)');
    });
    
    _controller2.addListener(() {
      print('   >>> Field 2: "${_controller2.text}" (${_controller2.text.length} chars)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('ACTUAL BUG TEST', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        
        const Text('Field 1 (starts focused):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'Type abc here',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (Tab to focus):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'Type 1234 after Tab',
          style: const TextStyle(color: Color.green),
        ),
        const SizedBox(height: 1),
        
        Container(
          width: 50,
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
                Text('Test: Should show "abc" and "1234"',
                     style: const TextStyle(color: Color.cyan)),
                Text(_controller2.text == "123" && _controller2.text.length == 3
                    ? 'BUG: Missing 4th character!'
                    : _controller2.text == "1234" && _controller2.text.length == 4
                        ? 'SUCCESS: All characters present!'
                        : 'Status: Waiting for test...',
                     style: TextStyle(
                       color: _controller2.text == "123" ? Color.red : 
                              _controller2.text == "1234" ? Color.green : Color.yellow
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