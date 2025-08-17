import 'package:radartui/radartui.dart';

void main() {
  runApp(const NoCallbacksTest());
}

class NoCallbacksTest extends StatefulWidget {
  const NoCallbacksTest();

  @override
  State<NoCallbacksTest> createState() => _NoCallbacksTestState();
}

class _NoCallbacksTestState extends State<NoCallbacksTest> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Test WITHOUT onChanged callbacks', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        const Text('1. Type in Field 1, then TAB to Field 2', style: TextStyle(color: Color.cyan)),
        const Text('2. Type "1234" quickly in Field 2', style: TextStyle(color: Color.cyan)),
        const Text('3. Check if all characters appear correctly', style: TextStyle(color: Color.cyan)),
        const SizedBox(height: 2),
        
        const Text('Field 1:', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller1,
          placeholder: 'Type here first',
          style: const TextStyle(color: Color.yellow),
          // NO onChanged callback
        ),
        const SizedBox(height: 1),
        
        const Text('Field 2 (TAB here):', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller2,
          placeholder: 'Then TAB here and type 1234',
          style: const TextStyle(color: Color.green),
          // NO onChanged callback
        ),
        const SizedBox(height: 2),
        
        Container(
          width: 60,
          height: 5,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Field 1: "${_controller1.text}" (${_controller1.text.length} chars)', 
                     style: const TextStyle(color: Color.white)),
                Text('Field 2: "${_controller2.text}" (${_controller2.text.length} chars)', 
                     style: const TextStyle(color: Color.white)),
                Text('If bug exists, Field 2 will show "123" when you type "1234"', 
                     style: const TextStyle(color: Color.yellow)),
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