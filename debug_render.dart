import 'package:radartui/radartui.dart';

void main() {
  runApp(const DebugRenderApp());
}

class DebugRenderApp extends StatefulWidget {
  const DebugRenderApp();

  @override
  State<DebugRenderApp> createState() => _DebugRenderAppState();
}

class _DebugRenderAppState extends State<DebugRenderApp> {
  final TextEditingController _controller = TextEditingController();
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _debugInfo = 'Text: "${_controller.text}" (len=${_controller.text.length})\n'
                    'Cursor: ${_controller.cursorPosition}\n'
                    'Expected: should show all ${_controller.text.length} chars';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Debug TextField Rendering', style: TextStyle(color: Color.cyan, bold: true)),
        const SizedBox(height: 1),
        const Text('Type 1234 and see if all characters appear:', style: TextStyle(color: Color.white)),
        TextField(
          controller: _controller,
          placeholder: 'Type 1234 here',
          style: const TextStyle(color: Color.yellow),
        ),
        const SizedBox(height: 2),
        Container(
          width: 50,
          height: 8,
          color: Color.brightBlack,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Text(_debugInfo, style: const TextStyle(color: Color.white)),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}