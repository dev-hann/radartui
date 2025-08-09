import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class StyleExample extends StatefulWidget {
  final VoidCallback onBack;
  const StyleExample({required this.onBack});

  @override
  State<StyleExample> createState() => _StyleExampleState();
}

class _StyleExampleState extends State<StyleExample> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        widget.onBack();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Container(
          width: 60,
          height: 3,
          color: Color.blue,
          child: Center(
            child: Text(
              '🎨 RadarTUI Style Demo 🎨',
              style: TextStyle(
                color: Color.brightWhite,
                bold: true,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 1),
        
        const Text(
          'Basic Colors:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        const Row(children: [
          Text('Red: ', style: TextStyle(color: Color.red, bold: true)),
          Text('Green: ', style: TextStyle(color: Color.green, bold: true)),
          Text('Blue: ', style: TextStyle(color: Color.blue, bold: true)),
          Text('Yellow: ', style: TextStyle(color: Color.yellow, bold: true)),
        ]),
        
        const SizedBox(height: 1),
        
        const Text(
          'Background Colors:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        const Row(children: [
          Container(
            color: Color.red,
            child: Text(' RED BG ', style: TextStyle(color: Color.white)),
          ),
          SizedBox(width: 2),
          Container(
            color: Color.green,
            child: Text(' GREEN BG ', style: TextStyle(color: Color.black)),
          ),
          SizedBox(width: 2),
          Container(
            color: Color.blue,
            child: Text(' BLUE BG ', style: TextStyle(color: Color.white)),
          ),
        ]),
        
        const SizedBox(height: 1),
        
        const Text(
          'Text Styles:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        const Column(children: [
          Text('Bold Text', style: TextStyle(bold: true)),
          Text('Italic Text', style: TextStyle(italic: true)),
          Text('Underlined Text', style: TextStyle(underline: true)),
          Text(
            'Combined Styles',
            style: TextStyle(
              bold: true,
              italic: true,
              underline: true,
              color: Color.magenta,
            ),
          ),
        ]),
        
        const SizedBox(height: 1),
        
        const Text(
          'Container with Padding & Margin:',
          style: TextStyle(bold: true, underline: true),
        ),
        
        const Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(h: 4, v: 1),
          color: Color.cyan,
          child: Text(
            'This is inside a styled container!',
            style: TextStyle(color: Color.black, bold: true),
          ),
        ),
        
        const SizedBox(height: 1),
        
        const Text(
          'Press ESC to return to menu',
          style: TextStyle(
            color: Color.brightYellow,
            italic: true,
          ),
        ),
      ],
    );
  }
}