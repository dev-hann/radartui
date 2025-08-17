import 'package:radartui/radartui.dart';

void main() {
  runApp(const DebugRenderDetails());
}

class DebugRenderDetails extends StatefulWidget {
  const DebugRenderDetails();

  @override
  State<DebugRenderDetails> createState() => _DebugRenderDetailsState();
}

class _DebugRenderDetailsState extends State<DebugRenderDetails> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {}); // Force rebuild to update debug info
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('TextField Rendering Debug', style: TextStyle(color: Color.red, bold: true)),
        const SizedBox(height: 1),
        const Text('Type 1234 and watch the debug info below', style: TextStyle(color: Color.cyan)),
        const SizedBox(height: 1),
        
        TextField(
          controller: _controller,
          placeholder: 'Type 1234 here',
          style: const TextStyle(color: Color.yellow),
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
                Text('Text: "${_controller.text}"', style: const TextStyle(color: Color.white)),
                Text('Length: ${_controller.text.length}', style: const TextStyle(color: Color.white)),
                Text('Cursor: ${_controller.cursorPosition}', style: const TextStyle(color: Color.white)),
                Text('Expected size: ${_controller.text.length + 1}', style: const TextStyle(color: Color.white)),
                const Text('Issue: Last char cut off in second field after Tab?', 
                     style: TextStyle(color: Color.yellow)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
        const Text('This is a single TextField - does it work correctly?', 
             style: TextStyle(color: Color.cyan)),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}