import 'package:radartui/radartui.dart';

void main() {
  runApp(const DebugRenderingApp());
}

class DebugRenderingApp extends StatefulWidget {
  const DebugRenderingApp();

  @override
  State<DebugRenderingApp> createState() => _DebugRenderingAppState();
}

class _DebugRenderingAppState extends State<DebugRenderingApp> {
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Add listener to track controller changes
    _controller2.addListener(() {
      print('Controller changed: text="${_controller2.text}" cursor=${_controller2.cursorPosition}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Debug: Controller vs Visual Rendering', 
             style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        
        // Simple single field test
        const Text('Single TextField Test (type 1234):', 
             style: TextStyle(color: Color.cyan)),
        TextField(
          controller: _controller2,
          placeholder: 'Type 1234 here',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 2),
        
        // Debug info
        Container(
          width: 50,
          height: 4,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                Text('Controller: "${_controller2.text}" (${_controller2.text.length})',
                     style: const TextStyle(color: Color.white)),
                Text('Cursor: ${_controller2.cursorPosition}',
                     style: const TextStyle(color: Color.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
        const Text('Check: Does visual match controller values?', 
             style: TextStyle(color: Color.yellow)),
      ],
    );
  }

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }
}