import 'package:radartui/radartui.dart';

void main() {
  print('=== Visual Bug Test ===');
  print('This test shows the actual visual rendering bug');
  print('Look at the TUI output to see if field shows "123" vs "1234"');
  
  runApp(const VisualBugTest());
}

class VisualBugTest extends StatefulWidget {
  const VisualBugTest();

  @override
  State<VisualBugTest> createState() => _VisualBugTestState();
}

class _VisualBugTestState extends State<VisualBugTest> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Set up the bug scenario by directly manipulating controllers
    // This simulates what happens after typing
    
    // Field 1: "hello" (working normally)
    _controller1.text = "hello";
    
    // Field 2: This is where the bug should appear
    // If the bug exists, setting text to "1234" might only render "123"
    _controller2.text = "1234";
    
    print('Controllers set:');
    print('  Field 1: "${_controller1.text}" (${_controller1.text.length} chars)');
    print('  Field 2: "${_controller2.text}" (${_controller2.text.length} chars)');
    print('');
    print('Now check the TUI display:');
    print('  - Does Field 1 show "hello"?');
    print('  - Does Field 2 show "1234" or only "123"?');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('VISUAL BUG TEST', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        const Text('Check if rendered text matches controller text', 
             style: TextStyle(color: Color.cyan)),
        const SizedBox(height: 2),
        
        const Text('Field 1 (should show "hello"):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (should show "1234"):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          style: const TextStyle(color: Color.green),
        ),
        const SizedBox(height: 2),
        
        Container(
          width: 60,
          height: 8,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text('Controller Values:', style: TextStyle(color: Color.cyan)),
                Text('Field 1: "${_controller1.text}" (${_controller1.text.length})',
                     style: const TextStyle(color: Color.white)),
                Text('Field 2: "${_controller2.text}" (${_controller2.text.length})',
                     style: const TextStyle(color: Color.white)),
                const SizedBox(height: 1),
                const Text('Visual Check:', style: TextStyle(color: Color.yellow)),
                const Text('Does displayed text match controller?',
                     style: TextStyle(color: Color.white)),
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