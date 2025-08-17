import 'package:radartui/radartui.dart';

void main() async {
  print('=== Starting Programmatic TextField Test ===');
  
  // Start the app
  runApp(const TestApp());
  
  // Wait a moment for the app to initialize
  await Future.delayed(Duration(milliseconds: 100));
  
  print('1. App initialized with two TextFields');
  
  // Simulate typing in first field
  print('2. Typing "abc" in first field...');
  SchedulerBinding.instance.inputTest('a');
  await Future.delayed(Duration(milliseconds: 50));
  SchedulerBinding.instance.inputTest('b'); 
  await Future.delayed(Duration(milliseconds: 50));
  SchedulerBinding.instance.inputTest('c');
  await Future.delayed(Duration(milliseconds: 100));
  
  // Simulate Tab to switch focus
  print('3. Pressing Tab to switch to second field...');
  // Note: Need to check how Tab is handled in this framework
  // This might need adjustment based on the key handling
  
  // Simulate typing "1234" rapidly in second field
  print('4. Typing "1234" rapidly in second field...');
  SchedulerBinding.instance.inputTest('1');
  await Future.delayed(Duration(milliseconds: 30));
  SchedulerBinding.instance.inputTest('2');
  await Future.delayed(Duration(milliseconds: 30));
  SchedulerBinding.instance.inputTest('3');
  await Future.delayed(Duration(milliseconds: 30));
  SchedulerBinding.instance.inputTest('4');
  await Future.delayed(Duration(milliseconds: 100));
  
  print('5. Test completed - check the visual output above');
  print('   If bug exists: second field shows "123"');
  print('   If bug fixed: second field shows "1234"');
  
  // Keep app running for a moment to see result
  await Future.delayed(Duration(seconds: 2));
  
  print('=== Test Finished ===');
}

class TestApp extends StatefulWidget {
  const TestApp();

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Add listeners to track changes
    _controller1.addListener(() {
      print('   Field 1 changed: "${_controller1.text}" (${_controller1.text.length} chars)');
    });
    
    _controller2.addListener(() {
      print('   Field 2 changed: "${_controller2.text}" (${_controller2.text.length} chars)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('PROGRAMMATIC TEST', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        
        const Text('Field 1:', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'First field',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (focus with Tab):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'Second field - type 1234',
          style: const TextStyle(color: Color.green),
        ),
        const SizedBox(height: 1),
        
        // Real-time status
        Container(
          width: 50,
          height: 4,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Field 1: "${_controller1.text}"', style: const TextStyle(color: Color.white)),
                Text('Field 2: "${_controller2.text}"', style: const TextStyle(color: Color.white)),
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